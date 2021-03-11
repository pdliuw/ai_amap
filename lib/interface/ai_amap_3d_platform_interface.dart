import 'package:flutter/material.dart';
import 'ai_amap_platform_interface.dart';

///
/// AiAMap3DPlatformInterface
abstract class AiAMap3DPlatformInterface extends ChangeNotifier
    with AiAMapPlatformInterface {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static AiAMap3DPlatformInterface _instance;

  /// The default instance of [AiBarcodeScannerPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBarcodeScannerPlatform] when they
  /// register themselves.
  ///
  static AiAMap3DPlatformInterface get instance => _instance;

  ///
  /// Instance update
  static set instance(AiAMap3DPlatformInterface instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}

  /// Returns a widget displaying.
  Widget buildPlatformView(BuildContext context) {
    throw UnimplementedError('buildPlatformView() has not been implemented.');
  }

  ///
  /// PlatformView created of widget
  onPlatformViewCreatedCallback(int id) {
    notifyListeners();
  }
}
