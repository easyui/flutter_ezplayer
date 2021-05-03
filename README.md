# flutter_ezplayer

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# flutter_ezplayer
![License](https://img.shields.io/cocoapods/l/EZPlayer.svg?style=flat) 

EZPlayer component for flutter apps

## 预览

![EZPlayerFlutterBase](EZPlayerFlutterBase.gif) ![EZPlayerFlutterList](EZPlayerFlutterList.gif)


## 介绍
基于[EZPlayer](https://github.com/easyui/EZPlayer)封装的视频播放器，功能丰富，快速集成，可定制性强。

## 要求
- iOS 9.0+ 
- Xcode 12.0+
- Swift 5.0+
- Flutter 1.22.2+ 

## 特性
- 本地视频、网络视频播放（支持的格式请参考苹果AVPlayer文档）
- [全屏模式/嵌入模式/浮动模式随意切换(支持根据设备自动旋转)](#DisplayMode)
- [全屏模式支持横屏全屏和竖屏全屏](#DisplayMode)
- [浮动模式支持系统PIP和window浮层](#FloatMode)
- [定制手势：播放/暂停(全屏/嵌入模式双击，浮动模式单击)，浮动和全屏切换（双击），音量/亮度调节（上下滑动），进度调节（左右滑动）](#GestureRecognizer)
- [支持airPlay](#airPlay)
- [支持UITableview自动管理嵌入和浮动模式切换](#tableview)
- [视频比例填充（videoGravity）切换](#videoGravity)
- [字幕/CC切换](#subtitle&cc&audio)
- [音频切换](#subtitle&cc&audio)
- [拖动进度显示预览图（m3u8不支持）](#preview)
- [播放器控件皮肤自定义（自带一套浮动皮肤，嵌入和全屏用的一套皮肤）](#skin)
- [支持广告功能](#ad)

## 使用
可以参考[example](https://github.com/easyui/EZPlayer/tree/master/EZPlayerExample_RN)项目，

### flutter_ezplayer 文件：


FlutterEZPlayerPlugin.h & FlutterEZPlayerPlugin.m ： oc桥接

SwiftFlutterEZPlayerPlugin.swift：继承自FlutterPlugin对象，该对象主要是用来向flutter注册我们的plugin

EZPlayerFactory.swift：工厂的核心就是这个createWithFrame方法了，这个方法是由dart侧来驱动的

EZPlayerController.swift：controller继承自FlutterPlatformView协议，工厂调用Controller对象来创建真正的view实例。

flutter_ezplayer.dart ： EZPlayer封装的入口文件

player.dart: player widget 

player_controller.dart:  EZPlayer通知交互，播放器的基础动作

utils.dart： lib的辅助方法

### 属性
| key | description | value |                   
| --- | --- | --- | 
| url | 视频数据源  | String |
| autoPlay|设置数据源后自动播放| bool |
| useDefaultUI|使用EZPlayer自带皮肤| bool |
| videoGravity|视频画面比例| VideoGravity |
| fullScreenMode|全屏模式是竖屏还是横屏| FullScreenMode |
| floatMode|浮动模式支持系统PIP和window浮层| FloatMode |
| onPlayerHeartbeat|播放器声明周期心跳| EZPlayerNotificationCallback |
| onPlayerPlaybackTimeDidChange|addPeriodicTimeObserver方法的触发| EZPlayerNotificationCallback |
| onPlayerStatusDidChange|播放器状态改变| EZPlayerNotificationCallback |
| onPlayerPlaybackDidFinish|视频结束| EZPlayerNotificationCallback | 
| onPlayerLoadingDidChange|loading状态改变| EZPlayerNotificationCallback | 
| onPlayerControlsHiddenDidChange|播放器控制条隐藏显示| EZPlayerNotificationCallback | 
| onPlayerDisplayModeDidChange|播放器显示模式改变了（全屏，嵌入屏，浮动）| PropTypes.object | 
| onPlayerDisplayModeChangedWillAppear |播放器显示模式动画开始| EZPlayerNotificationCallback |
| onPlayerDisplayModeChangedDidAppear |播放器显示模式动画结束| EZPlayerNotificationCallback |
| onPlayerTapGestureRecognizer |点击播放器手势通知| EZPlayerNotificationCallback |
| onPlayerDidPersistContentKey |FairPlay DRM| EZPlayerNotificationCallback |
| onPlayerPIPControllerWillStart |即将开启画中画| EZPlayerNotificationCallback |
| onPlayerPIPControllerDidStart |已经开启画中画| EZPlayerNotificationCallback |
| onPlayerPIPFailedToStart |开启画中画失败| EZPlayerNotificationCallback |
| onPlayerPIPControllerWillEnd |即将关闭画中画| EZPlayerNotificationCallback |
| onPlayerPIPControllerDidEnd |已经关闭画中画| EZPlayerNotificationCallback |
| onPlayerPIPRestoreUserInterfaceForStop |关闭画中画且恢复播放界面| EZPlayerNotificationCallback |

### 方法
| function | description |                    
| --- | --- | 
| Future<void> play(String url, [String title]) async | 播放  |
| Future<void> start() async | 播放 |
| Future<void> pause() async  | 暂停 | 
| Future<void> stop() async | 结束 | 
| Future<bool> seek(double time) async | 设置播放进度，单位秒 | 
| Future<void> replaceToPlay(String url, [String title]) async | 替换播放源 |
| Future<void> rate(double rate) async | 设置播放速率 | 
| Future<void> autoPlay(bool autoPlay) async | 设置自动播放，autoPlay是PropTypes.bool | 
| Future<void> videoGravity(VideoGravity videoGravity) async | 设置视频画面比例，videoGravity：aspect,aspectFill,scaleFill | 
| Future<bool> toEmbedded([bool animated = true]) async | 进入嵌入屏模式 |
| Future<bool> toFloat([bool animated = true]) async | 进入悬浮屏模式 |
| Future<bool> toFull(
      [bool animated = true,
      landscapeOrientation = LandscapeOrientation.left]) async | 进入全屏模式，orientation: landscapeLeft , landscapeRight | 
| Future<void> fullScreenMode(FullScreenMode fullScreenMode) async | 设置全屏的模式，fullScreenMode:portrait , landscape | 

### demo文件：

main.dart： 入口

home_page.dart ： EZPlayer的基础功能演示

list_page.dart ：EZPlayer 在列表中的演示


## License
EZPlayer遵守MIT协议，具体请参考MIT


