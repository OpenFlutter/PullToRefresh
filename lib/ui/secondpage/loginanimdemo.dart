import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutterapp/components/loginanimation.dart';

class LoginAnimationDemo extends StatefulWidget{

  final String loginTip="登陆";
  final double width=200.0,height=40.0;

  @override
  State<StatefulWidget> createState() {
    return new LoginAnimationDemoState();
  }

}

class LoginAnimationDemoState extends State<LoginAnimationDemo>{

  //使用系统的请求
  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result="";
  Color buttonColor=Colors.blue;
  final double textSize=16.0;
  TextStyle _textStyle;
  String loginTip="登陆";

  @override
  void initState() {
    super.initState();
    _textStyle=new TextStyle(fontSize: textSize, color: Colors.white);
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("登陆按钮动画"),
      ),
      body: new Center(
        child:new Container(
          child:new LoginAnimation(
            buttonColor: buttonColor,
            textStyle:_textStyle,
            loginTip: loginTip,
            onTap: () async {
              try {
                var request = await httpClient.getUrl(Uri.parse(url));
                var response = await request.close();
                if (response.statusCode == HttpStatus.ok) {
                  _result = await response.transform(utf8.decoder).join();
//                  setState(() {
//                    //拿到数据后，对数据进行梳理
//                    buttonColor=Colors.blue;
//                    _textStyle=new TextStyle(fontSize: textSize, color: Colors.white);
//                    loginTip="登陆成功";
//                  });

                  setState(() {
                    buttonColor=Colors.amberAccent;
                    _textStyle=new TextStyle(fontSize: textSize, color: Colors.red);
                    loginTip="网络异常";
                  });
                } else {
                  _result = 'ERROR CODE: ${response.statusCode}';
                  setState(() {
                    buttonColor=Colors.amberAccent;
                    _textStyle=new TextStyle(fontSize: textSize, color: Colors.red);
                    loginTip="网络异常 $_result";
                  });
                }
              } catch (exception) {
                _result = '网络异常';
                setState(() {
                  buttonColor=Colors.amberAccent;
                  _textStyle=new TextStyle(fontSize: textSize, color: Colors.red);
                  loginTip="网络异常";
                });
              }
              print(_result);
            },
          ),
        ),
      ),
    );
  }

}