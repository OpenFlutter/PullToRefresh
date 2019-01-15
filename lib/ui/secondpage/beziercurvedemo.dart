import 'package:flutter/material.dart';
import 'package:flutterapp/components/beziercurve.dart';

class BezierCurveDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return BezierCurveDemoState();
  }

}

class BezierCurveDemoState extends State<BezierCurveDemo>{

  final TextEditingController _controller = new TextEditingController();
  //默认初始值为0.0
  double waterHeight=0.0;
  WaterController waterController=WaterController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      //这里写你想要显示的百分比
      waterController.changeWaterHeight(0.82);
    });
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("贝塞尔曲线测试"),
      ),
      body: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text("高度调整:    ",
                style: new TextStyle(fontSize: 20.0),
              ),
              new Container(
                width: 150.0,
                child: new TextField(
                    controller: _controller,
                    decoration: new InputDecoration(
                      hintText: "请输入高度",
                    )
                ),
              ),
              new RaisedButton(onPressed: (){
                  print("waterHeight is ${_controller.toString()}");
                  FocusScope.of(context).requestFocus(FocusNode());
                  waterController.changeWaterHeight(double.parse(_controller.text));
                },
                child: new Text("确定"),
              ),
            ],
          ),
          new Container(
            margin: EdgeInsets.only(top: 80.0),
            child: new Center(
              child: new BezierCurve(
                flowSpeed: 2.0,
                waveDistance:45.0,
                waterColor: Color(0xFF68BEFC),
                //strokeCircleColor: Color(0x50e16009),
                heightController: waterController,
                percentage: waterHeight,
                size: new Size (300,300),
                textStyle: new TextStyle(
                color:Color(0x15000000),
                fontSize: 60.0,
                fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

}