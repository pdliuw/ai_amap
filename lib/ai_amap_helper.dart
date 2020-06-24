part of 'ai_amap.dart';

class AiAMapHelper {
  ///
  static const MethodChannel AI_A_MAP_CHANNEL = const MethodChannel('ai_amap');

  static startLocation() {
    AI_A_MAP_CHANNEL.invokeMethod(
      "startLocation",
    );
  }

  static stopLocation() {
    AI_A_MAP_CHANNEL.invokeMethod(
      "stopLocation",
    );
  }

  static String get platformVersion => "version";
}
