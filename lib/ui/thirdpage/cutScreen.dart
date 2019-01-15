import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;

import 'package:flutter/rendering.dart';

class CutScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new CutScreenState();
  }

}

class CutScreenState extends State<CutScreen>{

  ui.Image image;
  ImagePaint paintCanvas;
  GlobalKey _globalKey=new GlobalKey();
  double screenWidth,screenHeight;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size size=MediaQuery.of(context).size;
    screenWidth=size.width;
    screenHeight=size.height;
  }

  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
        appBar: new AppBar(title: new Text("界面3"),),
        body:new Column(
          children: <Widget>[
            new RaisedButton(
                child:new Text("点击显示图片"),
                onPressed: () async {
                  RenderRepaintBoundary boundary = _globalKey.currentContext
                      .findRenderObject();
                  image = await boundary.toImage(pixelRatio: 1.0);
                  setState(() {

                  });
                }
            ),
            new CustomPaint(
              size: new Size(screenWidth, screenHeight),
              painter: paintCanvas=new ImagePaint(image,screenWidth,screenHeight),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePaint extends CustomPainter{

  ImagePaint(this.image,this.screenWidth,this.screenHeight);

  ui.Image image;
  final double screenWidth,screenHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if(image!=null){
      canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
    }else{
      Paint paint=new Paint();
      paint.color=Colors.amberAccent;
      canvas.drawRect(new Rect.fromLTRB(0.0, 0.0, screenWidth, screenHeight), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}