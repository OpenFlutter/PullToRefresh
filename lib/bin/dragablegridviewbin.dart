import 'package:flutter/material.dart';

class DragAbleGridViewBin{
  double dragPointX=0.0;
  double dragPointY=0.0;
  double lastTimePositionX=0.0;
  double lastTimePositionY=0.0;
  GlobalKey containerKey=new GlobalKey();
  GlobalKey containerKeyChild=new GlobalKey();
  bool isLongPress=false;
  bool dragAble=false;
  ///是否隐藏，默认不隐藏
  bool offstage=false;
}