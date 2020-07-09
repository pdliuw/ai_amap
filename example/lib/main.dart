import 'package:ai_amap/ai_amap.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _locationInfo = '--';

  bool _enableMyLocation = false;
  bool _onPlatformViewCreated = false;

  AiAMapLocationPlatformWidgetController _locationController;

  AiAMapLocationPlatformWidget _aMapWidget;

  @override
  void initState() {
    super.initState();

    _locationController = AiAMapLocationPlatformWidgetController(
      locationResultCallback:
          (AiAMapLocationResult locationResult, bool isSuccess) {
        setState(() {
          print("${locationResult.locationString}");
          _locationInfo = "${locationResult.country}";
        });
      },
      geoFenceFinishResultCallback: (GeoFenceFinishedResult result) {
        print("添加地理围栏：\n${result.toString()}");
      },
      geoFenceReceiveResultCallback: (GeoFenceReceiveResult result) {
        print("触发地理围栏：\n${result.toString()}");
      },
      platformViewCreatedCallback: (int id) {
        setState(() {
          _onPlatformViewCreated = true;
          requestPermission();
        });
      },
    );

    _aMapWidget = AiAMapLocationPlatformWidget(
      platformWidgetController: _locationController,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _locationController.stopLocation();
    _locationController.destroyLocationService();
  }

  requestPermission() async {
    if (await Permission.locationAlways.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      //1、ApiKey
      AiAMapLocationPlatformWidgetController.setApiKey(
          apiKey: "c3e5689ab4b37aa36b56be87c5aa10b5");
      //2、初始化定位服务
      _locationController..recreateLocationService();
      _locationController.startLocation();

      _locationController.recreateGeoFenceClient();
      //默认设置：北京锋创科技园的经纬度地址
      _locationController.addGeoFence(
          latitude: 39.780718,
          longitude: 116.56848,
          radius: 500,
          customId: "定制化的业务自定义ID");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("显示我的位置"),
                trailing: _onPlatformViewCreated
                    ? Switch(
                        value: _enableMyLocation,
                        onChanged: (enable) {
                          setState(() {
                            _enableMyLocation = enable;
                            if (enable) {
                              _locationController.showMyLocationIndicator();
                            } else {
                              _locationController.hideMyLocationIndicator();
                            }
                          });
                        })
                    : Text("Hello"),
              ),
            ),
            Text("${_locationInfo ?? '定位中....'}"),
            FlatButton(
              onPressed: () {
                _locationController.startLocation();
              },
              child: Text("开始定位"),
            ),
            FlatButton(
              onPressed: () {
                _locationController.stopLocation();
              },
              child: Text("停止定位"),
            ),
            Expanded(
              child: _aMapWidget,
            ),
          ],
        ),
      ),
    );
  }
}
