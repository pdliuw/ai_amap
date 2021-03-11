import 'dart:html';

import 'package:ai_amap/interface/ai_amap_3d_platform_interface.dart';
import 'package:ai_amap/interface/ai_amap_platform_interface.dart';
import 'package:ai_amap/web/amap_2d_view.dart';
import 'package:ai_amap/web/amapjs.dart';
import 'package:ai_amap/web/loaderjs.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:js/js_util.dart' as js_util;

/// 加载的插件
final List<String> plugins = <String>[
  'AMap.Geolocation',
  'AMap.PlaceSearch',
  'AMap.Scale',
  'AMap.ToolBar'
];

///
/// 在'高德地图'申请的'key'
final String webKey = "4e479545913a3a180b3cffc267dad646";

///
/// AiAMapWebPlugin
class AiAMapWebPlugin {
  /// Registers this class as the default instance of [AiBarcodeWebPlugin].
  static void registerWith(Registrar registrar) {
    // Registers plugins
    AiAMap3DWebPlugin.registerWith(registrar);
  }
}

///
/// AiAMap3DWebPlugin
class AiAMap3DWebPlugin extends AiAMap3DPlatformInterface {
  ///
  /// DivElement
  static DivElement _divElement;

  ///
  /// Registers this class as the default instance of [AiAMap3DWebPlugin].
  static void registerWith(Registrar registrar) {
    AiAMap3DPlatformInterface.instance = AiAMap3DWebPlugin();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(AiAMapPlatformInterface.viewTypeId, (int viewId) {
      _divElement = DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.margin = '0';

      return _divElement;
    });
  }

  static _onPlatformViewCreated() {
    var promise = load(LoaderOptions(
      key: webKey,
      version: '1.4.15', // 2.0需要修改GeolocationOptions属性
      plugins: plugins,
    ));

    js_util.promiseToFuture(promise).then((value) {
      MapOptions _mapOptions = MapOptions(
        zoom: 11,
        resizeEnable: true,
      );

      /// 无法使用id https://github.com/flutter/flutter/issues/40080
      AMap _aMap = AMap(_divElement, _mapOptions);

      /// 加载插件
      _aMap.plugin(plugins, js.allowInterop(() {
        _aMap.addControl(Scale());
        _aMap.addControl(ToolBar());

//        final AMap2DWebController controller =
//            AMap2DWebController(_aMap, widget);
//        if (widget.onAMap2DViewCreated != null) {
//          widget.onAMap2DViewCreated!(controller);
//        }
      }));
    }, onError: (dynamic e) {
      print('初始化错误：$e');
    });
  }

//  @override
//  Widget buildPlatformView(BuildContext context) {
//    ///
//    /// schedulerBinding
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      /// platform view created callback.
//      _onPlatformViewCreated();
//    });
//    return HtmlElementView(
//      key: UniqueKey(),
//      viewType: AiAMapPlatformInterface.viewTypeId,
//    );
//  }
  @override
  Widget buildPlatformView(BuildContext context) {
    return AMap2DView(
      webKey: webKey,
    );
  }
}
