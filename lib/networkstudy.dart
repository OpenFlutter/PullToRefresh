import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';


class NetWorkCls extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new NetWorkState();
  }
}

class NetWorkState extends State<NetWorkCls>{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      title: "网络测试",
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new ImageWeight(),
    );
  }
}

class ImageWeight extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ImageWeightState();
  }
  
}

class ImageWeightState extends State<ImageWeight>{

  //使用系统的请求
  var httpClient = new HttpClient();
  //http://gank.io/api/data/
  var url = "http://gank.io/api/data/Android/1/1";
  var picUrl="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530784104719&di=c2f6a4746c87f50b99b400f9af8d54d0&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fd%2F580589c9a4873.jpg";
  var _result="";


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        _result = await response.transform(UTF8.decoder).join();
        //_decodeJson(_result, false);
      } else {
        _result = 'error code : ${response.statusCode}';
      }
    } catch (exception) {
      _result = '网络异常';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("网络测试"),
      ),
      body: new ListView(
        //scrollDirection: Axis.horizontal, //可实现横向滑动
        children: <Widget>[
          new FadeInImage.memoryNetwork( //FadeInImage表示淡入淡出
            placeholder: kTransparentImage,  //占位符
            image: 'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          ),
          new CachedNetworkImage( //缓存图片
            placeholder: new CircularProgressIndicator(),//占位符
            imageUrl: "https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true",
          ),
          new Image.network(picUrl),
          new Text(_result)
        ],
      ),
    );
  }
}