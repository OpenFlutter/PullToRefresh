import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BlendModes extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new BlendModeState();
  }

}

class BlendModeState extends State<BlendModes>{

  final double sizes=200.0;
  BlendMode blendMode=BlendMode.dstOver;
  String title="BlendMode.dstOver";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new PopupMenuButton<BlendMode>(
            onSelected: (value){
              setState(() {
                blendMode=value;
                title=value.toString();
              });
            },
            itemBuilder: (BuildContext context) => getItems(),
          ),
        ],
      ),
      body: new Center(
        child: new CustomPaint(
            size: new Size(sizes, sizes),
            painter: new BlendModePainter(blendMode),
        ),
      ),
    );
  }


  List<PopupMenuItem<BlendMode>> getItems(){
    return <PopupMenuItem<BlendMode>>[
      const PopupMenuItem<BlendMode>(
        value: BlendMode.difference,
        child: Text('BlendMode.difference'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.dst,
        child: Text('BlendMode.dst'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.dstATop,
        child: Text('BlendMode.dstATop'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.dstIn,
        child: Text('BlendMode.dstIn'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.dstOut,
        child: Text('BlendMode.dstOut'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.dstOver,
        child: Text('BlendMode.dstOver'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.src,
        child: Text('BlendMode.src'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.srcATop,
        child: Text('BlendMode.srcATop'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.srcIn,
        child: Text('BlendMode.srcIn'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.srcOut,
        child: Text('BlendMode.srcOut'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.srcOver,
        child: Text('BlendMode.srcOver'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.exclusion,
        child: Text('BlendMode.exclusion'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.hardLight,
        child: Text('BlendMode.hardLight'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.hue,
        child: Text('BlendMode.hue'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.lighten,
        child: Text('BlendMode.lighten'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.luminosity,
        child: Text('BlendMode.luminosity'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.modulate,
        child: Text('BlendMode.modulate'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.multiply,
        child: Text('BlendMode.multiply'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.overlay,
        child: Text('BlendMode.overlay'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.plus,
        child: Text('BlendMode.plus'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.saturation,
        child: Text('BlendMode.saturation'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.screen,
        child: Text('BlendMode.screen'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.softLight,
        child: Text('BlendMode.softLight'),
      ),const PopupMenuItem<BlendMode>(
        value: BlendMode.clear,
        child: Text('BlendMode.clear'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.color,
        child: Text('BlendMode.color'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.colorBurn,
        child: Text('BlendMode.colorBurn'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.colorDodge,
        child: Text('BlendMode.colorDodge'),
      ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.darken,
        child: Text('BlendMode.darken'),
      ),

//              const PopupMenuItem<BlendMode>(
//                value: BlendMode.values,
//                child: Text('BlendMode.values'),
//              ),
      const PopupMenuItem<BlendMode>(
        value: BlendMode.xor,
        child: Text('BlendMode.xor'),
      ),
    ];
  }
}

class BlendModePainter extends CustomPainter{

  final BlendMode blendMode;

  BlendModePainter(this.blendMode);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint=new Paint();
    Paint layerPaint=new Paint();


    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0, 200.0, 200.0), layerPaint);
    //paint.color=Color(0xff2196f3);
    paint.shader= ui.Gradient.linear(new Offset(0.0, 0.0), new Offset(150.0, 150.0), [Colors.red,Colors.green,Colors.blue],[0.0,0.5,1.0]);
    canvas.drawRect(new Rect.fromLTRB(0.0, 0.0, 150.0, 150.0), paint);
    paint.shader=null;


    layerPaint.blendMode=blendMode ;

    canvas.saveLayer(new Rect.fromLTRB(0.0, 0.0, 200.0, 200.0), layerPaint);
    canvas.save();
    canvas.translate(125.0, 125.0);
    paint.color=Colors.yellow;
    canvas.drawCircle(new Offset(0.0, 0.0), 75.0, paint);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}