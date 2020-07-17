import 'package:ai_amap/global_config.dart';
import 'package:ai_amap/location/geo_fence_finished_result.dart';
import 'package:ai_amap/location/geo_fence_receive_result.dart';
import 'package:ai_amap/location/info_window_confirm_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'location_result.dart';

typedef LocationResultCallback = Function(
    AiAMapLocationResult aiAMapLocationResult, bool locationSuccess);

typedef AddGeoFenceFinishResultCallback = Function(
    GeoFenceFinishedResult finishedResult);

typedef AddGeoFenceReceiveResultCallback = Function(
    GeoFenceReceiveResult receiveResult);

typedef InfoWindowReceiveResultCallback = Function(
    InfoWindowConfirmResult result);

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

  LocationResultCallback _locationCallback;
  AddGeoFenceFinishResultCallback _geoFenceFinishedCallback;
  AddGeoFenceReceiveResultCallback _geoFenceReceiveCallback;
  InfoWindowReceiveResultCallback _infoWindowReceiveResultCallback;

  ///
  /// AiAMapLocationPlatformWidgetController
  AiAMapLocationPlatformWidgetController({
    @required PlatformViewCreatedCallback platformViewCreatedCallback,
    String test,
    LocationResultCallback locationResultCallback,
    AddGeoFenceFinishResultCallback geoFenceFinishResultCallback,
    AddGeoFenceReceiveResultCallback geoFenceReceiveResultCallback,
    InfoWindowReceiveResultCallback infoWindowReceiveResultCallback,
  }) {
    //assert
    assert(platformViewCreatedCallback != null);

    //platform view created callback
    _platformViewCreatedCallback = platformViewCreatedCallback;

    _locationCallback = locationResultCallback;

    _geoFenceFinishedCallback = geoFenceFinishResultCallback;
    _geoFenceReceiveCallback = geoFenceReceiveResultCallback;
    _infoWindowReceiveResultCallback = infoWindowReceiveResultCallback;

    //MethodChannel: 'android and ios' -> 'flutter'
    _methodChannel.setMethodCallHandler((MethodCall call) {
      String method = call.method;

      switch (method) {
        case "startLocationResult":
          var locationResult =
              AiAMapLocationResult.convertFromNative(arguments: call.arguments);

          if (_locationCallback != null) {
            _locationCallback(locationResult, true);
          }
          break;

        case "addGeoFenceFinished":
          var geoFenceFinishedResult = GeoFenceFinishedResult.convertFromNative(
              arguments: call.arguments);
          if (_geoFenceFinishedCallback != null) {
            _geoFenceFinishedCallback(geoFenceFinishedResult);
          }
          break;

        case "startGeoFenceReceiverResult":
          var geoFenceReceiveResult = GeoFenceReceiveResult.convertFromNative(
              arguments: call.arguments);
          if (_geoFenceReceiveCallback != null) {
            _geoFenceReceiveCallback(geoFenceReceiveResult);
          }
          break;
        case "infoWindowConfirm":
          var infoWindowResult = InfoWindowConfirmResult.convertFromNative(
              arguments: call.arguments);
          if (_infoWindowReceiveResultCallback != null) {
            _infoWindowReceiveResultCallback(infoWindowResult);
          }
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
  /// Add marker on map
  /// title: marker title
  /// snippet: marker snippet/content
  addMarker({
    @required double latitude,
    @required double longitude,
    @required String title,
    @required String snippet,
  }) {
    _methodChannel.invokeMethod("addMarker", {
      "latitude": latitude,
      "longitude": longitude,
      "title": title,
      "snippet": snippet,
    });
  }

  ///
  /// Clear all overlay of map（marker，circle，polyline...),
  /// but myLocationOverlay（location overlay）exclude。
  clearAllOverlay({
    bool isKeepMyLocationOverlay = true,
  }) {
    _methodChannel.invokeMethod("clearAllOverlay", {
      "isKeepMyLocationOverlay": isKeepMyLocationOverlay,
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

  ///
  /// showMyLocationIndicator
  showMyLocationIndicator() {
    _methodChannel.invokeMethod("showMyLocationIndicator");
  }

  hideMyLocationIndicator() {
    _methodChannel.invokeMethod("hideMyLocationIndicator");
  }

  recreateGeoFenceClient() {
    _methodChannel.invokeMethod("recreateGeoFenceClient");
  }

  startNavigatorWidget() {
    _methodChannel.invokeMethod("startNavigatorWidget");
  }

  addGeoFence({
    @required double latitude,
    @required double longitude,
    @required double radius,
    @required String customId,
  }) {
    _methodChannel.invokeMethod("addGeoFence", {
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius,
      "customId": customId,
    });
  }

  clearAllGeoFence() {
    _methodChannel.invokeMethod("clearAllGeoFence");
  }

  destroyGeoFenceClient() {
    _methodChannel.invokeMethod("destroyGeoFenceClient");
  }
}
