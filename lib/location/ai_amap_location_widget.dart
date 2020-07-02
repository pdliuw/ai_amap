import 'package:ai_amap/global_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef LocationResultTest = Function(
    String locationDescription, bool locationSuccess);

///
/// AiAMapLocationPlatformWidget
// ignore: must_be_immutable
class AiAMapLocationPlatformWidget extends StatefulWidget {
  ///
  /// AiAMapLocationPlatformWidget controller.
  AiAMapLocationPlatformWidgetController _platformWidgetController;

  ///
  /// AiAMapLocationPlatformWidget
  AiAMapLocationPlatformWidget({
    @required AiAMapLocationPlatformWidgetController platformWidgetController,
  }) {
    //assert
    assert(platformWidgetController != null);

    //Controller
    _platformWidgetController = platformWidgetController;
  }

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<AiAMapLocationPlatformWidget> {
  @override
  Widget build(BuildContext context) {
    return _getMapView();
  }

  Widget _getMapView() {
    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return AndroidView(
        viewType: GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW,
        onPlatformViewCreated:
            widget._platformWidgetController.platformViewCreatedCallback,
      );
    } else if (platform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW,
        onPlatformViewCreated:
            widget._platformWidgetController.platformViewCreatedCallback,
      );
    } else {
      return Container(
        child: Text("Unsupported platform"),
      );
    }
  }
}

///
/// AiAMapLocationPlatformWidgetController
class AiAMapLocationPlatformWidgetController {
  ///
  /// MethodChannel
  static const MethodChannel _methodChannel =
      MethodChannel(GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION_PLATFORM_VIEW);

  ///
  /// PlatformViewCreatedCallback
  PlatformViewCreatedCallback _platformViewCreatedCallback;

  LocationResultTest _locationTest;

  ///
  /// AiAMapLocationPlatformWidgetController
  AiAMapLocationPlatformWidgetController({
    @required PlatformViewCreatedCallback platformViewCreatedCallback,
    String test,
    LocationResultTest locationResultTest,
  }) {
    //assert
    assert(platformViewCreatedCallback != null);

    //platform view created callback
    _platformViewCreatedCallback = platformViewCreatedCallback;

    _locationTest = locationResultTest;

    //MethodChannel: 'android and ios' -> 'flutter'
    _methodChannel.setMethodCallHandler((MethodCall call) {
      String method = call.method;

      switch (method) {
        case "startLocationResult":
          _locationTest("${call.arguments}", true);
          break;
        default:
      }
      return null;
    });
  }

  get platformViewCreatedCallback => this._platformViewCreatedCallback;

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
  startLocation() {
    _methodChannel.invokeMethod("startLocation");
  }

  ///
  /// stopLocation
  stopLocation() {
    _methodChannel.invokeMethod("stopLocation");
  }

  ///
  /// showMyLocationIndicator
  showMyLocationIndicator() {
    _methodChannel.invokeMethod("showMyLocationIndicator");
  }

  hideMyLocationIndicator() {
    _methodChannel.invokeMethod("hideMyLocationIndicator");
  }
}
