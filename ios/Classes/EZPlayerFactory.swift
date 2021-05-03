//
//  EZPlayerFactory.swift
//  flutter_ezplayer
//
//  Created by Yangjun Zhu on 2020/10/29.
//
import Foundation
import Flutter

public class EZPlayerFactory: NSObject, FlutterPlatformViewFactory {
    private var message :FlutterBinaryMessenger!
    // MARK: - init
    public init(message: FlutterBinaryMessenger) {
        super.init()
        self.message = message
    }
    
    // MARK: - FlutterPlatformViewFactory protocol
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let view = EZPlayerController(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: self.message)
        return view
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return  FlutterStandardMessageCodec.sharedInstance()
    }
    
    
}
