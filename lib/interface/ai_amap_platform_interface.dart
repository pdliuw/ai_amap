import 'package:flutter/services.dart';

import '../global_config.dart';

///
/// MethodChannel
const MethodChannel _methodChannel =
    MethodChannel(GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION_PLATFORM_VIEW);

///
/// view type id
const String _viewType = GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW;

///
/// platform interface
abstract class AiAMapPlatformInterface {
  ///
  /// method channel
  static MethodChannel get methodChannel => _methodChannel;

  ///
  /// view type id
  static String get viewTypeId => _viewType;
}
