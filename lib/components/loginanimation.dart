import 'package:flutter/material.dart';
import 'dart:math';

typedef Future OnTap();

class LoginAnimation extends StatefulWidget{

  final String loginTip;
  final double width,height;
  ///假如想改变弧线的长度，只要改起始弧度indicatorStarRadian即可
  final double indicatorStarRadian;
  final double indicatorWidth;
  final Color buttonColor;
  final Color indicatorColor;
  final TextStyle textStyle;
  final OnTap onTap;

  LoginAnimation({
    this.height:40.0,
    this.width:200.0,
    this.loginTip:"登陆",
    this.indicatorStarRadian:0.0,
    this.indicatorWidth:2.0,
    this.buttonColor:Colors.blue,
    this.indicatorColor:Colors.white,
    this.textStyle:const TextStyle(fontSize: 16.0, color: Colors.white),
    @required this.onTap,
  });

  @override
  State<StatefulWidget> createState() {
    return new LoginAnimationState();
  }

}

class LoginAnimationState extends State<LoginAnimation> with TickerProviderStateMixin<LoginAnimation>{

  Animation<double> animationStart;
  AnimationController controllerStart;

  Animation<double> animationEnd;
  AnimationController controllerEnd;

  AnimationController animationControllerWait;
  double widgetWidth,widgetHeight;
  bool isReset=false;



  @override
  void initState() {
    super.initState();
    widgetWidth=widget.width;
    widgetHeight=widget.height;

    //这个是刷新时控件旋转的动画，用来使刷新的Icon动起来
    animationControllerWait=new AnimationController(duration: const Duration(milliseconds: 1000*100), vsync: this);

    controllerStart = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    controllerEnd = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    initAnimationStart();
    initAnimationEnd();
  }


  void initAnimationStart(){
    animationStart = new Tween(begin: widgetWidth, end: widgetHeight).animate(controllerStart)
      ..addListener(() {
        if(isReset){
          return;
        }
        setState(() {
          widgetWidth=animationStart.value;
          print("widgetWidth is $widgetWidth");
        });
      });

    animationStart.addStatusListener((animationStatus){
      if(animationStatus==AnimationStatus.completed){
        //动画结束时首先将animationController重置
        isReset=true;
        controllerStart.reset();
        isReset=false;
        animationControllerWait.forward();
        handleAnimationEnd();
      }else if(animationStatus==AnimationStatus.forward){

      }
    });
  }



  void initAnimationEnd(){
    animationEnd = new Tween(begin: widgetHeight, end: widget.width).animate(controllerEnd)
      ..addListener(() {
        if(isReset){
          return;
        }
        setState(() {
          widgetWidth=animationEnd.value;
          print("widgetWidth is $widgetWidth");
        });
      });


    animationEnd.addStatusListener((animationStatus){
      if(animationStatus==AnimationStatus.completed){
        //动画结束时首先将animationController重置
        isReset=true;
        controllerEnd.reset();
        isReset=false;
      }else if(animationStatus==AnimationStatus.forward){

      }
    });
  }



  void handleAnimationEnd() async{
    await widget.onTap();
    //结束加载等待的动画
    animationControllerWait.stop();
    animationControllerWait.reset();
    controllerEnd.forward();
  }


  @override
  void dispose() {
    controllerStart.dispose();
    animationControllerWait.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new RotationTransition( //布局中加载时动画的weight
        child: new CustomPaint(
          size: new Size(widgetWidth, widgetHeight),
          painter: new LoginPainter(
            width:widgetWidth,
            height:widgetHeight,
            loginTip:widget.loginTip,
            indicatorStarRadian: widget.indicatorStarRadian,
            indicatorWidth:widget.indicatorWidth,
            buttonColor:widget.buttonColor,
            indicatorColor:widget.indicatorColor,
            textStyle: widget.textStyle,
          ),
        ),
        turns: new Tween(begin: 0.0, end: 150.0).animate(
            animationControllerWait)
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              animationControllerWait.repeat();
            }
          }),
      ),

      onTap: (){
        if(!controllerStart.isAnimating) {
          controllerStart.forward();
        }
      },
    );
  }
}

class LoginPainter extends CustomPainter{

  final double width,height;
  final String loginTip;
  final double indicatorRadian=4.71238898038469;
  ///假如想改变弧线的长度，只要改起始弧度indicatorStarRadian即可
  final double indicatorStarRadian;

  final double indicatorWidth;
  double isoscelesTriangle;
  final Color buttonColor;
  final Color indicatorColor;
  final TextStyle textStyle;

  LoginPainter({this.width,this.height,this.loginTip,this.indicatorStarRadian,this.indicatorWidth,this.buttonColor,this.indicatorColor,this.textStyle}){
    isoscelesTriangle=indicatorWidth*1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint=new Paint();
    paint.color=buttonColor;
    double halfHeight = height / 2;
    if(height<width) {

      canvas.drawCircle(new Offset(halfHeight, halfHeight), halfHeight, paint);

      double rectRight = width - halfHeight;
      canvas.drawRect(new Rect.fromLTRB(halfHeight, 0.0, rectRight, height), paint);

      canvas.drawCircle(new Offset(rectRight, halfHeight), halfHeight, paint);

      TextPainter textPainter = new TextPainter();
      textPainter.textDirection = TextDirection.ltr;
      textPainter.text = new TextSpan(text: loginTip, style: textStyle);
      textPainter.layout();
      double textStarPositionX = (width - textPainter.size.width) / 2;
      double textStarPositionY = (height - textPainter.size.height) / 2;
      textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
    }else{
      canvas.drawCircle(new Offset(halfHeight, halfHeight), halfHeight, paint);
      paint.color=indicatorColor;
      paint.style=PaintingStyle.stroke;
      paint.strokeWidth=indicatorWidth;
      double smallCircleRadius=halfHeight/2;
      canvas.drawArc(new Rect.fromLTRB(smallCircleRadius, smallCircleRadius, height-smallCircleRadius, height-smallCircleRadius), indicatorStarRadian, indicatorRadian, false, paint);

      double radian=indicatorStarRadian+indicatorRadian;

      Path path=getPath(smallCircleRadius,radian);

      canvas.save();
      canvas.translate(halfHeight, halfHeight);
      canvas.drawPath(path, paint);

      canvas.restore();
    }
  }




  Path getPath(double radius,double radian){
    Path path=new Path();

    double yPoint=sin(radian)*radius;
    double xPoint=cos(radian)*radius;

    double halfSide=isoscelesTriangle/2;
    path.moveTo(xPoint, yPoint+halfSide);

    path.lineTo(xPoint, yPoint-halfSide);

    double xVertex=xPoint+sqrt(pow(isoscelesTriangle, 2)-pow(halfSide,2));
    path.lineTo(xVertex, yPoint);

    path.close();
    return path;
  }




  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}