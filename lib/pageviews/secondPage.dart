import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new SecondPageState();
  }

}

class SecondPageState extends State<SecondPage>{

  static var currentPage=0;
  PageController scrollController=new PageController(initialPage: currentPage);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("界面2"),),
      body: new Container(
          height: 100.0,
          color: Colors.grey,
          child: new NotificationListener(
            onNotification: (n){
              return true;
            },
            child: new PageView(
              controller: scrollController,
              children: <Widget>[
                new Center(
                  child: new Text("FirstPage"),
                ),
                new Center(
                  child: new Text("SecondPage"),
                ),
                new Center(
                  child: new Text("ThirdPage"),
                ),
                new Center(
                  child: new Text("FourthPage"),
                ),
                new Center(
                  child: new Text("FifthPage"),
                ),
              ],
              onPageChanged: (index){
                currentPage=index;
              },
            ),
          ),

        )
    );
  }
}