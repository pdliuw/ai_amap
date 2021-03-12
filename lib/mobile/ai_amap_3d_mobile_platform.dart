import 'package:ai_amap_platform_interface/ai_amap_platform_interface.dart';
import 'package:flutter/material.dart';

///
/// AiAMap3DMobilePlatform
class AiAMap3DMobilePlatform extends AiAMap3DPlatformInterface {
  @override
  Widget buildPlatformView(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return AndroidView(
        viewType: AiAMapPlatformInterface.viewTypeId,
        onPlatformViewCreated: (int viewId) {
          onPlatformViewCreatedCallback(viewId);
        },
      );
    } else if (platform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: AiAMapPlatformInterface.viewTypeId,
        onPlatformViewCreated: (int viewId) {
          onPlatformViewCreatedCallback(viewId);
        },
      );
    } else {
      return Container(
        child: Text("Unsupported platform"),
      );
    }
  }
}
