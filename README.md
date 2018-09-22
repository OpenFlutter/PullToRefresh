
`由于GIF太多（大），演示的图片可能会卡，请移步至demonstrationgif文件夹下可查看单个GIF图片`

## PullToRefresh ##

PullToRefresh Path: lib/pullandpush.dart

#### Usage
Add this to your package's pubspec.yaml file:

	dependencies:pulltorefresh_flutter: "^0.0.2"
	
	assets:
	  - images/refresh.png
	
Add it to your dart file:

	import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';
#### Example
   https://github.com/baoolong/PullToRefresh_Flutter

本功能只实现基本的上下拉刷新，可在这个基础上进行改进、优化、封装，如果只是使用，可在build方法中修改ListView控件和List数组的泛型

<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180813170926.gif"/>

## 仿京东广告滑动切换 ##
模仿的京东潮男模块的广告滑动切换，本人做的比较粗糙，大家可以在此基础上改进，比如滞后滑动，底层图片缩小等，由于没有进行屏幕适配，所以可能不同的手机会显示很丑，这是由于我在设计图片之间的Magin是用屏幕宽度减去两边距屏幕的宽度，再除以3计算的，大家可以根据需要去设定图片之间的Magin，最好固定值
<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180814_142135.gif"/>

## WheelView ##
模拟滚动（只是不断的偏移，造成滚动的错觉），由于编码没有考虑清楚，Item和Item之间的高度是固定的，导致看起来没有物理既视感（具体可看图片），如果想改动，建议采用角度机制进行排列，录制的GIF滑动快时看起来有问题，实际正常
<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180814_142304.gif"/>

## 跑马灯 ##
采用ListView绘制，将ListView设置为不可手动滑动，然后启动Timer来回拖动，造成跑马灯的错觉
<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180814_142220.gif"/>

## DragableGridView 可拖动GridView ##
采用GridView +OverflowBox +Container的transform属性来完成，由于计算不精确，考虑不周全，现在还有很多问题，后续改进，学习的朋友可以拿去自己研究改进，添加新功能，下面是示例图

----------

<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180821_094948.gif"/>        <img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180822_115107.gif"/>


## Sticky_Headers ##
ListView吸顶控件，本控件只适用于ListView的Item高度固定的布局（AdsorptionViewState），如果高度不固定会有偏差。已经更新了非固定高度的吸顶布局（AdsorptionViewNotEqualHeightState），有一点点小问题，请自行解决，里面有如何获取ListView第一个可见Item的方法，可供参考
<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180912_100745.gif"/>
