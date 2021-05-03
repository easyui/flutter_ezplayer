import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ezplayer/flutter_ezplayer.dart';

class ListPage extends StatefulWidget {
  EZPlayerController controller;

  void onEZPlayerControllerCreated(EZPlayerController controller) {
    this.controller = controller;
  }

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _playerIndex = -1;
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

  Widget _buildCell(int index) {
    if (index == this._playerIndex) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width / 16 * 9,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            EZPlayer(
              url: "http://vjs.zencdn.net/v/oceans.mp4",
              onEZPlayerWidgetCreated: widget.onEZPlayerControllerCreated,
              onPlayerPlaybackDidFinish: (Map<String, dynamic> params) {
                setState(() {
                  _playerIndex = -1;
                });
              },
              onPlayerHeartbeat: (Map<String, dynamic> params) {
                print("99999999999999999999999999999999");
              },
            ),
            // InkWell(
            //     child: Container(
            //       alignment: Alignment.center,
            //       child: new Text("$index"),
            //     ),
            //     onTap: () {
            //       print("ssssssssssssssssssssssssssssss");
            //       widget.controller.play('http://vjs.zencdn.net/v/oceans.mp4');
            //     }),
          ],
        ),
      );
    }
    return InkWell(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.width / 16 * 9,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              // Container(
              //   alignment: Alignment.center,
              //   child: new Text("$index"),
              // ),
              InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text("$index"),
                  ),
                  onTap: () {
                    // widget.controller
                    // .play('http://vjs.zencdn.net/v/oceans.mp4');
                    setState(() {
                      _playerIndex = index;
                    });
                  }),
            ],
          ),
        ),
        onTap: () {
          // widget.controller.play('http://vjs.zencdn.net/v/oceans.mp4');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: new Stack(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                  // controller: _listScrollController,
                  itemBuilder: (_, int index) {
                    return _buildCell(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    // Divider()
                    return new Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      height: 1,
                      color: Color(0xffdddddd),
                    );
                  },
                  itemCount: 50),
            )
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 45.0, right: 45.0, top: 0.0, bottom: 50.0),
            //   child: new Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: <Widget>[
            //       FloatingActionButton(
            //         onPressed: () {
            //           widget.controller.start();
            //         },
            //         child: new Text("Start"),
            //       ),
            //       FloatingActionButton(
            //         onPressed: () {
            //           widget.controller.stop();
            //         },
            //         child: new Text("Stop"),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
