import 'package:ai_amap_example/app_location_address_widget.dart';
import 'package:flutter/material.dart';

///
/// MapLocationWidgetPage
class MapLocationWidgetPage extends StatefulWidget {
  @override
  _MapLocationWidgetPageState createState() => _MapLocationWidgetPageState();
}

class _MapLocationWidgetPageState extends State<MapLocationWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地图组件"),
      ),
      body: AppAMapLocationAddressWidget.defaultStyle(),
    );
  }
}
