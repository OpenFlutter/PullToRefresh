import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterapp/bin/bubblebin.dart';

class Bubbles extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new BubblesState();
  }

}

class BubblesState extends State<Bubbles>{

  List<BubbleBin> _bubbles=new List();
  Random _random=new Random();
  double xBlankSpace=0.2;
  double _maxSpeed=6.0;
  double _fixedHeight;
  double _disappearHeight;
  double maxRadius=25.0;
  double screenWidth;
  double screenHeight;
  WidgetsBinding widgetsBinding;
  final List<Color> _colors=[Colors.green,Color(0XFF66BB6A),Color(0XFF4CAF50),Color(0XFF43A047),Color(0XFF388E3C),Color(0XFF2E7D32),
    Color(0XFF1B5E20),Color(0XFF00C853),Color(0XFF00E676),Color(0XFF64DD17),Color(0XFF76FF03)];

  @override
  void initState() {
    super.initState();
    //print("initState be invoke");
    widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      widgetsBinding.addPersistentFrameCallback((callback){
        print("addPersistentFrameCallback be invoke");
        if(mounted){
          setState(() {
            //TODO 先将数据改变,再添加新数据
            BubbleBin bubbleBin;
            for (int i=0;i<_bubbles.length;i++){
              bubbleBin=_bubbles[i];
              if(bubbleBin.yPosition<bubbleBin.disappearHeight){
                _bubbles.removeAt(i);
                print("remove bin");
                continue;
              }
              bubbleBin.yPosition=bubbleBin.yPosition-bubbleBin.speed;
              if(bubbleBin.yPosition<=_disappearHeight+_fixedHeight){
                int alpha=(bubbleBin.yPosition/(_disappearHeight+_fixedHeight)*0xFF).ceil();
                bubbleBin.transparency=alpha;
              }
              print("screenHeight is $screenHeight****bubbleBin : ${bubbleBin.toString()}");
            }


            int intRandom=_random.nextInt(9)+1;

            double xPositionRandom=_random.nextDouble();
            double yPositionRandom=_random.nextDouble();
            double radiusRandom=_random.nextDouble();
            double speedRandom=_random.nextDouble();

            if(xPositionRandom>xBlankSpace&&xPositionRandom<1.0-xBlankSpace
                && yPositionRandom>0.2
                && radiusRandom>0.2
                && speedRandom>0.2
                && _bubbles.length<10){
              _disappearHeight=screenHeight-(_fixedHeight+_fixedHeight*_getPercentageOfDisappearHeight(yPositionRandom));
              BubbleBin bin=new BubbleBin(
                  radius:maxRadius*radiusRandom,
                  color: _colors[intRandom],
                  yPosition: screenHeight,
                  disappearHeight: _disappearHeight,
                  transparency: 0XFF,
                  xPosition: screenWidth*xPositionRandom,
                  speed: _maxSpeed*speedRandom);
              _bubbles.add(bin);
            }
          });
          widgetsBinding.scheduleFrame();
        }

      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size size=MediaQuery.of(context).size;
    screenWidth=size.width;
    screenHeight=size.height;
    _fixedHeight=screenHeight/2.0;
  }

  double _getPercentageOfDisappearHeight(double doubleRandom){
    double percentageOfDisappearHeight;
    if(doubleRandom>0.3){
      percentageOfDisappearHeight=_getPercentageOfDisappearHeight(doubleRandom/2);
    }else{
      percentageOfDisappearHeight=doubleRandom;
    }
    return percentageOfDisappearHeight;
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("泡泡"),
      ),
      body: new Container(
        child: new CustomPaint(
          size: new Size(screenWidth,screenHeight),
          painter: new BubblesPainter(_bubbles),
        ),
      ),
    );
  }
}

class BubblesPainter extends CustomPainter{

  final List<BubbleBin> _bubbles;

  BubblesPainter(this._bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint=new Paint();
    paint.style=PaintingStyle.fill;
    BubbleBin bin;
    Offset offset;
    Color color;
    for (int i=0;i<_bubbles.length;i++){
      bin=_bubbles[i];
      color=bin.color;
      paint.color=color.withAlpha(bin.transparency);
      offset=new Offset(bin.xPosition, bin.yPosition);
      canvas.drawCircle(offset , bin.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}