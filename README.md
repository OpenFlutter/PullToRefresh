`由于GIF太多（大），演示的图片可能会卡，请移步至demonstrationgif文件夹下可查看单个GIF图片`

## PullToRefresh  [![pub package](https://img.shields.io/pub/v/pulltorefresh_flutter.svg)](https://pub.dartlang.org/packages/pulltorefresh_flutter)
#### Usage
Add this to your package's pubspec.yaml file:

	dependencies:
	  pulltorefresh_flutter: "^0.1.6"
	  
If you want to use the default refresh image of this project (the rotated image), please download https://raw.githubusercontent.com/baoolong/PullToRefresh_Flutter/master/images/refresh.png to your images folder, and Pubspec.yaml is declared as follows.

If you want to use other images, put the image in the Images folder, declare it in the Pubspec.yaml file, and add the property refreshIconPath in the PullAndPush class.
	
	assets:
	  - images/refresh.png
	
Add it to your dart file:

	import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';
#### Example
   [https://github.com/baoolong/PullToRefresh_Flutter](https://github.com/baoolong/PullToRefresh_Flutter)

本功能只实现基本的上下拉刷新，可在这个基础上进行改进、优化、封装，如果只是使用，可在build方法中修改ListView控件和List数组的泛型,已经兼容IOS，已经支持对下拉和上拉的分别控制

<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180813170926.gif"/>         <img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20181023_90359.gif"/>

## 仿京东广告滑动切换 ##
模仿的京东潮男模块的广告滑动切换，本人做的比较粗糙，大家可以在此基础上改进，比如滞后滑动，底层图片缩小等，由于没有进行屏幕适配，所以可能不同的手机会显示很丑，这是由于我在设计图片之间的Magin是用屏幕宽度减去两边距屏幕的宽度，再除以3计算的，大家可以根据需要去设定图片之间的Magin，最好固定值

<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180814_142135.gif"/>

## Marquee（跑马灯） [![pub package](https://img.shields.io/pub/v/marquee_flutter.svg)](https://pub.dartlang.org/packages/marquee_flutter)

一个用ListView做的跑马灯，可以垂直方向滚动，也可以水平方向滚动

A Marquee widght with ListView,Can scroll vertically or horizontally

#### Usage
Add this to your package's pubspec.yaml file:

	dependencies:
	  marquee_flutter: ^0.1.1
	  
Add it to your dart file:

    import 'package:marquee_flutter/marquee_flutter.dart';
    
#### Example
[https://github.com/baoolong/MarqueeWidget](https://github.com/baoolong/MarqueeWidget)

    
采用ListView绘制，将ListView设置为不可手动滑动，然后启动Timer来回拖动，造成跑马灯的错觉
<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180814_142220.gif"/>
## DragableGridView  [![pub package](https://img.shields.io/pub/v/dragablegridview_flutter.svg)](https://pub.dartlang.org/packages/dragablegridview_flutter)
采用GridView +OverflowBox +Container的transform属性来完成，由于计算不精确，考虑不周全，现在还有很多问题，后续改进，学习的朋友可以拿去自己研究改进，添加新功能，下面是示例图
### Usage

Add this to your package's pubspec.yaml file:

	dependencies:
	  dragablegridview_flutter: ^0.1.2
	  
Add it to your dart file:

    import 'package:dragablegridview_flutter/dragablegridview_flutter.dart';
    
And GridView dataBin must extends DragAbleGridViewBin ,Add it to your dataBin file 
    
    import 'package:dragablegridview_flutter/dragablegridviewbin.dart';
    
### Example
[https://github.com/baoolong/DragableGridview](https://github.com/baoolong/DragableGridview)

----------

<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180821_094948.gif"/>        <img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180822_115107.gif"/>


## AdsorptionView [![pub package](https://img.shields.io/pub/v/adsorptionview_flutter.svg)](https://pub.dartlang.org/packages/adsorptionview_flutter)
ListView吸顶控件，本控件只适用于ListView的Item高度固定的布局（AdsorptionViewState），如果高度不固定会有偏差。已经更新了非固定高度的吸顶布局（AdsorptionViewNotEqualHeightState），有一点点小问题，请自行解决，里面有如何获取ListView第一个可见Item的方法，可供参考
### Usage
Add this to your package's pubspec.yaml file:

	dependencies:
	  adsorptionview_flutter: ^0.1.2
	  
Add it to your dart file:

    import 'package:adsorptionview_flutter/adsorptionview_flutter.dart';
    
And ListView dataBin must extends AdsorptionData ,Add it to your dataBin file
    
    import 'package:adsorptionview_flutter/adsorptiondatabin.dart';

### Example
[https://github.com/baoolong/Adsorptionview](https://github.com/baoolong/Adsorptionview)

<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180912_100745.gif"/>
