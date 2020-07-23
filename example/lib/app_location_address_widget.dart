import 'package:ai_amap/ai_amap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

///
/// AppAMapLocationAddressWidget
// ignore: must_be_immutable
class AppAMapLocationAddressWidget extends StatefulWidget {
  LocationResultCallback _locationResultTest;

  ///
  /// Default style
  AppAMapLocationAddressWidget.defaultStyle({
    AppAiAMapLocationType locationType = AppAiAMapLocationType.summary,
    LocationResultCallback locationResultCallback,
  }) {
    //assert
    assert(locationType != null);

    //
    _locationResultTest = locationResultCallback;
  }
  @override
  State<StatefulWidget> createState() {
    return _locationState();
  }
}

///
/// _locationState
class _locationState extends State<AppAMapLocationAddressWidget> {
  static const String LOCATION_TIP_DEFAULT =
      "定位中....(为保证正常使用定位、地理围栏、导航等功能，请允许应用可以'始终'访问位置信息)";
  AiAMapLocationPlatformWidgetController _locationController;

  AiAMapLocationPlatformWidget _aMapWidget;

  String _locationAddress = LOCATION_TIP_DEFAULT;

  static const String _yourPrimaryKey = "c3e5689ab4b37aa36b56be87c5aa10b5";

  bool _showMyLocation = false;
  String _currentState;
  @override
  void initState() {
    super.initState();

    _locationController = AiAMapLocationPlatformWidgetController(
      locationResultCallback:
          (AiAMapLocationResult locationResult, bool isSuccess) {
        setState(() {
          _currentState = "定位:$isSuccess";
        });

        if (locationResult.haveAddress()) {
          _locationController.stopLocation();

          setState(() {
            if (widget._locationResultTest != null) {
              widget._locationResultTest(locationResult, isSuccess);
            }
            _locationAddress = locationResult.address;
          });

          //添加标记
          _locationController.clearAllOverlay(isKeepMyLocationOverlay: true);

          _locationController.addMarker(
            latitude: 39.909187,
            longitude: 116.397451,
            title: "天安门",
            snippet: "天安门广场",
          );
        }
      },
      platformViewCreatedCallback: (int id) {
        setState(() {
          //1、ApiKey
          AiAMapLocationPlatformWidgetController.setApiKey(
              apiKey: "$_yourPrimaryKey");
          //2、初始化定位服务
          _locationController..recreateLocationService();
          // Either the permission was already granted before or the user just granted it.
          //"授权成功";
          _locationController.startLocation();
          setState(() {
            _currentState = "开始定位";
          });
        });
      },
      infoWindowReceiveResultCallback: (InfoWindowConfirmResult result) {
        _locationController.startNavigatorWidget();
      },
    );
    //map widget
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
    return Stack(
      children: <Widget>[
        _aMapWidget,
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.only(
              left: 10,
              top: 10,
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
          alignment: Alignment.centerRight,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  color: Colors.white,
                ),
                child: IconButton(
                  enableFeedback: true,
                  icon: Icon(
                    Icons.my_location,
                    color: _showMyLocation
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _showMyLocation = !_showMyLocation;
                    });
                    _showMyLocation
                        ? _locationController.showMyLocationIndicator()
                        : _locationController.hideMyLocationIndicator();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    FontAwesome.location_arrow,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    _locationController?.startNavigatorWidget();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

///
/// AppAiAMapLocationType
enum AppAiAMapLocationType {
  summary,
  detail,
}
