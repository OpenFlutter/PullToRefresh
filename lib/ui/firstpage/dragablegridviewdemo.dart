import 'package:flutter/material.dart';
import 'package:flutterapp/bin/gridviewitembin.dart';
import 'package:flutterapp/components/dragablegridview.dart';
//import 'package:dragablegridview_flutter/dragablegridview_flutter.dart';


class DragAbleGridViewDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new DragAbleGridViewDemoState();
  }

}

class DragAbleGridViewDemoState extends State<DragAbleGridViewDemo>{

  List<ItemBin> itemBins=new List();
  String actionTxtEdit="编辑";
  String actionTxtComplete="完成";
  String actionTxt;
  var editSwitchController=EditSwitchController();
  final List<String> heroes=["鲁班","虞姬","甄姬","黄盖","张飞","关羽","刘备","曹操","赵云","孙策","庄周","廉颇","后裔","妲己","荆轲",];

  @override
  void initState() {
    super.initState();
    actionTxt=actionTxtEdit;
    heroes.forEach((heroName) {
        itemBins.add(new ItemBin(heroName));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("可拖拽GridView"),
        actions: <Widget>[
          new Center(
            child: new GestureDetector(
              child: new Container(
                child: new Text(actionTxt,style: TextStyle(fontSize: 19.0),),
                margin: EdgeInsets.only(right: 12),
              ),
              onTap: (){
                changeActionState();
                editSwitchController.editStateChanged();
              },
            )
          )
        ],
      ),
      body: new DragAbleGridView(
        mainAxisSpacing:10.0,
        crossAxisSpacing:10.0,
        childAspectRatio:1.8,
        crossAxisCount: 4,
        itemBins:itemBins,
        editSwitchController:editSwitchController,
        /******************************new parameter*********************************/
        isOpenDragAble: true,
        animationDuration: 300, //milliseconds
        longPressDuration: 800, //milliseconds
        /******************************new parameter*********************************/
        deleteIcon: new Image.asset("images/close.png",width: 15.0 ,height: 15.0 ),
        child: (int position){
          return new Container(
            padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(new Radius.circular(3.0)),
              border: new Border.all(color: Colors.blue),
            ),
            //因为本布局和删除图标同处于一个Stack内，设置marginTop和marginRight能让图标处于合适的位置
            //Because this layout and the delete_Icon are in the same Stack, setting marginTop and marginRight will make the icon in the proper position.
            margin: EdgeInsets.only(top: 6.0,right: 6.0),
            child: new Text(
              itemBins[position].data,
              style: new TextStyle(fontSize: 16.0,color: Colors.blue),),
          );
        },
        editChangeListener: (){
          changeActionState();
        },
      ),
    );
  }

  void changeActionState(){
    if(actionTxt==actionTxtEdit){
      setState(() {
        actionTxt=actionTxtComplete;
      });
    }else{
      setState(() {
        actionTxt=actionTxtEdit;
      });
    }
  }
}





