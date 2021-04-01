import 'package:ai_amap/ai_amap.dart';
import 'package:ai_amap_example/global_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// MapLocationPage
class MapLocationPage extends StatefulWidget {
  @override
  _MapLocationPageState createState() => _MapLocationPageState();
}

class _MapLocationPageState extends State<MapLocationPage> {
  static const String LOCATION_TIP_DEFAULT =
      "定位中....(为保证正常使用定位、地理围栏、导航等功能，请允许应用可以'始终'访问位置信息)";
  AiAMapLocationController _locationController;

  String _locationAddress = "";

  ///
  /// startLocation
  bool _isLocation = false;

  @override
  void initState() {
    super.initState();

    _locationController = AiAMapLocationController(
      locationResultCallback: (result, successful) {
        if (result.haveAddress()) {
          _stopLocation();
          setState(() {
            _locationAddress = result.address;
          });
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //1、ApiKey
      AiAMapLocationController.setApiKey(
          apiKey: "${GlobalConfig.AMAP_KEY_iOS}");
      _startLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform targetPlatform = Theme.of(context).platform;
    bool mobile = targetPlatform == TargetPlatform.android ||
        targetPlatform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text("定位服务"),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(
                left: mobile ? 10 : 100,
                top: mobile ? 10 : 100,
                right: 50,
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(0),
                    tooltip: "重新定位",
                    onPressed: () {
                      _locationController.startLocation();
                    },
                  ),
                  Expanded(
                    child: Text(
                      "${_locationAddress.isEmpty ? LOCATION_TIP_DEFAULT : _locationAddress}",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.my_location,
                  ),
                  onPressed: () {
                    if (_isLocation) {
                      _stopLocation();
                    } else {
                      _startLocation();
                    }
                    setState(() {});
                  },
                  label: Text("${_isLocation ? "定位中......" : "定位"}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startLocation() {
    _locationController.startLocation();
    setState(() {
      _isLocation = true;
    });
  }

  void _stopLocation() {
    _locationController.stopLocation();
    setState(() {
      _isLocation = false;
    });
  }
}
