import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdsorptionView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new AdsorptionViewState();
  }
}

///此控件适用于固定高度的ListView
class AdsorptionViewState extends State<AdsorptionView>{
  List<AdsorptionData> adsorptionDatas=new List();
  AdsorptionData adsorptionData;
  ScrollController scrollController=new ScrollController();
  double itemHeight=50.0;
  double headerOffset=0.0;
  String headerStr;
  GlobalKey key=new GlobalKey();
  double beforeScroll=0.0;

  @override
  void initState() {
    super.initState();
    headerStr="A";
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
            controller: scrollController,
            itemCount: adsorptionDatas.length,
            itemBuilder: (context, index) {
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

class AdsorptionData{
  String headerName;
  bool isHeader;
}

