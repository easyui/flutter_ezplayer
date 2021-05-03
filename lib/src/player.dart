part of flutter_ezplayer;

class EZPlayer extends StatefulWidget {
  const EZPlayer({
    Key key,
    this.onEZPlayerWidgetCreated,
    this.useDefaultUI = true,
    this.autoPlay = true,
    this.videoGravity = VideoGravity.aspect,
    this.fullScreenMode = FullScreenMode.landscape,
    this.floatMode = FloatMode.auto,
    this.url = "",
    this.onPlayerHeartbeat,
    this.onPlayerPlaybackTimeDidChange,
    this.onPlayerStatusDidChange,
    this.onPlayerPlaybackDidFinish,
    this.onPlayerLoadingDidChange,
    this.onPlayerControlsHiddenDidChange,
    this.onPlayerDisplayModeDidChange,
    this.onPlayerDisplayModeChangedWillAppear,
    this.onPlayerDisplayModeChangedDidAppear,
    this.onPlayerTapGestureRecognizer,
    this.onPlayerDidPersistContentKey,
    this.onPlayerPIPControllerWillStart,
    this.onPlayerPIPControllerDidStart,
    this.onPlayerPIPFailedToStart,
    this.onPlayerPIPControllerWillEnd,
    this.onPlayerPIPControllerDidEnd,
    this.onPlayerPIPRestoreUserInterfaceForStop,
  }) : super(key: key);

  final EZPlayerWidgetCreatedCallback
      onEZPlayerWidgetCreated; //这个参数controller其实就是和native侧做交互的对象
  final bool useDefaultUI;
  final bool autoPlay;
  final VideoGravity videoGravity;
  final FullScreenMode fullScreenMode;
  final FloatMode floatMode;
  final String url;

  final EZPlayerNotificationCallback onPlayerHeartbeat;
  final EZPlayerNotificationCallback onPlayerPlaybackTimeDidChange;
  final EZPlayerNotificationCallback onPlayerStatusDidChange;
  final EZPlayerNotificationCallback onPlayerPlaybackDidFinish;
  final EZPlayerNotificationCallback onPlayerLoadingDidChange;
  final EZPlayerNotificationCallback onPlayerControlsHiddenDidChange;
  final EZPlayerNotificationCallback onPlayerDisplayModeDidChange;
  final EZPlayerNotificationCallback onPlayerDisplayModeChangedWillAppear;
  final EZPlayerNotificationCallback onPlayerDisplayModeChangedDidAppear;
  final EZPlayerNotificationCallback onPlayerTapGestureRecognizer;
  final EZPlayerNotificationCallback onPlayerDidPersistContentKey;
  final EZPlayerNotificationCallback onPlayerPIPControllerWillStart;
  final EZPlayerNotificationCallback onPlayerPIPControllerDidStart;
  final EZPlayerNotificationCallback onPlayerPIPFailedToStart;
  final EZPlayerNotificationCallback onPlayerPIPControllerWillEnd;
  final EZPlayerNotificationCallback onPlayerPIPControllerDidEnd;
  final EZPlayerNotificationCallback onPlayerPIPRestoreUserInterfaceForStop;

  // @override
  // void dispose() {
  //   super.dispose();
  //   // GoogleMapController controller = await _controller.future;
  //   // controller.dispose();
  // }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EZPlayerState();
  }
}

class _EZPlayerState extends State<EZPlayer> {
  EZPlayerController _controller;
  // final Completer<EZPlayerController> _controller =
  // Completer<EZPlayerController>();

  @override
  void dispose() async {
    super.dispose();
    // EZPlayerController controller = await _controller.future;
    // controller.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _creationParams = <String, dynamic>{
      "useDefaultUI": widget.useDefaultUI,
      "autoPlay": widget.autoPlay,
      "videoGravity": describeEnum(widget.videoGravity),
      "fullScreenMode": describeEnum(widget.fullScreenMode),
      "floatMode": describeEnum(widget.floatMode),
      "url": widget.url,
    };

    // TODO: implement build
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "plugins/flutter_ezplayer", //这个是传递给native侧，用作view factory的key
        onPlatformViewCreated: _onPlatformViewCreated, //允许传递给native侧的初始化参数
        creationParams: _creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text('flutter_ezplayer does not support $defaultTargetPlatform ');
  }

  void _onPlatformViewCreated(int id) {
    final controller = new EZPlayerController._(id, this);
    // _controller.complete(controller);
    _controller = controller;
    if (widget.onEZPlayerWidgetCreated == null) {
      return;
    }
    widget.onEZPlayerWidgetCreated(controller);
  }
}
