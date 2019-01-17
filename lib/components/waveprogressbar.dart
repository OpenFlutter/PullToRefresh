import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class WaveProgressBar extends StatefulWidget{

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
  final WaterController progressController;


  WaveProgressBar({
    @required this.size,
    this.waveHeight : 25.0,
    @required this.percentage,
    @required this.textStyle,
    this.waveDistance : 30.0,
    this.flowSpeed : 1.5,
    this.waterColor : const Color(0xffe16009),
    this.strokeCircleColor : const Color(0xFFE0E0E0),
    this.circleStrokeWidth : 4.0,
    @required this.progressController,
  });

  @override
  State<StatefulWidget> createState() {
    return new WaveProgressBarState();
  }
}


class WaveProgressBarState extends State<WaveProgressBar> with SingleTickerProviderStateMixin{
  double _moveForwardDark=0.0;
  double _moveForwardLight=0.0;
  double _waterHeight;
  double _percentage;
  Animation<double> animation;
  AnimationController animationController;
  VoidCallback _voidCallback;
  Random _random=new Random();
  Picture _lightWavePic;
  Picture _darkWavePic;

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
    widget.progressController.bezierCurveState=this;
    WavePictureGenerator generator=WavePictureGenerator(widget.size,widget.waveDistance,widget.waveHeight,widget.waterColor);
    _lightWavePic=generator.drawLightWave();
    _darkWavePic=generator.drawDarkWave();
    animationController = new AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    WidgetsBinding widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      widgetsBinding.addPersistentFrameCallback((callback) {
        if(mounted){
          setState(() {
            _moveForwardDark= _moveForwardDark - widget.flowSpeed- _random.nextDouble()-1;
            if(_moveForwardDark<= - widget.waveDistance*4){
              _moveForwardDark=_moveForwardDark+widget.waveDistance*4;
            }

            _moveForwardLight = _moveForwardLight- widget.flowSpeed- _random.nextDouble();
            if(_moveForwardLight <= - widget.waveDistance*4){
              _moveForwardLight = _moveForwardLight+widget.waveDistance*4;
            }
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: widget.size,
      painter: new BezierCurvePainter(
        moveForward:_moveForwardDark,
        textStyle:widget.textStyle ,
        circleStrokeWidth: widget.circleStrokeWidth,
        strokeCircleColor: widget.strokeCircleColor,
        percentage: _percentage ,
        moveForwardLight: _moveForwardLight,
        lightWavePic: _lightWavePic,
        darkWavePic: _darkWavePic,
        waterHeight: _waterHeight,
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


class WavePictureGenerator{
  PictureRecorder _recorder;
  final Size size;
  final double _waveDistance;
  final double _waveHeight;
  final Color _waterColor;
  int _maxCount;
  double waterHeight;
  double _targetWidth;
  double _targetHeight;

  WavePictureGenerator(this.size,this._waveDistance,this._waveHeight,this._waterColor){
    double oneDistance=_waveDistance*4;
    int count=(size.width/oneDistance).ceil()+1;
    _targetWidth=count*oneDistance;
    _maxCount=count*4+1;
    waterHeight=size.height/2;
    _targetHeight=size.height+waterHeight;
  }

  Picture drawDarkWave(){
    return drawWaves(true);
  }

  Picture drawLightWave(){
    return drawWaves(false);
  }

  Picture drawWaves(bool isDarkWave){
    _recorder=PictureRecorder();
    Canvas canvas=Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, _targetWidth, _targetHeight));
    Paint paint =Paint();
    if(isDarkWave){
      paint.color = _waterColor;
    }else{
      paint.color = _waterColor.withAlpha(0x88);
    }
    paint.style=PaintingStyle.fill;
    canvas.drawPath(createBezierPath(isDarkWave), paint);
    return _recorder.endRecording();
  }


  Path createBezierPath(bool isDarkWave){

    Path path=Path();
    path.moveTo(0, waterHeight);

    double lastPoint=0.0;
    int m=0;
    double waves;
    for(int i=0;i<_maxCount-2;i=i+2){
      if(m%2==0){
        waves=waterHeight+_waveHeight;
      }else{
        waves=waterHeight-_waveHeight;
      }
      path.cubicTo(lastPoint, waterHeight,   lastPoint+_waveDistance, waves,   lastPoint+_waveDistance*2, waterHeight);
      lastPoint=lastPoint+_waveDistance*2;
      m++;
    }
    if(isDarkWave){
      path.lineTo(lastPoint,_targetHeight);
      path.lineTo(0,_targetHeight);
    }else{
      double waveHeightMax=waterHeight+_waveHeight+10.0;
      path.lineTo(lastPoint, waveHeightMax);
      path.lineTo(0,waveHeightMax);
    }
    path.close();
    return path;
  }
}


class BezierCurvePainter extends CustomPainter{

  final double moveForward;
  final Color strokeCircleColor;
  final TextStyle textStyle;
  final double circleStrokeWidth;
  final double percentage;
  final double moveForwardLight;
  final Picture darkWavePic;
  final Picture lightWavePic;
  final double waterHeight;
  final Paint _paints =Paint();

  BezierCurvePainter({
    @required this.moveForward,
    @required this.strokeCircleColor,
    @required this.textStyle,
    @required this.circleStrokeWidth,
    @required this.percentage,
    @required this.moveForwardLight,
    @required this.darkWavePic,
    @required this.lightWavePic,
    @required this.waterHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint layerPaint=new Paint();

    double halfSizeHeight = size.height/2;
    double halfSizeWidth = size.width/2;
    double radius=min(size.width, size.height)/2-circleStrokeWidth/2;

    //由于在绘制图片的时候在波浪上面有50%高度的空白部分，所以在这里必须减掉
    double targetHeight=waterHeight-halfSizeHeight;

    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);
    //绘制淡颜色的海浪
    canvas.save();
    canvas.translate(moveForwardLight, targetHeight);
    canvas.drawPicture(lightWavePic);

    //绘制深颜色的海浪
    double moveDistance=moveForward-moveForwardLight;
    canvas.translate(moveDistance, 0.0);
    canvas.drawPicture(darkWavePic);
    canvas.restore();

    layerPaint.blendMode=BlendMode.dstIn ;
    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0,  size.width, size.height), layerPaint);

    canvas.drawCircle(new Offset(halfSizeWidth, halfSizeHeight), radius-circleStrokeWidth, _paints);
    canvas.restore();
    canvas.restore();


    _paints.style=PaintingStyle.stroke;
    _paints.color=strokeCircleColor;
    _paints.strokeWidth=circleStrokeWidth;
    canvas.drawCircle(new Offset(halfSizeWidth, halfSizeHeight), radius, _paints);

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
  WaveProgressBarState bezierCurveState;

  void  changeProgressRate(double h){
    if(bezierCurveState!=null) {
      bezierCurveState.changeWaterHeight(h);
    }
  }
}
