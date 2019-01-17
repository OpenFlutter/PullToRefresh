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
  final LoginErrorMessageController loginErrorMessageController=LoginErrorMessageController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("登陆按钮动画"),
      ),
      body: new Center(
        child:new Container(
          child:new AnimatedLoginButton(
            loginErrorMessageController:loginErrorMessageController,
            onTap: () async {
              try {
                var request = await httpClient.getUrl(Uri.parse(url));
                var response = await request.close();
                if (response.statusCode == HttpStatus.ok) {
                  _result = await response.transform(utf8.decoder).join();

                  //拿到数据后，对数据进行梳理
                  loginErrorMessageController.showErrorMessage("网络异常");

                } else {
                  _result = 'ERROR CODE: ${response.statusCode}';
                  loginErrorMessageController.showErrorMessage("网络异常 $_result");
                }
              } catch (exception) {
                _result = '网络异常';
                loginErrorMessageController.showErrorMessage("网络异常");
              }
              print(_result);
            },
          ),
        ),
      ),
    );
  }

}