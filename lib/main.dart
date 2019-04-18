import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Home.dart';


List<CameraDescription> cameras;

Future<void> main() async {

  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(
    new MaterialApp(
      title: 'Startup Name Generator',
      showPerformanceOverlay: false,
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new MyHomePage(),
    )
  );
}


void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');