import 'dart:async';

import 'package:flutter/services.dart';

class AiAmap {
  static const MethodChannel _channel =
      const MethodChannel('ai_amap');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
