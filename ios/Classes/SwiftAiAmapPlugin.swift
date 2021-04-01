import Flutter
import UIKit

public class SwiftAiAmapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ai_amap", binaryMessenger: registrar.messenger())
    let instance = SwiftAiAmapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    /* Register*/
    registrar.register(AiAMapPlatformViewFactory(flutterBinaryMessenger:registrar.messenger()), withId:AiAMapGlobalConfig.VIEW_TYPE_ID_MAP_PLATFORM_VIEW)
    registrar.register(AiAMapLocationPlatformViewFactory(flutterBinaryMessenger: registrar.messenger()), withId: AiAMapGlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW)
    AiAMapLocationService.init(flutterBinaryMessenger: registrar.messenger());
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
