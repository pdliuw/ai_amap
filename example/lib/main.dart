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

  String _currentState = "";

  @override
  void initState() {
    super.initState();

    _locationController = AiAMapLocationPlatformWidgetController(
      locationResultTest:
          (AiAMapLocationResult locationResult, bool isSuccess) {
        setState(() {
          _locationInfo = locationResult.address;
        });
      },
      platformViewCreatedCallback: (int id) {
        setState(() {
          //1、ApiKey
          AiAMapLocationPlatformWidgetController.setApiKey(
              apiKey: "c3e5689ab4b37aa36b56be87c5aa10b5");
          //2、初始化定位服务
          _locationController..recreateLocationService();

          _onPlatformViewCreated = true;
          _locationInfo = "创建完成";
        });
        ;
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
                title: Text("hello"),
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
            Text("状态：$_currentState ${_locationInfo}"),
            FlatButton(
                onPressed: () async {
                  if (await Permission.locationAlways.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    _currentState = "授权成功";
                  } else {
                    _currentState = "授权失败";
                  }

                  setState(() {});
                },
                child: Text("申请权限")),
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
