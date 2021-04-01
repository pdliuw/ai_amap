import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../global_config.dart';
import 'location_result.dart';

///
/// AiAMapLocationResultCallback
typedef AiAMapLocationResultCallback = Function(
    AiAMapLocationResult aiAMapLocationResult, bool locationSuccess);

///
/// AiAMapLocationController
class AiAMapLocationController {
  ///
  /// MethodChannel
  static const MethodChannel _methodChannel =
      MethodChannel(GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION);

  ///
  /// LocationResultCallback
  AiAMapLocationResultCallback _locationResultCallback;

  ///
  /// AiAMapLocationController
  AiAMapLocationController({
    AiAMapLocationResultCallback locationResultCallback,
  }) {
    _locationResultCallback = locationResultCallback;

    //MethodChannel: 'android and ios' -> 'flutter'
    _methodChannel.setMethodCallHandler((MethodCall call) {
      String method = call.method;

      switch (method) {
        case "startLocationResult":
          var locationResult =
              AiAMapLocationResult.convertFromNative(arguments: call.arguments);

          if (_locationResultCallback != null) {
            _locationResultCallback(locationResult, true);
          }
          break;

        default:
      }
      return null;
    });
  }

  ///
  /// setApiKey
  /// Note: So far,just support ios,
  /// if you want to set android api key,
  /// please jump to 'AndroidManifest.xml' continue...
  static void setApiKey({@required String apiKey}) {
    _methodChannel.invokeMethod("setApiKey", {
      "apiKey": apiKey,
    });
  }

  ///
  /// recreateLocationService
  recreateLocationService() {
    _methodChannel.invokeMethod("recreateLocationService");
  }

  ///
  /// destroyLocationService
  destroyLocationService() {
    _methodChannel.invokeMethod("destroyLocationService");
  }

  ///
  /// startLocation
  startLocation() async {
    _methodChannel.invokeMethod("startLocation");
  }

  ///
  /// stopLocation
  stopLocation() {
    _methodChannel.invokeMethod("stopLocation");
  }
}
