import 'package:ai_amap_example/map_location_page.dart';
import 'package:ai_amap_example/map_location_widget_page.dart';
import 'package:airoute/airoute.dart';
import 'package:flutter/material.dart';

///
/// MapMainSelectWidget
class MapMainSelectWidget extends StatefulWidget {
  MapMainSelectWidget.defaultStyle() {}
  @override
  _MapMainPageState createState() => _MapMainPageState();
}

class _MapMainPageState extends State<MapMainSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            onTap: () {
              Airoute.push(
                route: MaterialPageRoute(
                  builder: (context) {
                    return MapLocationPage();
                  },
                ),
              );
            },
            title: Text("定位服务"),
            leading: Icon(Icons.location_on),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Airoute.push(
                route: MaterialPageRoute(
                  builder: (context) {
                    return MapLocationWidgetPage();
                  },
                ),
              );
            },
            title: Text("定位组件"),
            leading: Icon(Icons.widgets),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ],
    );
  }
}
