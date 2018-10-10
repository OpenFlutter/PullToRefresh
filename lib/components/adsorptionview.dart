import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/bin/adsorptionlistbin.dart';

typedef Widget GetHearWidget(AdsorptionListBin bin);
typedef Widget GetGeneralItem(AdsorptionListBin bin);

class AdsorptionView<T extends AdsorptionListBin> extends StatefulWidget{

  final List<T> adsorptionDatas;
  final GetHearWidget headChild;
  final GetGeneralItem generalItemChild;
  final double itemHeight;
  final double itemWidth;
  final double cacheExtent;
  final bool isEqualHeightItem;

  AdsorptionView({
    @required this.adsorptionDatas,
    @required this.headChild,
    @required this.generalItemChild,
    this.itemHeight:50.0,
    this.itemWidth:double.infinity,
    this.cacheExtent:30.0,
    @required this.isEqualHeightItem,
  }): assert(
    adsorptionDatas!=null,
    generalItemChild!=null&&
    headChild!=null,
  );

  @override
  State<StatefulWidget> createState() {
    if(isEqualHeightItem) {
      return new AdsorptionViewState();
    }else{
      return new AdsorptionViewNotEqualHeightState();
    }
  }
}

///此控件适用于固定高度的ListView
class AdsorptionViewState<T extends AdsorptionListBin> extends State<AdsorptionView>{

  ScrollController scrollController=new ScrollController();
  double headerOffset=0.0;
  T headerStr;
  GlobalKey key=new GlobalKey();
  double beforeScroll=0.0;

  @override
  void initState() {
    super.initState();
    headerStr=widget.adsorptionDatas.first;

    scrollController.addListener((){
      //计算滑动了多少距离了
      double pixels=scrollController.position.pixels;

      //根据滑动的距离 计算当前可见的第一个Item的Position
      int a=pixels~/widget.itemHeight;
      //计算滑动出屏幕多少距离
      double b=pixels%widget.itemHeight;
      double currentScrollPosition=scrollController.position.extentBefore;
      setState(() {
        //如果下一个item是Header 则偏移 如果不是 则偏移量=0
        if(widget.adsorptionDatas[a+1].isHeader){
          // 改变布局
          if(currentScrollPosition-beforeScroll<0){
            //检测到再向上划就越出当前组 提前改变header的内容并偏移
            for(int i=a;i>=0;i--){
              if(widget.adsorptionDatas[i].isHeader){
                headerStr=widget.adsorptionDatas[i];
                break;
              }
            }
          }
          beforeScroll=currentScrollPosition;
          headerOffset=-b;
        }else{
          //始终使header处于完整显示状态
          for(int i=a;i>=0;i--){
            if(widget.adsorptionDatas[i].isHeader) {
              headerStr = widget.adsorptionDatas[i];
              break;
            }
          }
          headerOffset=0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new ListView.builder(
          cacheExtent: widget.cacheExtent,
          controller: scrollController,
          itemCount: widget.adsorptionDatas.length,
          itemBuilder: (context, index) {
            if(widget.adsorptionDatas[index].isHeader){
              return new Container(
                width: widget.itemWidth,
                height: widget.itemHeight,
                child: widget.headChild(widget.adsorptionDatas[index]),
              );
            }else{
              return new Container(
                width: widget.itemWidth,
                height: widget.itemHeight,
                child: widget.generalItemChild(widget.adsorptionDatas[index]),
              );
            }
          },
        ),
        new GestureDetector(
          onTap: (){
            double pixels=scrollController.position.pixels;
            int a=pixels~/widget.itemHeight;
            for(int i=a;i>=0;i--){
              if(widget.adsorptionDatas[i].isHeader) {
                setState(() {
                  scrollController.animateTo(i*widget.itemHeight, duration: new Duration(milliseconds: 200), curve: Curves.linear);
                });
                break;
              }
            }
          },
          child: new Container(
            key: key,
            transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
            width: widget.itemWidth,
            height: widget.itemHeight,
            child:widget.headChild(headerStr),
          ),
        ),
      ],
    );
  }
}






///此控件适用于非固定高度的ListView
class AdsorptionViewNotEqualHeightState<T extends AdsorptionListBin> extends State<AdsorptionView>{

  ScrollController scrollController=new ScrollController();
  double itemHeight=50.0;
  double headerOffset=0.0;
  T headerData;
  GlobalKey hearKey=new GlobalKey();
  GlobalKey listViewKey=new GlobalKey();
  double beforeScroll=0.0;
  List<int> positions;
  double lastTimePix=0.0;
  double headersHeight=65.0;

  @override
  void initState() {
    super.initState();
    headerData=widget.adsorptionDatas.first;
    scrollController.addListener((){
      handlingEvents();
    });
  }


  void handlingEvents() async{
    if(positions!=null&&positions.length>0){
      int firstChildPosition=positions.first;
      int lastChildPosition=positions.last;

      double chileGlobalPositionY;
      double chileHeight;
      //headView的高度
      double hearKeyHeight=hearKey.currentContext.findRenderObject().paintBounds.size.height;
      //获取ListView在屏幕中的位置
      double listViewGlobalPositionY=listViewKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
      for(int i=firstChildPosition;i<=lastChildPosition;i++){
        if(widget.adsorptionDatas[i].adsorptionKey.currentContext==null){
          continue;
        }
        //子控件在屏幕中的位置 用于计算第一个可见Item的位置
        chileGlobalPositionY=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
        //控件高度 用于计算第一个可见Item的位置
        chileHeight=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().paintBounds.size.height;
        //如果在屏幕中可见
        if(chileGlobalPositionY+chileHeight>listViewGlobalPositionY){
          int a=0;
          //计算header处于完整显示状态的位置
          for(int k=i;k<lastChildPosition;k++){
            if(widget.adsorptionDatas[k].isHeader){
              a=k;
              break;
            }
          }
          double currentScrollPosition=scrollController.position.extentBefore;

          //下一个Hear的位置，用于计算是否需要吸顶
          double nextHeaderGlobalPositionY;
          if(a>=1) {
            nextHeaderGlobalPositionY=widget.adsorptionDatas[a].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
          } else{
            //如果是0  则可能是因为是最后一个hear  后面没有了 所以a=0
            setState(() {
              //始终使header处于完整显示状态
              for(int m=i;m>=0;m--){
                if(widget.adsorptionDatas[m].isHeader) {
                  headerData = widget.adsorptionDatas[m];
                  break;
                }
              }
              headerOffset=0.0;

            });
            break;
          }


          //如果nextHeader滑动到吸顶布局下面  就是说被覆盖  则需要偏移吸顶布局
          if(listViewGlobalPositionY +hearKeyHeight>nextHeaderGlobalPositionY){
            setState(() {
              // 改变布局
              if(currentScrollPosition-beforeScroll<0){
                //检测到再向上划就越出当前组 提前改变header的内容并偏移
                for(int i=a-1;i>=0;i--){
                  if(widget.adsorptionDatas[i].isHeader){
                    headerData=widget.adsorptionDatas[i];
                    break;
                  }
                }
              }
              beforeScroll=currentScrollPosition;

              headerOffset = nextHeaderGlobalPositionY - listViewGlobalPositionY - hearKeyHeight;
              if(headerOffset<-hearKeyHeight){
                headerData=widget.adsorptionDatas[a];
                headerOffset=0.0;
              }
            });
          }else{
            setState(() {
              //始终使header处于完整显示状态
              for(int m=i;m>=0;m--){
                if(widget.adsorptionDatas[m].isHeader) {
                  headerData = widget.adsorptionDatas[m];
                  break;
                }
              }
              headerOffset=0.0;
            });
          }
          break;
        }
      }
    }
  }

  int memoryPosition;


  @override
  Widget build(BuildContext context) {
    return new Stack(
          children: <Widget>[
            new NotificationListener(
              onNotification: (notification){
                if(notification is ScrollStartNotification){
                  if(positions==null) {
                    positions=new List();
                    for(int i=0 ;i<=memoryPosition;i++){
                      positions.add(i);
                    }
                  }
                }
              },
              child: new ListView.builder(
                key: listViewKey,
                controller: scrollController,
                cacheExtent: widget.cacheExtent,
                itemCount: widget.adsorptionDatas.length,
                itemBuilder: (context, index) {
                  if(positions!=null) {
                    if (index > positions.last) {
                      positions.removeAt(0);
                      positions.add(index);
                    } else if (index < positions.first) {
                      positions.removeLast();
                      positions.insert(0, index);
                    }
                  }else{
                    memoryPosition=index;
                  }
                  if(widget.adsorptionDatas[index].isHeader){
                    //返回头部视图
                    return new Container(
                      key: widget.adsorptionDatas[index].adsorptionKey,
                      width: widget.itemWidth,
                      child: widget.headChild(widget.adsorptionDatas[index]),
                    );
                  }else {
                    //返回组成员的视图
                    return new Container(
                      key: widget.adsorptionDatas[index].adsorptionKey,
                      width: widget.itemWidth,
                      child: widget.generalItemChild(widget.adsorptionDatas[index]),
                    );
                  }
                },),
            ),


            new GestureDetector(
              onTap: (){
                double pixels=scrollController.position.pixels;
                int a=pixels~/itemHeight;
                for(int i=a;i>=0;i--){
                  if(widget.adsorptionDatas[i].isHeader) {
                    setState(() {
                      scrollController.animateTo(i*itemHeight, duration: new Duration(milliseconds: 200), curve: Curves.linear);
                    });
                    break;
                  }
                }
              },
              child: new Container(
                key: hearKey,
                transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
                width: widget.itemWidth,
                child: widget.headChild(headerData),
              ),
            ),
          ],
        );
  }
}

