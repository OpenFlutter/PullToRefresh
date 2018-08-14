**FlutterApp包含以下几个demo**
- PullToRefresh
- 仿京东广告滑动切换
- WheelView
- 跑马灯


## PullToRefresh ##

PullToRefresh Path: lib/pullandpush.dart

本功能只实现基本的上下拉刷新，可在这个基础上进行改进、优化、封装，如果只是使用，可在build方法中修改ListView控件和List数组的泛型

<img width="45%" height="45%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/images/20180813170926.gif"/>

## 仿京东广告滑动切换 ##
模仿的京东潮男模块的广告滑动切换，本人做的比较粗糙，大家可以在此基础上改进，比如滞后滑动，底层图片缩小等

## WheelView ##
模拟滚动（只是不断的偏移，造成滚动的错觉），由于编码没有考虑清楚，Item和Item之间的高度是固定的，导致看起来没有物理既视感（具体可看图片），如果想改动，建议采用角度机制进行排列

## 跑马灯 ##
采用ListView绘制，将ListView设置为不可手动滑动，然后启动Timer来回拖动，造成跑马灯的错觉


