import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DashBoard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new DashBoardState();
  }
}


class DashBoardState extends State<DashBoard>{

  final  platform = const MethodChannel('com.flutter.lgyw/sensor');
  bool _isGetPressure=false;
  int pressures=0;final double wholeCirclesRadian=6.283185307179586;
  ///虽然一个圆被分割为160份，但是只显示120份
  final int tableCount=160;
  Size dashBoardSize;
  double tableSpace;

  @override
  void initState() {
    super.initState();
    dashBoardSize=new Size(300.0,300.0);
    tableSpace=wholeCirclesRadian/tableCount;
  }

  @override
  Widget build(BuildContext context) {
    print("time is ${DateTime .now().millisecondsSinceEpoch}");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("汽车仪表盘"),
      ),
      body: new Center(
        child:GestureDetector(
          onPanDown:(DragDownDetails dragDownDetails){
            _isGetPressure=true;
            boostSpeed();
          },
          onPanCancel: (){
            handleEndEvent();
          },
          onPanEnd: (DragEndDetails dragEndDetails){
            handleEndEvent();
          },
          child:new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new DashBoardTable(dashBoardSize,tableSpace),
              new CustomPaint(
                size: dashBoardSize,
                painter: new DashBoardIndicatorPainter(pressures,tableSpace),
              )
            ],
          ),
        ),
      ),
    );
  }

  void boostSpeed() async {
    while (_isGetPressure){
      if(pressures<120){
        setState(() {
          pressures++;
        });
      }
      //print("pressures is $pressures");
      await Future.delayed(new Duration(milliseconds: 30));
    }
  }


  void handleEndEvent(){
    _isGetPressure=false;
    bringDownSpeed();
  }


  void bringDownSpeed() async {
    while (!_isGetPressure){
      setState(() {
        pressures--;
      });

      //print("pressures is $pressures");
      if(pressures<=0){
        break;
      }
      await Future.delayed(new Duration(milliseconds: 30));
    }
  }
}


class DashBoardIndicatorPainter extends CustomPainter{

  final int speeds;
  double tableSpace;
  DashBoardIndicatorPainter(this.speeds,this.tableSpace);

  @override
  void paint(Canvas canvas, Size size) {
    drawIndicator( canvas,  size);
    String text;
    if(speeds<100){
      text=(speeds*2).toString()+"KM/H";
    }else{
      int s=speeds-100;
      text=(100*2+s*3).toString()+"KM/H";
    }
    drawSpeendOnDashBoard(text,canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///画实时得速度值到面板上
  void drawSpeendOnDashBoard(String text,Canvas canvas,Size size){
    double halfHeight=size.height/2;
    double halfWidth=size.width/2;
    canvas.save();
    canvas.translate(halfWidth, halfHeight);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(text: text, style: new TextStyle(color:Colors.deepOrangeAccent,fontSize: 25.0,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = 73;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));

    canvas.restore();
  }



  ///画速度指针
  void drawIndicator(Canvas canvas, Size size){
    double halfHeight=size.height/2;
    double halfWidth=size.width/2;
    Path path=new Path();
    path.moveTo(-2.5, 20);
    path.lineTo(2.5, 20);
    path.lineTo(6.0, -30);
    path.lineTo(0.5, -halfHeight+8);
    path.lineTo(-0.5, -halfHeight+8);
    path.lineTo(-6.0, -30);
    path.close();
    canvas.save();

    canvas.translate(halfWidth, halfHeight);
    canvas.rotate((-60+speeds)*tableSpace);

    Paint paint=new Paint();
    paint.color=Colors.red;
    paint.style=PaintingStyle.fill;

    canvas.drawPath(path, paint);


    paint.color=Colors.black;
    canvas.drawCircle(new Offset(0.0,0.0), 6, paint);

    canvas.restore();
  }
}




class DashBoardTablePainter extends CustomPainter{

  final double tableSpace;
  var speedTexts=["0","20","40","60","80","100","120","140","160","180","200","230","260"];

  DashBoardTablePainter(this.tableSpace);

  @override
  void paint(Canvas canvas, Size size) {
    drawTable( canvas,  size);
  }


  ///画仪表盘的表格
  void drawTable(Canvas canvas, Size size){
    print("************");
    canvas.save();
    double halfWidth=size.width/2;
    double halfHeight=size.height/2;
    canvas.translate(halfWidth, halfHeight);

    Paint paintMain=new Paint();
    paintMain.color=Colors.blue;
    paintMain.strokeWidth=2.5;
    paintMain.style=PaintingStyle.fill;


    Paint paintOther=new Paint();
    paintOther.color=Colors.blue;
    paintOther.strokeWidth=1;
    paintOther.style=PaintingStyle.fill;

    drawLongLine(canvas,paintMain,halfHeight,speedTexts[6]);

    canvas.save();
    for(int i=61;i<=120;i++){
      canvas.rotate(tableSpace);
      if(i%10==0){
        int a=(i/10).ceil();
        changePaintColors(paintMain,i);
        drawLongLine(canvas,paintMain,halfHeight,speedTexts[a]);
      }else if(i%5==0){
        changePaintColors(paintMain,i);
        drawMiddleLine(canvas,paintMain,halfHeight);
      }else{
        changePaintColors(paintOther,i);
        drawSmallLine(canvas,paintOther,halfHeight);
      }
    }
    canvas.restore();


    canvas.save();
    for(int i=59;i>=0;i--){
      canvas.rotate(-tableSpace);
      if(i%10==0){
        int a=(i/10).ceil();
        changePaintColors(paintMain,i);
        drawLongLine(canvas,paintMain,halfHeight,speedTexts[a]);
      }else if(i%5==0){
        changePaintColors(paintMain,i);
        drawMiddleLine(canvas,paintMain,halfHeight);
      }else{
        changePaintColors(paintOther,i);
        drawSmallLine(canvas,paintOther,halfHeight);
      }
    }
    canvas.restore();

    canvas.restore();
  }


  void changePaintColors(Paint paint,int value){
    if(value<=20){
      paint.color=Colors.green;
    }else if(value<80){
      paint.color=Colors.blue;
    }else{
      paint.color=Colors.red;
    }
  }

  ///画仪表盘上的长线
  void drawLongLine(Canvas canvas,Paint paintMain,double halfHeight,String text){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0,  -halfHeight+15), paintMain);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(text: text, style: new TextStyle(color:paintMain.color,fontSize: 15.5,));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = -halfHeight+19;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
  }


  void drawMiddleLine(Canvas canvas,Paint paintMain,double halfHeight){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0, -halfHeight+10), paintMain);
  }


  ///画短线
  void drawSmallLine(Canvas canvas,Paint paintOther,double halfHeight){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0, -halfHeight+7), paintOther);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class DashBoardTable extends StatelessWidget{

  final Size dashBoardSize;
  final double tableSpace;

  DashBoardTable(this.dashBoardSize,this.tableSpace);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: dashBoardSize,
      painter: new DashBoardTablePainter(tableSpace),
    );
  }
}
