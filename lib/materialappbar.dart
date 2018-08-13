import 'package:flutter/material.dart';



class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(icon:new Icon(Icons.menu) , onPressed: null,tooltip: "导航菜单",),
        title: new Text("实例标题"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: null,tooltip: "搜索",),
          new IconButton(icon: new Icon(Icons.cloud), onPressed: null,tooltip: "云",)
        ],
      ),
      body: new Center(
        child: new Text("你好世界"),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: null,tooltip: "增加",child: new Icon(Icons.add),),
    );
  }

}