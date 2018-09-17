import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdsorptionView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    List<AdsorptionData> adsorptionDatas=new List();
    AdsorptionData adsorptionData;

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="A";
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="阿杜";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="阿宝";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="艾夫杰尼";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="阿牛";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="安苏羽";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="阿勒长青";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);


    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="B";
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="白小白";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="白羽毛";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="Bridge";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="斑马";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="白一阳";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="白举纲";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="暴林";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);


    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="C";
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈奕迅";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈小春";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="成龙";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈百强";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="迟志强";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="崔健";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈晓东";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈学冬";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="蔡国庆";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈冠希";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionData();
    adsorptionData.headerName="陈琳";
    adsorptionData.isHeader=false;
    adsorptionDatas.add(adsorptionData);
    return new AdsorptionViewState(adsorptionDatas);
  }
}

///此控件适用于固定高度的ListView
class AdsorptionViewState extends State<AdsorptionView>{

  AdsorptionViewState(this.adsorptionDatas);

  List<AdsorptionData> adsorptionDatas;
  ScrollController scrollController=new ScrollController();
  double itemHeight=50.0;
  double headerOffset=0.0;
  String headerStr;
  GlobalKey key=new GlobalKey();
  double beforeScroll=0.0;

  @override
  void initState() {
    super.initState();
    headerStr=adsorptionDatas.first.headerName;

    scrollController.addListener((){
      double pixels=scrollController.position.pixels;

      int a=pixels~/itemHeight;
      double b=pixels%itemHeight;
      double currentScrollPosition=scrollController.position.extentBefore;
      setState(() {
        if(adsorptionDatas[a+1].isHeader){
          // 改变布局
          if(currentScrollPosition-beforeScroll<0){
            //检测到再向上划就越出当前组 提前改变header的内容并偏移
            for(int i=a;i>=0;i--){
              if(adsorptionDatas[i].isHeader){
                headerStr=adsorptionDatas[i].headerName;
                break;
              }
            }
          }
          beforeScroll=currentScrollPosition;
          headerOffset=-b;
        }else{
          //始终使header处于完整显示状态
          for(int i=a;i>=0;i--){
            if(adsorptionDatas[i].isHeader) {
              headerStr = adsorptionDatas[i].headerName;
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("吸附布局"),
      ),
      body:new Stack(
        children: <Widget>[
          new ListView.builder(
            cacheExtent: 30.0,
            controller: scrollController,
            itemCount: adsorptionDatas.length,
            itemBuilder: (context, index) {
              print("index ** $index");
              if(adsorptionDatas[index].isHeader){
                return new Container(
                  color: Colors.grey,
                  height: itemHeight,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: new Text(
                    adsorptionDatas[index].headerName,
                    style: new TextStyle( fontSize: 20.0,color: Colors.black),
                  ),
                );
              }else {
                return new Container(
                  height: itemHeight,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: new Text(
                    adsorptionDatas[index].headerName,
                    style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                );
              }
            },),
          new GestureDetector(
            onTap: (){
              double pixels=scrollController.position.pixels;
              int a=pixels~/itemHeight;
              for(int i=a;i>=0;i--){
                if(adsorptionDatas[i].isHeader) {
                  setState(() {
                    scrollController.animateTo(i*itemHeight, duration: new Duration(milliseconds: 200), curve: Curves.linear);
                  });
                  break;
                }
              }
            },
            child: new Container(
              key: key,
              transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
              color: Colors.grey,
              alignment: Alignment.centerLeft,
              height: itemHeight,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: new Text(
                headerStr,
                style: new TextStyle( fontSize: 20.0,color: Colors.black),
              ),
            ),
          ),
        ],
      )
    );
  }
}



///此控件适用于固定高度的ListView
class AdsorptionViewNotEqualHeightState extends State<AdsorptionView>{

  AdsorptionViewNotEqualHeightState(this.adsorptionDatas);
  List<AdsorptionData> adsorptionDatas;
  ScrollController scrollController=new ScrollController();
  double itemHeight=50.0;
  double headerOffset=0.0;
  String headerStr;
  GlobalKey hearKey=new GlobalKey();
  GlobalKey listViewKey=new GlobalKey();
  double beforeScroll=0.0;
  List<int> positions;
  double lastTimePix=0.0;
  double headersHeight=65.0;

  @override
  void initState() {
    super.initState();
    headerStr=adsorptionDatas.first.headerName;
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
        if(adsorptionDatas[i].adsorptionKey.currentContext==null){
          continue;
        }
        //子控件在屏幕中的位置 用于计算第一个可见Item的位置
        chileGlobalPositionY=adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
        //控件高度 用于计算第一个可见Item的位置
        chileHeight=adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().paintBounds.size.height;
        //如果在屏幕中可见
        if(chileGlobalPositionY+chileHeight>listViewGlobalPositionY){
          int a=0;
          //计算header处于完整显示状态的位置
          for(int k=i;k<lastChildPosition;k++){
            if(adsorptionDatas[k].isHeader){
              a=k;
              break;
            }
          }
          double currentScrollPosition=scrollController.position.extentBefore;

          //下一个Hear的位置，用于计算是否需要吸顶
          double nextHeaderGlobalPositionY;
          if(a>=1) {
            nextHeaderGlobalPositionY=adsorptionDatas[a].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
          } else{
            //如果是0  则可能是因为是最后一个hear  后面没有了 所以a=0
            setState(() {
              //始终使header处于完整显示状态
              for(int m=i;m>=0;m--){
                if(adsorptionDatas[m].isHeader) {
                  headerStr = adsorptionDatas[m].headerName;
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
                  if(adsorptionDatas[i].isHeader){
                    headerStr=adsorptionDatas[i].headerName;
                    break;
                  }
                }
              }
              beforeScroll=currentScrollPosition;

              headerOffset = nextHeaderGlobalPositionY - listViewGlobalPositionY - hearKeyHeight;
              if(headerOffset<-hearKeyHeight){
                headerStr=adsorptionDatas[a].headerName;
                headerOffset=0.0;
              }
            });
          }else{
            setState(() {
              //始终使header处于完整显示状态
              for(int m=i;m>=0;m--){
                if(adsorptionDatas[m].isHeader) {
                  headerStr = adsorptionDatas[m].headerName;
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("吸附布局"),
        ),
        body:new Stack(
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
                cacheExtent: 30.0,
                itemCount: adsorptionDatas.length,
                itemBuilder: (context, index) {
                  print("*********************************************");
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
                  if(adsorptionDatas[index].isHeader){
                    //返回头部视图
                    return new Container(
                      color: Colors.grey,
                      height: headersHeight,
                      key: adsorptionDatas[index].adsorptionKey,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: new Text(
                        adsorptionDatas[index].headerName,
                        style: new TextStyle( fontSize: 20.0,color: Colors.black),
                      ),
                    );
                  }else {
                    //返回组成员的视图
                    return new Container(
                      height: itemHeight,
                      key: adsorptionDatas[index].adsorptionKey,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: new Text(
                        adsorptionDatas[index].headerName,
                        style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    );
                  }
                },),
            ),


            new GestureDetector(
              onTap: (){
                double pixels=scrollController.position.pixels;
                int a=pixels~/itemHeight;
                for(int i=a;i>=0;i--){
                  if(adsorptionDatas[i].isHeader) {
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
                color: Colors.grey,
                alignment: Alignment.centerLeft,
                height: headersHeight,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                child: new Text(
                  headerStr,
                  style: new TextStyle( fontSize: 20.0,color: Colors.black),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class AdsorptionData{
  String headerName;
  bool isHeader;
  GlobalKey adsorptionKey=new GlobalKey();
}

