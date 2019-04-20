import 'package:flutter/material.dart';

class TestFile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new TestFileState();
  }
}

class TestFileState extends State<TestFile>{

  var texts = ["123","234","345","456","789","101","102","103","104","end"];
  String txt = "START";
  bool isStart = true;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("TestFile"),
      ),
      body: new Column(
        children: <Widget>[
          new GestureDetector(
            child: new Text(txt),
            onTap: () async {
              while(isStart){
                setState(() {
                  txt = texts[count];
                });
                count++;
                if(count>=texts.length){
                  count=0;
                }
                await Future.delayed(new Duration(milliseconds: 1000));
              }
            },
          ),
          new MyStateLessWidget(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    isStart=false;
    super.dispose();
  }
}


class MyStateLessWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyStateLessWidgetState();
  }

}


class MyStateLessWidgetState extends State<MyStateLessWidget>{
  @override
  Widget build(BuildContext context) {
    print("MyStateLessWidget is invokell");
    return new Text("I am a StatelessWidget",style: new TextStyle(fontSize: 18,color: Colors.red),);
  }
}