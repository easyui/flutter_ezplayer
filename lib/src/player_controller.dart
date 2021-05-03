part of flutter_ezplayer;

enum NotificationName {
  EZPlayerHeartbeat,
  EZPlayerPlaybackTimeDidChange,
  EZPlayerStatusDidChange,
  EZPlayerPlaybackDidFinish,
  EZPlayerLoadingDidChange,
  EZPlayerControlsHiddenDidChange,
  EZPlayerDisplayModeDidChange,
  EZPlayerDisplayModeChangedWillAppear,
  EZPlayerDisplayModeChangedDidAppear,
  EZPlayerTapGestureRecognizer,
  EZPlayerDidPersistContentKey,
  EZPlayerPIPControllerWillStart,
  EZPlayerPIPControllerDidStart,
  EZPlayerPIPFailedToStart,
  EZPlayerPIPControllerWillEnd,
  EZPlayerPIPControllerDidEnd,
  EZPlayerPIPRestoreUserInterfaceForStop,
}

enum MethodName {
  play,
  start,
  pause,
  stop,
  seek,
  replaceToPlay,
  toEmbedded,
  toFloat,
  toFull,
  setRate,
  setAutoPlay,
  setVideoGravity,
  setFullScreenMode,
  dispose,
}

enum VideoGravity {
  aspect,
  aspectFill,
  scaleFill,
}

enum FullScreenMode {
  portrait,
  landscape,
}

enum LandscapeOrientation {
  left,
  right,
}

enum FloatMode {
  none,
  auto,
  system,
  window,
}

typedef void EZPlayerWidgetCreatedCallback(EZPlayerController controller);
typedef void EZPlayerNotificationCallback(Map<String, dynamic> params);

class EZPlayerController {
  EZPlayerController._(int id, this._playerState)
      : _channel = MethodChannel('plugins/flutter_ezplayer_$id') {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
    _invokeMethodName(MethodName.dispose);
  }

  final MethodChannel _channel;
  final _EZPlayerState _playerState;

  final Map<String, NotificationName> _notificationNameByNative = {
    'com.ezplayer.EZPlayerHeartbeat': NotificationName.EZPlayerHeartbeat,
    'com.ezplayer.EZPlayerPlaybackTimeDidChange':
        NotificationName.EZPlayerPlaybackTimeDidChange,
    'com.ezplayer.EZPlayerStatusDidChange':
        NotificationName.EZPlayerStatusDidChange,
    'com.ezplayer.EZPlayerPlaybackDidFinish':
        NotificationName.EZPlayerPlaybackDidFinish,
    'com.ezplayer.EZPlayerLoadingDidChange':
        NotificationName.EZPlayerLoadingDidChange,
    'com.ezplayer.EZPlayerControlsHiddenDidChange':
        NotificationName.EZPlayerControlsHiddenDidChange,
    'com.ezplayer.EZPlayerDisplayModeDidChange':
        NotificationName.EZPlayerDisplayModeDidChange,
    'com.ezplayer.EZPlayerDisplayModeChangedWillAppear':
        NotificationName.EZPlayerDisplayModeChangedWillAppear,
    'com.ezplayer.EZPlayerDisplayModeChangedDidAppear':
        NotificationName.EZPlayerDisplayModeChangedDidAppear,
    'com.ezplayer.EZPlayerTapGestureRecognizer':
        NotificationName.EZPlayerTapGestureRecognizer,
    'com.ezplayer.EZPlayerDidPersistContentKey':
        NotificationName.EZPlayerDidPersistContentKey,
    'com.ezplayer.EZPlayerPIPControllerWillStart':
        NotificationName.EZPlayerPIPControllerWillStart,
    'com.ezplayer.EZPlayerPIPControllerDidStart':
        NotificationName.EZPlayerPIPControllerDidStart,
    'com.ezplayer.EZPlayerPIPFailedToStart':
        NotificationName.EZPlayerPIPFailedToStart,
    'com.ezplayer.EZPlayerPIPControllerWillEnd':
        NotificationName.EZPlayerPIPControllerWillEnd,
    'com.ezplayer.EZPlayerPIPControllerDidEnd':
        NotificationName.EZPlayerPIPControllerDidEnd,
    'com.ezplayer.EZPlayerPIPRestoreUserInterfaceForStop':
        NotificationName.EZPlayerPIPRestoreUserInterfaceForStop,
  };

  Future<void> play(String url, [String title]) async {
    var params = new Map();
    params['url'] = url;
    if (title != null) {
      params['title'] = title;
    }
    await _invokeMethodName(MethodName.play, params);
  }

  Future<void> start() async {
    await _invokeMethodName(MethodName.start);
  }

  Future<void> pause() async {
    await _invokeMethodName(MethodName.pause);
  }

  Future<void> stop() async {
    await _invokeMethodName(MethodName.stop);
  }

  Future<bool> seek(double time) async {
    return await _invokeMethodName(MethodName.seek, {'time': time});
  }

  Future<void> replaceToPlay(String url, [String title]) async {
    Map params = new Map();
    params['url'] = url;
    if (title != null) {
      params['title'] = title;
    }
    await _invokeMethodName(MethodName.replaceToPlay, params);
  }

  Future<bool> toEmbedded([bool animated = true]) async {
    return await _invokeMethodName(
        MethodName.toEmbedded, {'animated': animated});
  }

  Future<bool> toFloat([bool animated = true]) async {
    return await _invokeMethodName(MethodName.toFloat, {'animated': animated});
  }

  Future<bool> toFull(
      [bool animated = true,
      landscapeOrientation = LandscapeOrientation.left]) async {
    return await _invokeMethodName(MethodName.toFull, {
      'animated': animated,
      'landscapeOrientation': describeEnum(landscapeOrientation)
    });
  }

  Future<void> rate(double rate) async {
    return _invokeMethodName(MethodName.setRate, {'rate': rate});
  }

  Future<void> autoPlay(bool autoPlay) async {
    return _invokeMethodName(MethodName.setAutoPlay, {'autoPlay': autoPlay});
  }

  Future<void> videoGravity(VideoGravity videoGravity) async {
    return _invokeMethodName(MethodName.setVideoGravity,
        {'videoGravity': describeEnum(videoGravity)});
  }

  Future<void> fullScreenMode(FullScreenMode fullScreenMode) async {
    return _invokeMethodName(MethodName.setFullScreenMode,
        {'fullScreenMode': describeEnum(fullScreenMode)});
  }

  Future<T> _invokeMethodName<T>(MethodName method, [dynamic arguments]) async {
    final T typedResult = await _invokeMethod(describeEnum(method), arguments);
    return typedResult;
  }

  ///发送消息给native。约定：1、arguments参数用map  2、native返回map
  Future<T> _invokeMethod<T>(String method, [dynamic arguments]) async {
    final T typedResult = await _channel.invokeMethod(method, arguments);
    return typedResult;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    final notifiaction = _notificationNameByNative[call.method];
    switch (notifiaction) {
      case NotificationName.EZPlayerHeartbeat:
        if (_playerState.widget.onPlayerHeartbeat != null) {
          _playerState.widget.onPlayerHeartbeat(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPlaybackTimeDidChange:
        if (_playerState.widget.onPlayerPlaybackTimeDidChange != null) {
          _playerState.widget.onPlayerPlaybackTimeDidChange(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerStatusDidChange:
        if (_playerState.widget.onPlayerStatusDidChange != null) {
          _playerState.widget.onPlayerStatusDidChange(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPlaybackDidFinish:
        if (_playerState.widget.onPlayerPlaybackDidFinish != null) {
          _playerState.widget.onPlayerPlaybackDidFinish(
              call.arguments as Map<String, dynamic>);
        }
        return null;
        break;
      case NotificationName.EZPlayerLoadingDidChange:
        if (_playerState.widget.onPlayerLoadingDidChange != null) {
          _playerState.widget.onPlayerLoadingDidChange(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerControlsHiddenDidChange:
        if (_playerState.widget.onPlayerControlsHiddenDidChange != null) {
          _playerState.widget.onPlayerControlsHiddenDidChange(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerDisplayModeDidChange:
        if (_playerState.widget.onPlayerDisplayModeDidChange != null) {
          _playerState.widget.onPlayerDisplayModeDidChange(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerDisplayModeChangedWillAppear:
        if (_playerState.widget.onPlayerDisplayModeChangedWillAppear != null) {
          _playerState.widget
              .onPlayerDisplayModeChangedWillAppear(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerDisplayModeChangedDidAppear:
        if (_playerState.widget.onPlayerDisplayModeChangedDidAppear != null) {
          _playerState.widget
              .onPlayerDisplayModeChangedDidAppear(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerTapGestureRecognizer:
        if (_playerState.widget.onPlayerTapGestureRecognizer != null) {
          _playerState.widget.onPlayerTapGestureRecognizer(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerDidPersistContentKey:
        if (_playerState.widget.onPlayerDidPersistContentKey != null) {
          _playerState.widget.onPlayerDidPersistContentKey(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPControllerWillStart:
        if (_playerState.widget.onPlayerPIPControllerWillStart != null) {
          _playerState.widget.onPlayerPIPControllerWillStart(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPControllerDidStart:
        if (_playerState.widget.onPlayerPIPControllerDidStart != null) {
          _playerState.widget.onPlayerPIPControllerDidStart(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPFailedToStart:
        if (_playerState.widget.onPlayerPIPFailedToStart != null) {
          _playerState.widget.onPlayerPIPFailedToStart(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPControllerWillEnd:
        if (_playerState.widget.onPlayerPIPControllerWillEnd != null) {
          _playerState.widget.onPlayerPIPControllerWillEnd(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPControllerDidEnd:
        if (_playerState.widget.onPlayerPIPControllerDidEnd != null) {
          _playerState.widget.onPlayerPIPControllerDidEnd(call.arguments);
        }
        return null;
        break;
      case NotificationName.EZPlayerPIPRestoreUserInterfaceForStop:
        if (_playerState.widget.onPlayerPIPRestoreUserInterfaceForStop !=
            null) {
          _playerState.widget
              .onPlayerPIPRestoreUserInterfaceForStop(call.arguments);
        }
        return null;
        break;
      default:
        throw MissingPluginException();
        break;
    }
  }

  // const _ name
  // NotificationName _notificationNamefromNative(String name){
  //   if name == ''{}
  // }

}
