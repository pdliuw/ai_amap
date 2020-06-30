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

  AiAMapLocationPlatformWidgetController _locationController;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AiAMapHelper.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
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
              ),
            ),
            MaterialButton(
              onPressed: () {
                _locationController = AiAMapLocationPlatformWidgetController(
                  locationResultTest: (String info, bool isSuccess) {
                    setState(() {
                      _locationInfo = info;
                    });
                  },
                );
                _locationController..startLocation();
              },
              child: Text("开始定位"),
            ),
            MaterialButton(
              onPressed: () {
                _locationController.stopLocation();
              },
              child: Text("停止定位"),
            ),
            Expanded(
              child: AiAMapLocationPlatformWidget(
                onPlatformViewCreatedCallback: (int id) {
                  setState(() {
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
