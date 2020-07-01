import 'dart:async';

import 'package:ai_amap/ai_amap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();

    _locationController = AiAMapLocationPlatformWidgetController(
      locationResultTest: (String info, bool isSuccess) {
        setState(() {
          _locationInfo = info;
        });
      },
    )..recreateLocationService();
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
                title: Text("$_locationInfo"),
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
            FlatButton(
              onPressed: () {
                _locationController..startLocation();
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
              child: AiAMapLocationPlatformWidget(
                onPlatformViewCreatedCallback: (int id) {
                  setState(() {
                    _onPlatformViewCreated = true;
                    _locationInfo = "创建完成";
                  });
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
