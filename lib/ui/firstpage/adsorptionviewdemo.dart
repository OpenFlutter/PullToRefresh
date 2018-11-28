import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/bin/adsorptionlistbin.dart';
import 'package:flutterapp/components/adsorptionview.dart';

class AdsorptionViewDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    List<AdsorptionListBin> adsorptionDatas=new List();
    AdsorptionListBin adsorptionData;

    adsorptionData=new AdsorptionListBin("A");
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("阿杜");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("阿宝");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("艾夫杰尼");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("阿牛");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("安苏羽");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("阿勒长青");
    adsorptionDatas.add(adsorptionData);


    adsorptionData=new AdsorptionListBin("B");
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("白小白");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("白羽毛");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("Bridge");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("斑马");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("白一阳");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("白举纲");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("暴林");
    adsorptionDatas.add(adsorptionData);


    adsorptionData=new AdsorptionListBin("C");
    adsorptionData.isHeader=true;
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈奕迅");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈小春");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("成龙");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈百强");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("迟志强");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("崔健");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈晓东");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈学冬");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("蔡国庆");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈冠希");
    adsorptionDatas.add(adsorptionData);

    adsorptionData=new AdsorptionListBin("陈琳");
    adsorptionDatas.add(adsorptionData);
    return new AdsorptionViewState(adsorptionDatas);
  }
}

///此控件适用于固定高度的ListView
class AdsorptionViewState extends State<AdsorptionViewDemo>{

  AdsorptionViewState(this.adsorptionDatas);

  List<AdsorptionListBin> adsorptionDatas;
  double itemHeight=50.0;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("吸附布局"),
      ),
      body:new AdsorptionView(
        isEqualHeightItem: true,
        adsorptionDatas: adsorptionDatas,
        generalItemChild: (AdsorptionListBin bin) {
          return new Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: new Text(
              bin.headerName,
              style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          );
        },
        headChild: (AdsorptionListBin bin) {
          return new Container(
            color: Colors.grey,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: new Text(
              bin.headerName,
              style: new TextStyle( fontSize: 20.0,color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}





