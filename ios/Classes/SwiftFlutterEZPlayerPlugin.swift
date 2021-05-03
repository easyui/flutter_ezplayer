import Flutter
import UIKit

public class SwiftFlutterEZPlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
//    let channel = FlutterMethodChannel(name: "flutter_ezplayer", binaryMessenger: registrar.messenger())
//    let instance = SwiftFlutterEZPlayerPlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar .register(EZPlayerFactory(message:registrar.messenger() ), withId: "plugins/flutter_ezplayer")
  }

//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    result("iOS " + UIDevice.current.systemVersion)
//  }
}
