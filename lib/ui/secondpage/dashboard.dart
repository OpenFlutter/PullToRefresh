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
  int pressures=0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("汽车仪表盘"),
      ),
      body: new Center(
        child:GestureDetector(
          onTapDown:(TapDownDetails tapDownDetails){
            _isGetPressure=true;
            boostSpeed();
          },
          onTapUp: (TapUpDetails tapUpDetails){
            _isGetPressure=false;
            bringDownSpeed();
          },
          child:new CustomPaint(
            size: new Size(300.0,300.0),
            painter: new DashBoardPainter(pressures),
          )
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


class DashBoardPainter extends CustomPainter{

  //12+4
  final double wholeCirclesRadian=6.283185307179586;
  ///虽然一个圆被分割为160份，但是只显示120份
  final int tableCount=160;
  double tableSpace;
  var speedTexts=["0","20","40","60","80","100","120","140","160","180","200","230","260"];
  final int speeds;

  DashBoardPainter(this.speeds){
    tableSpace=wholeCirclesRadian/tableCount;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawIndicator( canvas,  size);
    drawTable( canvas,  size);
    String text;
    if(speeds<100){
      text=(speeds*2).toString()+"KM/H";
    }else{
      int s=speeds-100;
      text=(100*2+s*3).toString()+"KM/H";
    }
    drawSpeendOnDashBoard(text,canvas, size);
  }

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


  void drawTable(Canvas canvas, Size size){
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
        drawLongLine(canvas,paintMain,halfHeight,speedTexts[a]);
      }else if(i%5==0){
        drawMiddleLine(canvas,paintMain,halfHeight);
      }else{
        drawSmallLine(canvas,paintOther,halfHeight);
      }
    }
    canvas.restore();


    canvas.save();
    for(int i=59;i>=0;i--){
      canvas.rotate(-tableSpace);
      if(i%10==0){
        int a=(i/10).ceil();
        drawLongLine(canvas,paintMain,halfHeight,speedTexts[a]);
      }else if(i%5==0){
        drawMiddleLine(canvas,paintMain,halfHeight);
      }else{
        drawSmallLine(canvas,paintOther,halfHeight);
      }
    }
    canvas.restore();

    canvas.restore();
  }



  void drawLongLine(Canvas canvas,Paint paintMain,double halfHeight,String text){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0,  -halfHeight+15), paintMain);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(text: text, style: new TextStyle(color:Colors.blue,fontSize: 15.5,));
    textPainter.layout();
    double textStarPositionX = -textPainter.size.width / 2;
    double textStarPositionY = -halfHeight+19;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
  }


  void drawMiddleLine(Canvas canvas,Paint paintMain,double halfHeight){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0, -halfHeight+10), paintMain);
  }


  void drawSmallLine(Canvas canvas,Paint paintOther,double halfHeight){
    canvas.drawLine(new Offset(0.0, -halfHeight), new Offset(0.0, -halfHeight+7), paintOther);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}