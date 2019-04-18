import 'package:flutter/material.dart';
import 'package:flutterapp/ui/thirdpage/examples/CameraTest.dart';
import 'package:flutterapp/ui/thirdpage/examples/ImagePicker.dart';

class Examples extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Examples"),
      ),
      body: new Container(
        margin: EdgeInsets.all(10),
        child: new Wrap(
          spacing: 10,
          children: <Widget>[
            new GestureDetector(
              child: new Chip(label: new Text("Camera")),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new CameraExampleHome();
                }));
              },
            ),

            new GestureDetector(
              child: new Chip(label: new Text("ImagePicker")),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new ImagePickerApp();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}

