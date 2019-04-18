import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutterapp/bin/appinfobin.dart';
import 'package:flutterapp/ui/thirdpage/examples/Examples.dart';
import 'package:flutterapp/ui/thirdpage/cutScreen.dart';

class ThirdPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new ThirdPageState();
  }

}

class ThirdPageState extends State<ThirdPage>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("CustomWidght",style: new TextStyle(fontSize: 18.0),),
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


class ListViewWidgets extends StatefulWidget{

  final  constantList =  [
    new AppInfoBin("CutScreen", "2019-01-11 10:25", "屏幕截图",false),
    new AppInfoBin("Examples", "2019-04-17 11:16", "各种示例",false),
  ];

  @override
  State<StatefulWidget> createState() {
    return new ListState();
  }

}

class ListState extends State<ListViewWidgets>{

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.constantList.length,
      itemBuilder: (BuildContext context,int index){
        return new GestureDetector(
            onTapDown: (TapDownDetails details){
              setState(() {
                widget.constantList[index].isTapDown=true;
              });
            },
            onTapCancel: (){
              setState(() {
                widget.constantList[index].isTapDown=false;
              });
            },
            onTapUp:(TapUpDetails details){
              setState(() {
                widget.constantList[index].isTapDown=false;
              });
              if(index==0){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new CutScreen();
                }));
              }else if(index==1){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new Examples();
                }));
              }
            },
            child:new Card(
              color: widget.constantList[index].isTapDown?Color(0xFFF4CB28):null,
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new ListTile(
                  subtitle: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(widget.constantList[index].title,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.black),)
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text("时间",style: new TextStyle(fontSize: 13.0)),
                                new Text(widget.constantList[index].times,style: new TextStyle(fontSize: 13.0)),
                              ],
                            )
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child:new Container(
                                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 2.0),
                                child: new Text(widget.constantList[index].content,maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  trailing: new Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                ),
              ),
            )
        );
      },);
  }
}