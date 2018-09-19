import 'package:flutter/material.dart';
import 'package:flutterapp/list.dart';

class FirstPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new FirdtPageState();
  }

}

class FirdtPageState extends State<FirstPage>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("界面1",style: new TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: null,
            iconSize: 29.0,
            disabledColor: Colors.white,)
          ]
        ,),
      body: new Container(
        // ignore: conflicting_dart_import
        child: new ListViewWidgets(),
      )
    );
  }
}