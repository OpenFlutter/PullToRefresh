import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/components/pulltorefresh.dart';

class PullAndPushTest extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new PullAndPushTestState();
  }
}


class PullAndPushTestState extends State<PullAndPushTest>{
  List<String> addStrs=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  List<String> strs=["1","2","3","4","5","6","7","8","9","0"];
  ScrollController controller=new ScrollController();
  ScrollPhysics scrollPhysics=new AlwaysScrollableScrollPhysics();
  //使用系统的请求
  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result="";


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("上下拉刷新"),
      ),
      body: new PullAndPush(
        listView: new ListView.builder(
        //ListView的Item
          itemCount: strs.length+2,
          controller: controller,
          physics: scrollPhysics,
          itemBuilder: (BuildContext context,int index){
            if(index==0){
              return new Container(
                alignment: Alignment.bottomCenter,
              );
            }else if(index==strs.length+1){
              return new Container(
                alignment: Alignment.topCenter,
              );
            }
            return new Container(
              height: 35.0,
              child: new Center(
                child: new Text(strs[index-1],style: new TextStyle(fontSize: 18.0),),
              ),
            );
          }
        ),
        loadData: (topItemHeight,bottomItemHeight) async{
          try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();
            if (response.statusCode == HttpStatus.OK) {
              _result = await response.transform(utf8.decoder).join();
              setState(() {
                //拿到数据后，对数据进行梳理
                if(topItemHeight>0.0){
                  strs.clear();
                  strs.addAll(addStrs);
                }else if(bottomItemHeight>0.0){
                  strs.addAll(addStrs);
                }
              });
            } else {
              _result = 'error code : ${response.statusCode}';
            }
          } catch (exception) {
            _result = '网络异常';
          }
          print(_result);
        },
        scrollPhysicsChanged: (ScrollPhysics physics) {
          setState(() {
            scrollPhysics=physics;
          });
        },)
    );
  }
}






