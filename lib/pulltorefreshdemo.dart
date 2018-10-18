import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/components/pulltorefresh.dart';
//import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';


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
  //For compatibility with ios ,must use RefreshAlwaysScrollPhysics ;为了兼容ios 必须使用RefreshAlwaysScrollPhysics
  ScrollPhysics scrollPhysics=new RefreshAlwaysScrollPhysics();
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
//        backgroundColor: Colors.lightGreen,
//        tipText: "快给我松手！",
//        textColor: Colors.grey,
        listView: new ListView.builder(
          //ListView的Item
          itemCount: strs.length,//+2,
          controller: controller,
          physics: scrollPhysics,
          itemBuilder: (BuildContext context,int index){
            return new Container(
              height: 35.0,
              child: new Center(
                child: new Text(strs[index],style: new TextStyle(fontSize: 18.0),),
              ),
            );
          }
        ),
        loadData: (isPullDown) async{
          try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();
            if (response.statusCode == HttpStatus.ok) {
              _result = await response.transform(utf8.decoder).join();
              setState(() {
                //拿到数据后，对数据进行梳理
                if(isPullDown){
                  strs.clear();
                  strs.addAll(addStrs);
                }else{
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



/// 切记 继承ScrollPhysics  必须重写applyTo，，在AlwaysScrollableScrollPhysics类里面复制就可以
/// 此类是为了防止IOS使用AlwaysScrollableScrollPhysics出现弹簧效果设计
class RefreshAlwaysScrollPhysics extends AlwaysScrollableScrollPhysics {
  const RefreshAlwaysScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  RefreshAlwaysScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new RefreshAlwaysScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (position.outOfRange) {
      double end;
      if (position.pixels > position.maxScrollExtent)
        end = position.maxScrollExtent;
      if (position.pixels < position.minScrollExtent)
        end = position.minScrollExtent;
      assert(end != null);
      return ScrollSpringSimulation(
          spring,
          position.pixels,
          position.maxScrollExtent,
          math.min(0.0, velocity),
          tolerance: tolerance
      );
    }
    if (velocity.abs() < tolerance.velocity)
      return null;
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent)
      return null;
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent)
      return null;
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      tolerance: tolerance,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n'
        );
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent) // underscroll
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) // overscroll
      return value - position.pixels;
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) // hit top edge
      return value - position.minScrollExtent;
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;
    return 0.0;
  }


  //重写这个方法为了减缓ListView滑动速度
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    final double overscrollPastStart = math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd = math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast = math.max(overscrollPastStart, overscrollPastEnd);
    if(overscrollPast>0.0){
      return 0.0;
    }else{
      return super.applyPhysicsToUserOffset(position, offset);
    }
  }

}






