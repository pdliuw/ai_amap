import 'package:ai_amap/ai_amap.dart';
import 'package:ai_amap_example/app_location_address_widget.dart';
import 'package:airoute/airoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map_main_select_widget.dart';

void main() {
  runApp(Airoute.createMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

///
/// 高德地图插件
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _requestPermissionIsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        child: _requestPermissionIsGranted
            ? MapMainSelectWidget.defaultStyle()
            : Center(
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _requestPermission();
                  },
                  child: Text("请求所需权限"),
                ),
              ),
      ),
    );
  }

  ///
  /// Request permission
  /// request permission before all of aMap operate
  _requestPermission() async {
    var platform = Theme.of(context).platform;
    if (TargetPlatform.android == platform) {
      _requestAndroidPermission();
    } else if (TargetPlatform.iOS == platform) {
      _requestIosPermission();
    } else {
      _requestOtherPlatformPermission();
    }
  }

  ///
  /// Request android needs permissions
  _requestAndroidPermission() async {
    if (await Permission.locationAlways.request().isGranted) {
      if (await Permission.storage.request().isGranted) {
        if (await Permission.phone.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          setState(() {
            _requestPermissionIsGranted = true;
          });
        }
      }
    }
  }

  ///
  /// Request ios needs permission
  _requestIosPermission() async {
    if (await Permission.locationAlways.request().isGranted) {
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        setState(() {
          _requestPermissionIsGranted = true;
        });
      }
    }
  }

  _requestOtherPlatformPermission() {
    _requestPermissionIsGranted = true;
  }
}
