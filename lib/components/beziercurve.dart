import 'package:flutter/material.dart';
import 'dart:math';

class BezierCurve extends StatefulWidget{

  final Size size;
  ///决定 水平面的高度
  final double percentage;
  ///浪尖峰
  final double waveHeight;
  final TextStyle textStyle;
  ///波距  其实是1/4波距
  final double waveDistance;
  final flowSpeed;
  final Color waterColor;
  final Color strokeCircleColor;
  final double circleStrokeWidth;
  final WaterController heightController;


  BezierCurve({
    @required this.size,
    this.waveHeight : 25.0,
    @required this.percentage,
    @required this.textStyle,
    this.waveDistance : 30.0,
    this.flowSpeed : 1.5,
    this.waterColor : const Color(0xffe16009),
    this.strokeCircleColor : const Color(0xFFE0E0E0),
    this.circleStrokeWidth : 4.0,
    @required this.heightController,
  });

  @override
  State<StatefulWidget> createState() {
    return new BezierCurveState();
  }
}


class BezierCurveState extends State<BezierCurve> with SingleTickerProviderStateMixin{
  double _moveForwardDark=0.0;
  double _moveForwardLight=0.0;
  double _waterHeight;
  double _percentage;
  Animation<double> animation;
  AnimationController animationController;
  VoidCallback _voidCallback;
  List<List<double>> pointDark=List();
  List<List<double>> pointLight=List();
  Random _random=new Random();

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _percentage=widget.percentage;
    _waterHeight=(1-_percentage) * widget.size.height;
    widget.heightController.bezierCurveState=this;

    initData();
    animationController = new AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    WidgetsBinding widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      widgetsBinding.addPersistentFrameCallback((callback) {
        if(mounted){
          setState(() {
            _moveForwardDark= _moveForwardDark - widget.flowSpeed- _random.nextDouble()-1;
            if(_moveForwardDark<= - widget.waveDistance*4){
              adjustBezierPoint(pointDark);
              _moveForwardDark=_moveForwardDark+widget.waveDistance*4;
            }

            _moveForwardLight = _moveForwardLight- widget.flowSpeed- _random.nextDouble();
            if(_moveForwardLight <= - widget.waveDistance*4){
              adjustBezierPoint(pointLight);
              _moveForwardLight = _moveForwardLight+widget.waveDistance*4;
            }
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }

  void initData(){
    int count=(widget.size.width/(widget.waveDistance*4)).ceil()+1;
    int maxCount=count*4+1;
    double lastPoint=0.0;
    double waveHei=_waterHeight+widget.waveHeight;
    double waveLow=_waterHeight-widget.waveHeight;
    int m=0;
    // TODO  待完成
    double waves;
    for(int i=0;i<maxCount-2;i=i+2){
      if(m%2==0){
        waves=waveHei;
      }else{
        waves=waveLow;
      }
      createBezierPoint(pointDark,lastPoint,waves);
      createBezierPoint(pointLight,lastPoint,waves);

      lastPoint=lastPoint+widget.waveDistance*2;
      m++;
    }
  }


  void adjustBezierPoint(List<List<double>> list){
    double waveHei=_waterHeight+widget.waveHeight;
    double waveLow=_waterHeight-widget.waveHeight;
    list.removeRange(0, 6);
    list.forEach((points){
      points[0]=points[0]-widget.waveDistance*4;
    });
    double lastPoint= list.last[0];
    createBezierPoint(list,lastPoint,waveHei);
    lastPoint=lastPoint+widget.waveDistance*2;
    createBezierPoint(list,lastPoint,waveLow);
  }




  void adjustPointHeight(double heightDifference){
    pointDark.forEach((points){
      points[1]=points[1]+heightDifference;
    });
    pointLight.forEach((points){
      points[1]=points[1]+heightDifference;
    });
  }



  void createBezierPoint(List<List<double>> list,double lastPoint,double waves){
    //波浪瞎几把动效果添加  但是不同波峰高度之间有断层
//    int a=_random.nextInt(10);
    int a=0;
    if(a%2==0){
      waves=waves-a;
    }else{
      waves=waves+a;
    }
    list.add(  [lastPoint,                       _waterHeight]) ;
    list.add(  [lastPoint+widget.waveDistance,   waves]) ;
    list.add(  [lastPoint+widget.waveDistance*2, _waterHeight]) ;
  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: widget.size,
      painter: new BezierCurvePainter(
        waterHeight: _waterHeight,
        waveHeight:widget.waveHeight,
        moveForward:_moveForwardDark,
        textStyle:widget.textStyle ,
        circleStrokeWidth: widget.circleStrokeWidth,
        strokeCircleColor: widget.strokeCircleColor,
        waterColor: widget.waterColor,
        percentage: _percentage ,
        moveForwardLight: _moveForwardLight,
        pointDark: pointDark,
        pointLight: pointLight,
      ),
    );
  }

  void changeWaterHeight(double h){
    initAnimation(_percentage ,h);
    animationController.forward();
  }


  void initAnimation(double old ,double newPercentage){
    animation = new Tween(begin: old, end: newPercentage).animate(animationController);

    animation.addListener(_voidCallback=() {
        setState(() {
          double value = animation.value;
          _percentage=value;
          double newHeight=(1-_percentage) * widget.size.height;
          adjustPointHeight( newHeight-_waterHeight);
          _waterHeight=newHeight;
        });
    });

    animation.addStatusListener((animationStatus){
      if(animationStatus==AnimationStatus.completed){
        animation.removeListener(_voidCallback);
        animationController.reset();
      }else if(animationStatus==AnimationStatus.forward){

      }
    });
  }
}

class BezierCurvePainter extends CustomPainter{

  final double waterHeight;
  final double waveHeight;
  final double moveForward;
  final Color waterColor;
  final Color strokeCircleColor;
  final TextStyle textStyle;
  final double circleStrokeWidth;
  final double percentage;
  final double moveForwardLight;
  final List<List<double>> pointDark;
  final List<List<double>> pointLight;

  BezierCurvePainter({
    @required this.waterHeight,
    @required this.waveHeight,
    @required this.moveForward,
    @required this.waterColor,
    @required this.strokeCircleColor,
    @required this.textStyle,
    @required this.circleStrokeWidth,
    @required this.percentage,
    @required this.moveForwardLight,
    @required this.pointDark,
    @required this.pointLight
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint layerPaint=new Paint();
    Paint paint =Paint();
    double halfSizeHeight = size.height/2;
    double halfSizeWidth = size.width/2;
    double radius=min(size.width, size.height)/2-circleStrokeWidth/2;

    Path path=Path();
    path.moveTo(0, waterHeight);
    for(int i=0;i<pointDark.length-2;i=i+3){
      path.cubicTo(pointDark[i][0],pointDark[i][1],     pointDark[i+1][0],pointDark[i+1][1],    pointDark[i+2][0], pointDark[i+2][1]);
    }
    path.lineTo(pointDark.last[0],size.height);
    path.lineTo(0,size.height);
    path.close();


    Path path2=Path();
    path2.moveTo(0, waterHeight);
    for(int i=0;i<pointLight.length-2;i=i+3){
      path2.cubicTo(pointLight[i][0],pointLight[i][1],    pointLight[i+1][0],pointLight[i+1][1],    pointLight[i+2][0], pointLight[i+2][1]);
    }
    double waveHeightMax=waterHeight+waveHeight+10.0;
    path2.lineTo(pointLight.last[0], waveHeightMax);
    path2.lineTo(0,waveHeightMax);
    path2.close();


    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);
    paint.style=PaintingStyle.fill;
    canvas.save();
    canvas.translate(moveForwardLight, 0);
    paint.color = waterColor.withAlpha(0x88);
    canvas.drawPath(path2, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(moveForward, 0);
    paint.color = waterColor.withAlpha(0xff);
    canvas.drawPath(path, paint);
    canvas.restore();
    layerPaint.blendMode=BlendMode.dstIn ;
    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0,  size.width, size.height), layerPaint);

    canvas.drawCircle(new Offset(halfSizeWidth, halfSizeHeight), radius-circleStrokeWidth, paint);
    canvas.restore();
    canvas.restore();


    paint.style=PaintingStyle.stroke;
    paint.color=strokeCircleColor;
    paint.strokeWidth=circleStrokeWidth;
    canvas.drawCircle(new Offset(halfSizeWidth, halfSizeHeight), radius, paint);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(text: (percentage*100).toInt().toString()+"%",
        style: textStyle,);
    textPainter.layout();
    double textStarPositionX = halfSizeWidth-textPainter.size.width/2;
    double textStarPositionY = halfSizeHeight-textPainter.size.height/2;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WaterController {
  BezierCurveState bezierCurveState;

  void  changeWaterHeight(double h){
    if(bezierCurveState!=null) {
      bezierCurveState.changeWaterHeight(h);
    }
  }
}
