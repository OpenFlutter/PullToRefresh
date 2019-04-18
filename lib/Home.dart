import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/ui/firstpage/firstPage.dart';
import 'package:flutterapp/ui/secondpage/secondPage.dart';
import 'package:flutterapp/ui/thirdpage/thirdPage.dart';
import 'dart:ui' as ui show Image;

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _MyHomePageState();
  }
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  PageController controller;
  var currentPage=0;
  GlobalKey _globalKey=new GlobalKey();

  @override
  void initState() {
    super.initState();
    controller=new PageController(initialPage: this.currentPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Future<Picture>  _widgetToImage(final GlobalKey _globalKey) async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          .findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      var recorder = new PictureRecorder();
      Canvas canvas = Canvas(recorder);
      canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
      Picture picture = recorder.endRecording();
      return picture;
    }catch(e){
      print(e);
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
          body: new PageView(
            children: <Widget>[
              new FirstPage(),
              new SecondPage(),
              new ThirdPage()
            ],
            controller: controller,
            onPageChanged: (int position){
              _widgetToImage(_globalKey);
              setState(() {
                this.currentPage = position;
              });
            },
          ),
          bottomNavigationBar:
          new BottomNavigationBar(items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Title(
                    title:"列表",
                    color: Colors.white,
                    child: new Text("列表",style: new TextStyle(fontSize: 13.0)))
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.message),
                title: new Title(
                    title:"通知",
                    color: Colors.white,
                    child: new Text("通知",style: new TextStyle(fontSize: 13.0)))
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.cloud),
                title: new Title(
                    title:"我的",
                    color: Colors.white,
                    child: new Text("我的",style: new TextStyle(fontSize: 13.0)))
            )
          ],
            iconSize: 28.0,
            onTap: (int position){
              setState(() {
                controller.animateToPage(
                    position, duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              });
            },
            currentIndex: currentPage,
            fixedColor: Colors.blue,
          )
      ),
    );
  }
}