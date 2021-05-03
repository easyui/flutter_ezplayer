//
//  EZPlayerController.swift
//  flutter_ezplayer
//
//  Created by Yangjun Zhu on 2020/10/29.
//

import Foundation
import Flutter
import EZPlayer

public enum MethodName : String {
    case play
    case start
    case pause
    case stop
    case seek
    case replaceToPlay
    case toEmbedded
    case toFloat
    case toFull
    case setRate
    case setAutoPlay
    case setVideoGravity
    case setFullScreenMode
    case dispose
}

public class EZPlayerController: NSObject, FlutterPlatformView {
    private var viewId: Int64
    private var channel:FlutterMethodChannel
    private var player: EZPlayer?
    private var embeddedContentView:UIView
    private var params: [String:Any]
    
    // MARK: - life
    deinit {
        print("enter deinit")
        self.stop();
        removeObservers()
        self.channel.setMethodCallHandler(nil)
    }
    
//    dealloc{
//
//    }
    
    public init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger:FlutterBinaryMessenger) {
        self.viewId = viewId
        self.channel = FlutterMethodChannel(name: "plugins/flutter_ezplayer_\(viewId)", binaryMessenger: binaryMessenger) 
        self.embeddedContentView = UIView()
        self.embeddedContentView.backgroundColor = UIColor.clear
        self.params = args as? [String:Any]  ?? [String:Any]()
        //        let useDefaultUI = (params["useDefaultUI"] as? Bool) ?? true
        //        self.player = useDefaultUI ? EZPlayer() :  EZPlayer(controlView: UIView())
        //        self.player.autoPlay = (params["autoPlay"] as? Bool) ?? true
        //        //        self.player.videoGravity = EZPlayerVideoGravity(rawValue: (params["videoGravity"] as? String) ?? "aspect")
        //        self.player.videoGravity = EZPlayerVideoGravity(rawValue: (params["videoGravity"] as? String) ?? "aspect") ?? .aspect
        //        self.player.fullScreenMode = EZPlayerController.toEZPlayerFullScreenMode( (params["fullScreenMode"] as? String) ?? "landscape")
        //        self.player.floatMode = EZPlayerController.toEZPlayerFloatMode( (params["floatMode"] as? String) ?? "auto")
        
        //        self.player.autoPlay = (params["autoPlay"] as? Bool) ?? true
        //        self.player.autoPlay = (params["autoPlay"] as? Bool) ?? true
        
        
        super.init()
        
        //        self.player.backButtonBlock = {[weak self] fromDisplayMode in
        //            if fromDisplayMode == .embedded {
        //                self?.stop()
        //            }else if fromDisplayMode == .fullscreen {
        //
        //            }else if fromDisplayMode == .float {
        //                self?.stop()
        //            }
        //        }
        //
        //        self.addObservers()
        self.channel.setMethodCallHandler { [weak self](call: FlutterMethodCall,  result:@escaping FlutterResult) in
            self?.onMethodCall(call: call, result: result)
        }
        
        if let  urlStr = params["url"] as? String, let url = URL(string: urlStr)  {
            self.playWithURL(url, embeddedContentView: self.embeddedContentView, title: self.params["title"] as? String);
        }
        
        //        self.player.playWithURL("")
        //        let argsDict = args as Dictionary
        
    }
    
    
    // MARK: - FlutterPlatformView protocol
    public func view() -> UIView {
        //这个view对象就是真正的和dart层MapView widget对应的view了
        self.player?.view.frame = self.embeddedContentView.bounds
        return self.embeddedContentView
    }
    
    // MARK: - action
    func playWithURL(_ url: URL,embeddedContentView contentView: UIView? = nil, title: String? = nil) {
        self.initPlayerIfNeeded()
        
        if let player = self.player {
            if player.contentURL != nil {
                player.replaceToPlayWithURL(url, title: title)
            }else{
                player.playWithURL(url, embeddedContentView: contentView, title: title)
            }
        }
    }
    
    func start(){
        self.player?.play()
    }
    
    func pause(){
        self.player?.pause()
    }
    
    func stop(){
        self.player?.stop()
        self.releasePlayerResource()
    }
    
    
    // MARK: - private
    
    private func onMethodCall(call:FlutterMethodCall,result: @escaping FlutterResult){
        let method = call.method
        let methodName = MethodName(rawValue: method)
        switch methodName {
        case .play:
            guard  let params = call.arguments as? Dictionary<String, String>,let  urlStr = params["url"], let url = URL(string: urlStr) else{
                result(nil)
                return
            }
            
            self.playWithURL(url, embeddedContentView: self.embeddedContentView, title: params["title"])
            
            result(nil)
        case .start:
            self.start()
            result(nil)
        case .pause:
            self.pause()
            result(nil)
        case .stop:
            self.stop()
            result(nil)
        case .seek:
            guard let player = self.player, let params = call.arguments as? Dictionary<String, NSNumber>,let  time = params["time"] else{
                result(false)
                return
            }
            player.seek(to: time.doubleValue ) { (finished) in
                result(finished)
            }
        case .replaceToPlay:
            guard let player = self.player, let params = call.arguments as? Dictionary<String, String>,let  url = params["url"] else{
                result(nil)
                return
            }
            player.replaceToPlayWithURL(URL(string: url)!, title: params["title"])
            result(nil)
        case .toEmbedded:
            guard let player = self.player,  let params = call.arguments as? Dictionary<String, NSNumber>,let  animated = params["animated"] else{
                result(false)
                return
            }
            player.toEmbedded(animated: animated.boolValue) { (finished) in
                result(finished)
            }
        case .toFloat:
            guard  let player = self.player,let params = call.arguments as? Dictionary<String, NSNumber>,let  animated = params["animated"] else{
                result(false)
                return
            }
            player.toFloat(animated: animated.boolValue) { (finished) in
                result(finished)
            }
        case .toFull:
            guard  let player = self.player, let params = call.arguments as? Dictionary<String, Any>,let animated = params["animated"] as? NSNumber,let  landscapeOrientation = params["landscapeOrientation"] as? String else{
                result(false)
                return
            }
            player.toFull(landscapeOrientation == "left" ? .landscapeLeft : .landscapeRight, animated: animated.boolValue) { (finished) in
                result(finished)
            }
        case .setRate:
            guard  let player = self.player,let params = call.arguments as? Dictionary<String, NSNumber>,let  rate = params["rate"]  else{
                result(nil)
                return
            }
            player.rate = rate.floatValue
            result(nil)
        case .setAutoPlay:
            guard let player = self.player,let params = call.arguments as? Dictionary<String, NSNumber>,let  autoPlay = params["autoPlay"]  else{
                result(nil)
                return
            }
            player.autoPlay = autoPlay.boolValue
            result(nil)
        case .setVideoGravity:
            guard let player = self.player,let params = call.arguments as? Dictionary<String, String>,let  videoGravity = params["videoGravity"]  else{
                result(nil)
                return
            }
            player.videoGravity = EZPlayerController.toEZPlayerVideoGravity(videoGravity)
            result(nil)
        case .setFullScreenMode:
            guard let player = self.player,let params = call.arguments as? Dictionary<String, String>,let  fullScreenMode = params["fullScreenMode"]  else{
                result(nil)
                return
            }
            player.fullScreenMode = (fullScreenMode == "portrait") ? .portrait : .landscape
            result(nil)
        case .dispose:
            self.stop();
            self.channel.setMethodCallHandler(nil)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
}

extension EZPlayerController {
    private static  func toEZPlayerFullScreenMode(_ str: String) -> EZPlayerFullScreenMode{
        if str == "portrait" {
            return .portrait
        }else{
            return .landscape
        }
    }
    
    private static  func toEZPlayerFloatMode(_ str: String) -> EZPlayerFloatMode{
        if str == "none" {
            return .none
        }else if str == "system" {
            return .system
        }else if str == "window" {
            return .window
        }else{
            return .auto
        }
    }
    
    private static  func toEZPlayerVideoGravity(_ str: String) -> EZPlayerVideoGravity{
        if str == "aspect" {
            return .aspect
        }else if str == "aspectFill" {
            return .aspectFill
        }else{
            return .scaleFill
        }
    }
    
    private func initPlayerIfNeeded(){
        if(self.player == nil){
            self.addObservers()
            
            let useDefaultUI = (params["useDefaultUI"] as? Bool) ?? true
            self.player = useDefaultUI ? EZPlayer() :  EZPlayer(controlView: UIView())
            self.player!.autoPlay = (params["autoPlay"] as? Bool) ?? true
            //        self.player.videoGravity = EZPlayerVideoGravity(rawValue: (params["videoGravity"] as? String) ?? "aspect")
            self.player!.videoGravity = EZPlayerVideoGravity(rawValue: (params["videoGravity"] as? String) ?? "aspect") ?? .aspect
            self.player!.fullScreenMode = EZPlayerController.toEZPlayerFullScreenMode( (params["fullScreenMode"] as? String) ?? "landscape")
            self.player!.floatMode = EZPlayerController.toEZPlayerFloatMode( (params["floatMode"] as? String) ?? "auto")
            
            
            self.player!.backButtonBlock = { fromDisplayMode in
                if fromDisplayMode == .embedded {
                    self.stop()
                }else if fromDisplayMode == .fullscreen {
                    
                }else if fromDisplayMode == .float {
                    self.stop()
                }
            }
        }
    }
    
    private func releasePlayerResource() {
        if self.player != nil {
            self.removeObservers()
            self.player = nil
        }
    }
}

extension EZPlayerController {
    open func addObservers(){
        self.removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerHeartbeat(_:)), name: NSNotification.Name.EZPlayerHeartbeat, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlaybackTimeDidChange(_:)), name: NSNotification.Name.EZPlayerPlaybackTimeDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerStatusDidChange(_:)), name: NSNotification.Name.EZPlayerStatusDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlaybackDidFinish(_:)), name: NSNotification.Name.EZPlayerPlaybackDidFinish, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerLoadingDidChange(_:)), name: NSNotification.Name.EZPlayerLoadingDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerControlsHiddenDidChange(_:)), name: NSNotification.Name.EZPlayerControlsHiddenDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDisplayModeDidChange(_:)), name: NSNotification.Name.EZPlayerDisplayModeDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDisplayModeChangedWillAppear(_:)), name: NSNotification.Name.EZPlayerDisplayModeChangedWillAppear, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDisplayModeChangedDidAppear(_:)), name: NSNotification.Name.EZPlayerDisplayModeChangedDidAppear, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerTapGestureRecognizer(_:)), name: NSNotification.Name.EZPlayerTapGestureRecognizer, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidPersistContentKey(_:)), name: NSNotification.Name.EZPlayerDidPersistContentKey, object: nil)
        
        //pip
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPControllerWillStart(_:)), name: NSNotification.Name.EZPlayerPIPControllerWillStart, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPControllerDidStart(_:)), name: NSNotification.Name.EZPlayerPIPControllerDidStart, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPFailedToStart(_:)), name: NSNotification.Name.EZPlayerPIPFailedToStart, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPControllerWillEnd(_:)), name: NSNotification.Name.EZPlayerPIPControllerWillEnd, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPControllerDidEnd(_:)), name: NSNotification.Name.EZPlayerPIPControllerDidEnd, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPIPRestoreUserInterfaceForStop(_:)), name: NSNotification.Name.EZPlayerPIPRestoreUserInterfaceForStop, object: nil)
        
        
        
    }
    
    open func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc  func playerHeartbeat(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        var playerInfo = [String:Any]()
        if let isLive = player.isLive {
            playerInfo["isLive"] = isLive
        }
        if let duration = player.duration {
            playerInfo["duration"] = duration.isNaN ? -1 : duration  //maybe nan
        }
        if let currentTime = player.currentTime {
            playerInfo["currentTime"] = currentTime
        }
        
        playerInfo["isM3U8"] = player.isM3U8
        playerInfo["rate"] = player.rate.isNaN ? 0 : player.rate //maybe nan
        playerInfo["systemVolume"] = player.systemVolume
        playerInfo["state"] = self.stateName(state: player.state)
        
        self.channel.invokeMethod(NSNotification.Name.EZPlayerHeartbeat.rawValue, arguments: playerInfo) { (result) in
            
        };
    }
    
    @objc  func playerPlaybackTimeDidChange(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPlaybackTimeDidChange.rawValue, arguments: notifiaction.userInfo) { (result) in
        };
    }
    
    @objc  func playerStatusDidChange(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        let newState = self.stateName(state: notifiaction.userInfo![Notification.Key.EZPlayerNewStateKey] as! EZPlayerState)
        let oldState = self.stateName(state: notifiaction.userInfo![Notification.Key.EZPlayerOldStateKey] as! EZPlayerState)
        self.channel.invokeMethod(NSNotification.Name.EZPlayerStatusDidChange.rawValue, arguments: ["newState":newState,"oldState":oldState]) { (result) in
        };
    }
    
    @objc  func playerPlaybackDidFinish(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        let reason = self.finishReason(finishReason: notifiaction.userInfo![Notification.Key.EZPlayerPlaybackDidFinishReasonKey] as! EZPlayerPlaybackDidFinishReason)
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPlaybackDidFinish.rawValue, arguments: ["playerPlaybackDidFinish":reason]) { (result) in
        };
    }
    
    @objc  func playerLoadingDidChange(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerLoadingDidChange.rawValue, arguments: notifiaction.userInfo) { (result) in
        };
    }
    
    @objc  func playerControlsHiddenDidChange(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerControlsHiddenDidChange.rawValue, arguments: notifiaction.userInfo) { (result) in
        };
    }
    
    @objc  func playerDisplayModeDidChange(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        let displayMode = self.displayModeName(displayMode:player.displayMode)
        self.channel.invokeMethod(NSNotification.Name.EZPlayerDisplayModeDidChange.rawValue, arguments: ["displayMode":displayMode]) { (result) in
        };
    }
    
    @objc  func playerDisplayModeChangedWillAppear(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerDisplayModeChangedWillAppear.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerDisplayModeChangedDidAppear(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerDisplayModeChangedDidAppear.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerTapGestureRecognizer(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerTapGestureRecognizer.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerDidPersistContentKey(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerDidPersistContentKey.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPControllerWillStart(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPControllerWillStart.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPControllerDidStart(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPControllerDidStart.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPFailedToStart(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPFailedToStart.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPControllerWillEnd(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPControllerWillEnd.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPControllerDidEnd(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPControllerDidEnd.rawValue, arguments: nil) { (result) in
        };
    }
    
    @objc  func playerPIPRestoreUserInterfaceForStop(_ notifiaction: Notification) {
        guard let player = notifiaction.object as? EZPlayer  , player == self.player else{
            return
        }
        self.channel.invokeMethod(NSNotification.Name.EZPlayerPIPRestoreUserInterfaceForStop.rawValue, arguments: nil) { (result) in
        };
    }
    
    private func stateName(state: EZPlayerState) -> String{
        var stateName = ""
        switch (state) {
        case .unknown: stateName = "unknown"
        case .readyToPlay: stateName = "readyToPlay"
        case .buffering: stateName = "buffering"
        case .bufferFinished: stateName = "bufferFinished"
        case .playing: stateName = "playing"
        case .seekingForward: stateName = "seekingForward"
        case .seekingBackward: stateName = "seekingBackward"
        case .pause: stateName = "pause"
        case .stopped: stateName = "stopped"
        case .error(let type):
            switch (type){
            case .invalidContentURL: stateName = "error.invalidContentURL"
            case .playerFail: stateName = "error.playerFail"
            }
        }
        return stateName
    }
    
    private func displayModeName(displayMode: EZPlayerDisplayMode) -> String{
        var displayModeName = ""
        switch (displayMode) {
        case .none: displayModeName = "none"
        case .embedded: displayModeName = "embedded"
        case .fullscreen: displayModeName = "fullscreen"
        case .float: displayModeName = "float"
        }
        return displayModeName
    }
    
    
    private func finishReason(finishReason: EZPlayerPlaybackDidFinishReason) -> String{
        var reason = ""
        switch (finishReason) {
        case .playbackEndTime: reason = "playbackEndTime"
        case .playbackError: reason = "playbackError"
        case .stopByUser: reason = "stopByUser"
        }
        return reason
    }
}

