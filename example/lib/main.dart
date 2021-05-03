import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ezplayer/flutter_ezplayer.dart';
import 'package:flutter/material.dart';
import './home_page.dart';
import './list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  EZPlayerController controller;

  void onEZPlayerControllerCreated(EZPlayerController controller) {
    this.controller = controller;
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _platformVersion = 'Unknown';
  var _currentIndex = 0; //当前选中页面索引
  List<Widget> _pages = [HomePage(), ListPage()];

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await FlutterEzplayer.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: Colors.redAccent,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.accent,
            minWidth: 1,
          )),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("EZPlayer Example"),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: ((index) {
                setState(() {
                  _currentIndex = index;
                });
              }),
              items: [
                new BottomNavigationBarItem(
                    title: new Text(
                      'Base',
                      style: TextStyle(
                          color:
                              _currentIndex == 0 ? Colors.red : Colors.black),
                    ),
                    icon: Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.red : Colors.black,
                    )),
                new BottomNavigationBarItem(
                    title: new Text(
                      'List',
                      style: TextStyle(
                          color:
                              _currentIndex == 1 ? Colors.red : Colors.black),
                    ),
                    icon: Icon(
                      Icons.list,
                      color: _currentIndex == 1 ? Colors.red : Colors.black,
                    )),
              ])),
    );
  }
}
