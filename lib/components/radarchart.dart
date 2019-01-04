import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget{

  final double radarChartRadius=200.0;
  final Map<String , int> maps={"Java":20,"Flutter":20,"Object-C":20,"C#":20,"Kotlin":20};

  @override
  State<StatefulWidget> createState() {
    return RadarChartState() ;
  }

}

class RadarChartState extends State<RadarChart>{

  PictureRecorder _recorder;
  Picture picture;
  double maxWidth=0.0;
  double maxHeight=0.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CustomPaint(
        size: new Size(maxWidth,maxHeight),
        painter: new RadarChartPainter(
          radarChartRadius:widget.radarChartRadius,
          picture: picture,
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _recorder=new PictureRecorder();
    drawRadarChartBackground();
  }


  ///画雷达图的底图
  void drawRadarChartBackground(){
    Canvas canvas=Canvas(_recorder);
    //计算每边占多少角度
    double angle=pi*2/widget.maps.length;
    Paint linePaint=Paint();
    //文字和雷达图的间距
    double spaceBetweenChartAndText=5.0;

    //计算雷达图中最长的文字占用的宽度，在切大小的时候必须考虑到文字占用的大小
    TextPainter painterSmall=new TextPainter();
    painterSmall.textDirection=TextDirection.ltr;
    double maxTextWidth=0.0;
    widget.maps.keys.forEach((key){
      painterSmall.text=new TextSpan(text: key,style: new TextStyle(fontSize: 15.0,color: Colors.black));
      painterSmall.layout();
      if(painterSmall.size.width>maxTextWidth){
        maxTextWidth=painterSmall.size.width;
      }
    });
    //在半径的基础上加上最大文字宽度，由于是两边有文字，所以*2 ，加10是因为文字和图之间有空隙
    maxWidth=widget.radarChartRadius+maxTextWidth*2+spaceBetweenChartAndText*2;
    maxHeight=widget.radarChartRadius+painterSmall.size.height*2+spaceBetweenChartAndText*2;
    canvas.clipRect(new Rect.fromLTRB(0.0, 0.0, maxWidth, maxHeight));


    canvas.translate(maxWidth/2, maxHeight/2);
    //旋转单边一半所需要的角度
    double halfAngle=angle/2;
    //绘制横线的半径
    double linesRadius;
    //横线与横线之间的间隙
    double linesSpace=cos(halfAngle)*widget.radarChartRadius/10;

    //绘制网格图
    canvas.save();
    //canvas.rotate(-pi/2-halfAngle);
    //为什么角度是反的？ Why is the angle reversed？
    canvas.rotate(pi/2+halfAngle);
    for(int i=0;i<widget.maps.length;i++){
      linesRadius=0.0;
      for(int m=0;m<5;m++){
        linesRadius=linesRadius+linesSpace;
        canvas.save();
        canvas.translate(0.0, -linesRadius);
        double w=tan(halfAngle)*linesRadius;
        //绘制横线
        linePaint.color = Colors.blue;
        canvas.drawLine(new Offset(-w, 0), new Offset(w, 0), linePaint);
        if(4==m){
          //绘制竖线
          if(i==0) {
            linePaint.color = Colors.red;
          }else{
            linePaint.color=Colors.green;
          }
          canvas.drawLine(new Offset(-w, 0), new Offset(0, linesRadius), linePaint);
        }
        canvas.restore();
      }
      canvas.rotate(angle);
    }
    canvas.restore();

    //绘制文字
    double accumulateAngle=0.0;
    double xPoint,yPoint;
    double maxRadius=widget.radarChartRadius/2;

    for(int i=0;i<widget.maps.length;i++){
      xPoint=cos(accumulateAngle)*maxRadius;
      yPoint=sin(accumulateAngle)*maxRadius;
      painterSmall.text=new TextSpan(text: widget.maps.keys.elementAt(i),style: new TextStyle(fontSize: 15.0,color: Colors.black));
      painterSmall.layout();

      if(accumulateAngle>=(1.875*pi) || accumulateAngle<pi/8){//0
        painterSmall.paint(canvas, new Offset(xPoint+spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));

      }else if(accumulateAngle>=pi/8 && accumulateAngle<pi*0.375){
        painterSmall.paint(canvas, new Offset(xPoint+spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));

      }else if(accumulateAngle>=pi*0.375 && accumulateAngle<pi*0.625){//90
        painterSmall.paint(canvas, new Offset(xPoint-painterSmall.size.width/2, yPoint+spaceBetweenChartAndText));

      }else if(accumulateAngle>=pi*0.625 && accumulateAngle<pi*0.875){
        painterSmall.paint(canvas, new Offset(xPoint-painterSmall.size.width-spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));

      }else if(accumulateAngle>=pi*0.875 && accumulateAngle<pi*1.125){//180
        painterSmall.paint(canvas, new Offset(xPoint-painterSmall.size.width-spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));

      }else if(accumulateAngle>=pi*1.125 && accumulateAngle<pi*1.375){
        painterSmall.paint(canvas, new Offset(xPoint-painterSmall.size.width-spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));

      }else if(accumulateAngle>=pi*1.375 && accumulateAngle<pi*1.625){//270
        painterSmall.paint(canvas, new Offset(xPoint-painterSmall.size.width/2, yPoint-spaceBetweenChartAndText-painterSmall.size.height));

      }else{
        painterSmall.paint(canvas, new Offset(xPoint+spaceBetweenChartAndText, yPoint-painterSmall.size.height/2));
      }
      accumulateAngle=accumulateAngle+angle;
    }

    picture=_recorder.endRecording();
  }
}


class RadarChartPainter extends CustomPainter{

  final double radarChartRadius;
  final Picture picture;

  RadarChartPainter({
    @required this.radarChartRadius,
    @required this.picture,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if(picture!=null) {
      canvas.drawPicture(picture);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}