import 'package:flutter/material.dart';

class InkWellC extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new InkWellCState();
  }

}

class InkWellCState extends State<InkWellC>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       appBar: new AppBar(
         title: new Text("水波纹效果"),
       ),
      body: new Column(
        children: <Widget>[
          new InkWell(
            onTap: (){
              Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("onTap"))
              );
            },
            child: new Container(
              width: double.infinity,
              padding: new EdgeInsets.all(10.0),
              child: new Text('Flat Button'),
            ),
          ),
          new RaisedButton(
            child: new Text("RaisedButton"),
            onPressed: (){
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("onPressed"))
              );
            },
          )
        ],
      ),
    );
  }

}