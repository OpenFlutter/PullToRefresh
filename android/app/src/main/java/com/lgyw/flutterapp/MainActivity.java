package com.lgyw.flutterapp;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.flutter.lgyw/sensor";
  private SensorManager sm;
  private double pressure=0.0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    sm = (SensorManager) getSystemService(Context.SENSOR_SERVICE);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
      new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          if (call.method.equals("registerSensor")) {
            // 为压力传感器注册监听器
            boolean isSuccess=sm.registerListener(sensorEventListener, sm.getDefaultSensor(Sensor.TYPE_PRESSURE), SensorManager.SENSOR_DELAY_NORMAL);
            if(isSuccess){
              result.success("Success");
            }else{
              result.success("Faile");
            }
          }else if(call.method.equals("unRegisterSensor")){
            sm.unregisterListener(sensorEventListener);
            result.success("");
          }else if(call.method.equals("getPressure")){
            result.success(pressure);
          }
        }
    });
  }

  private SensorEventListener sensorEventListener=new SensorEventListener() {
    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
      if(sensorEvent.sensor.getType() == Sensor.TYPE_PRESSURE){
        pressure = sensorEvent.values[0];
        Log.i("MainActivity","sensorEvent.values[0] = " +sensorEvent.values[0]);
      }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
  };
}
