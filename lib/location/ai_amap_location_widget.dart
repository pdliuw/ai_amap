import 'package:ai_amap/global_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef LocationResultTest = Function(
    String locationDescription, bool locationSuccess);

///
/// AiAMapLocationPlatformWidget
class AiAMapLocationPlatformWidget extends StatefulWidget {
  PlatformViewCreatedCallback _onPlatformViewCreated;

  AiAMapLocationPlatformWidget({
    PlatformViewCreatedCallback onPlatformViewCreatedCallback,
  }) {
    this._onPlatformViewCreated = onPlatformViewCreatedCallback;
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
        onPlatformViewCreated: widget._onPlatformViewCreated,
      );
    } else if (platform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW,
        onPlatformViewCreated: widget._onPlatformViewCreated,
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
  MethodChannel _methodChannel =
      MethodChannel(GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION_PLATFORM_VIEW);

  LocationResultTest _locationTest;

  AiAMapLocationPlatformWidgetController(
      {String test, LocationResultTest locationResultTest}) {
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
