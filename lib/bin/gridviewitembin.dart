import 'package:flutterapp/bin/dragablegridviewbin.dart';
//import 'package:dragablegridview_flutter/dragablegridviewbin.dart';

class ItemBin extends DragAbleGridViewBin{

  ItemBin( this.data);

  String data;

  @override
  String toString() {
    return 'ItemBin{data: $data, dragPointX: $dragPointX, dragPointY: $dragPointY, lastTimePositionX: $lastTimePositionX, lastTimePositionY: $lastTimePositionY, containerKey: $containerKey, containerKeyChild: $containerKeyChild, isLongPress: $isLongPress, dragAble: $dragAble}';
  }

}