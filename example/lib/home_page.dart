import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ezplayer/flutter_ezplayer.dart';
import 'package:flutter/material.dart';

const url1 = 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8';
const url2 = 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4';
const url3 = 'http://vjs.zencdn.net/v/oceans.mp4';

class HomePage extends StatefulWidget {
  EZPlayerController controller;

  void onEZPlayerControllerCreated(EZPlayerController controller) {
    this.controller = controller;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _platformVersion = 'Unknown';
  final ScrollController _listScrollController = ScrollController();
  final TextEditingController _textEditingController =
      TextEditingController(text: url1);

  @override
  void initState() {
    _listScrollController.addListener(_scrollListener);

    super.initState();
    // initPlatformState();
  }

  _scrollListener() {
    FocusScope.of(context).requestFocus(FocusNode());
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
    if (index == 0) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                child: TextField(
              enabled: true,
              // overflow:
              // inputFormatters: <TextInputFormatter>[
              //   FFSLengthLimitingTextInputFormatter(100) //限制长度
              // ],
              // focusNode: viewModel.focusNode,
              onSubmitted: null,
              onEditingComplete: null,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 1,
              controller: _textEditingController,
              autofocus: false,
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                filled: true,
                fillColor: Color(0xfff5f5f5),
                hintText: 'please input video url',
                hintStyle: TextStyle(
                  color: Color(0xff999999),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1),
                  ),
                ),
              ),
            )),
            // SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('play'),
              onPressed: () {
                widget.controller.play(_textEditingController.text);
              },
            ),
          ],
        ),
      );
    } else if (index == 1) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Text(" Local "),
            // SizedBox(width: 1),
            // MaterialButton(
            //   color: Colors.blue,
            //   textColor: Colors.white,
            //   child: new Text('mp4'),
            //   onPressed: () {
            //     widget.controller.play("lib/resource/video/hubblecast.m4v");
            //   },
            // ),
          ],
        ),
      );
    } else if (index == 2) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Remote:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('t1'),
              onPressed: () {
                widget.controller.play(url1);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('t2'),
              onPressed: () {
                widget.controller.play(url2);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('t3'),
              onPressed: () {
                widget.controller.play(url3);
              },
            ),
          ],
        ),
      );
    } else if (index == 3) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Action:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('start'),
              onPressed: () {
                widget.controller.start();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('pause'),
              onPressed: () {
                widget.controller.pause();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('stop'),
              onPressed: () {
                widget.controller.stop();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('seek'),
              onPressed: () {
                widget.controller.seek(10);
              },
            ),
          ],
        ),
      );
    } else if (index == 4) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Rate:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('0.5'),
              onPressed: () {
                widget.controller.rate(0.5);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('1'),
              onPressed: () {
                widget.controller.rate(1.0);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('1.5'),
              onPressed: () {
                widget.controller.rate(1.5);
              },
            ),
          ],
        ),
      );
    } else if (index == 5) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Gravity:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('aspect'),
              onPressed: () {
                widget.controller.videoGravity(VideoGravity.aspect);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('aspectFill'),
              onPressed: () {
                widget.controller.videoGravity(VideoGravity.aspectFill);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('scaleFill'),
              onPressed: () {
                widget.controller.videoGravity(VideoGravity.scaleFill);
              },
            ),
          ],
        ),
      );
    } else if (index == 6) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("DisplayMode:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('em'),
              onPressed: () {
                widget.controller.toEmbedded();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('fullPor'),
              onPressed: () async {
                await widget.controller.fullScreenMode(FullScreenMode.portrait);
                widget.controller.toFull();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('fullLand'),
              onPressed: () async {
                await widget.controller
                    .fullScreenMode(FullScreenMode.landscape);
                widget.controller.toFull();
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('float'),
              onPressed: () {
                widget.controller.toFloat();
              },
            ),
          ],
        ),
      );
    } else if (index == 7) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Auto:"),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('auto'),
              onPressed: () {
                widget.controller.autoPlay(true);
              },
            ),
            SizedBox(width: 1),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('nonauto'),
              onPressed: () {
                widget.controller.autoPlay(false);
              },
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: new Stack(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // EZPlayer(
              //   onEZPlayerWidgetCreated: widget.onEZPlayerControllerCreated,
              // ),
              new Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width / 16 * 9,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    EZPlayer(
                      onEZPlayerWidgetCreated:
                          widget.onEZPlayerControllerCreated,
                    ),
                    // new Container(
                    //   alignment: Alignment.center,
                    //   child: new Text("flutter 控件~"),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                    controller: _listScrollController,
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
                    itemCount: 20),
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
            ]),
          ],
        ),
      ),
    );
  }
}
