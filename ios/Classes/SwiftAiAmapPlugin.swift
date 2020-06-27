import Flutter
import UIKit

public class SwiftAiAmapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ai_amap", binaryMessenger: registrar.messenger())
    let instance = SwiftAiAmapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    /* Register*/
    registrar.register(AiAMapPlatformViewFactory(flutterBinaryMessenger:registrar.messenger()), withId:"view_type_id_map_platform_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
