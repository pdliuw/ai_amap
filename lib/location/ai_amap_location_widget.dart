import 'package:ai_amap/global_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef LocationResultCallback = Function(
    AiAMapLocationResult aiAMapLocationResult, bool locationSuccess);

///
/// AiAMapLocationPlatformWidget
// ignore: must_be_immutable
class AiAMapLocationPlatformWidget extends StatefulWidget {
  ///
  /// AiAMapLocationPlatformWidget controller.
  AiAMapLocationPlatformWidgetController _platformWidgetController;

  ///
  /// AiAMapLocationPlatformWidget
  AiAMapLocationPlatformWidget({
    @required AiAMapLocationPlatformWidgetController platformWidgetController,
  }) {
    //assert
    assert(platformWidgetController != null);

    //Controller
    _platformWidgetController = platformWidgetController;
  }

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<AiAMapLocationPlatformWidget> {
  @override
  Widget build(BuildContext context) {
    return _getMapView();
  }

  Widget _getMapView() {
    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return AndroidView(
        viewType: GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW,
        onPlatformViewCreated:
            widget._platformWidgetController.platformViewCreatedCallback,
      );
    } else if (platform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW,
        onPlatformViewCreated:
            widget._platformWidgetController.platformViewCreatedCallback,
      );
    } else {
      return Container(
        child: Text("Unsupported platform"),
      );
    }
  }
}

///
/// AiAMapLocationPlatformWidgetController
class AiAMapLocationPlatformWidgetController {
  ///
  /// MethodChannel
  static const MethodChannel _methodChannel =
      MethodChannel(GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION_PLATFORM_VIEW);

  ///
  /// PlatformViewCreatedCallback
  PlatformViewCreatedCallback _platformViewCreatedCallback;

  LocationResultCallback _locationCallback;

  ///
  /// AiAMapLocationPlatformWidgetController
  AiAMapLocationPlatformWidgetController({
    @required PlatformViewCreatedCallback platformViewCreatedCallback,
    String test,
    LocationResultCallback locationResultCallback,
  }) {
    //assert
    assert(platformViewCreatedCallback != null);

    //platform view created callback
    _platformViewCreatedCallback = platformViewCreatedCallback;

    _locationCallback = locationResultCallback;

    //MethodChannel: 'android and ios' -> 'flutter'
    _methodChannel.setMethodCallHandler((MethodCall call) {
      String method = call.method;

      switch (method) {
        case "startLocationResult":
          var locationResult =
              AiAMapLocationResult.convertFromNative(arguments: call.arguments);

          _locationCallback(locationResult, true);
          break;
        default:
      }
      return null;
    });
  }

  get platformViewCreatedCallback => this._platformViewCreatedCallback;

  ///
  /// setApiKey
  /// Note: So far,just support ios,
  /// if you want to set android api key,
  /// please jump to 'AndroidManifest.xml' continue...
  static void setApiKey({@required String apiKey}) {
    _methodChannel.invokeMethod("setApiKey", {
      "apiKey": apiKey,
    });
  }

  ///
  /// recreateLocationService
  recreateLocationService() {
    _methodChannel.invokeMethod("recreateLocationService");
  }

  ///
  /// destroyLocationService
  destroyLocationService() {
    _methodChannel.invokeMethod("destroyLocationService");
  }

  ///
  /// startLocation
  startLocation() async {
    _methodChannel.invokeMethod("startLocation");
  }

  ///
  /// stopLocation
  stopLocation() {
    _methodChannel.invokeMethod("stopLocation");
  }

  ///
  /// showMyLocationIndicator
  showMyLocationIndicator() {
    _methodChannel.invokeMethod("showMyLocationIndicator");
  }

  hideMyLocationIndicator() {
    _methodChannel.invokeMethod("hideMyLocationIndicator");
  }
}

///
/// AiAMapLocationResult
/// 重要备注：
/// 高德地图在定位成功的情况，第一次定位90%会出现"有纬度、经度"单却没有"地址、省市区等信息"
/// @see [islo]
/// @see [haveAddress]
class AiAMapLocationResult {
  ///定位是否成功：（errorCode == 0）
  bool _isLocationSuccessful;

  ///获取错误码
  num _errorCode;

  ///获取错误信息
  String _errorInfo;

  ///(需要网络通畅，第一次有可能没有地址信息返回）
  String _address;

  ///获取当前定位结果来源，如网络定位结果，详见定位类型表
  num _locationType;

  ///获取纬度
  num _latitude;

  ///获取经度
  num _longitude;

  ///获取精度信息
  num _accuracy;

  ///区域编码
  String _adCode;

  ///获取海拔高度（单位：米）
  num _altitude;

  ///获取兴趣面名称
  String _aoiName;

  ///获取方向角（单位：度）,取值范围【0,360】，其中0度表示正北方向，90度表示正东，180度表示正南，270度表示正西
  num _bearing;

  ///获取城市名称
  String _city;

  ///获取城市编码
  String _cityCode;

  ///室内外置信度。室内：且置信度取值在[1 ～ 100]，值越大在在室内的可能性越大；室外：且置信度取值在[-100 ～ -1] ,值越小在在室内的可能性越大 无法识别室内外：置信度返回值为 0
  num _conScenario;

  ///获取坐标系类型。高德定位sdk会返回两种坐标系 AMapLocation.COORD_TYPE_GCJ02 -- GCJ02坐标系 AMapLocation.COORD_TYPE_WGS84 -- WGS84坐标系,国外定位时返回的是WGS84坐标系
  String _coordType;

  ///获取国家名称
  String _country;

  ///获取位置语义信息
  String _description;

  ///获取区的名称
  String _district;

  ///获取室内定位的楼层信息
  String _floor;

  ///获取卫星信号强度，仅在卫星定位时有效，值为 #GPS_ACCURACY_BAD，#GPS_ACCURACY_GOOD，#GPS_ACCURACY_UNKNOWN
  num _gpsAccuracyStatus;

  ///获取定位信息描述
  String _locationDetail;

  ///获取定位质量  advise message
  String _locationQualityReportAdviseMessage;

  ///获取兴趣点名称
  String _poiName;

  ///获取定位提供者
  String _provider;

  ///获取省的名称
  String _province;

  ///获取当前可用卫星数量，仅在卫星定位时有效
  num _satellites;

  ///获取当前速度（单位：米/秒）
  num _speed;

  ///获取街道名称
  String _street;

  ///获取门牌号
  String _streetNum;

  ///获取定位结果的可信度,只有在定位成功时才有意义.
  ///
  /// 非常可信 AMapLocation.TRUSTED_LEVEL_HIGH
  /// 可信度一般AMapLocation.TRUSTED_LEVEL_NORMAL
  /// 可信度较低 AMapLocation.TRUSTED_LEVEL_LOW
  /// 非常不可信 AMapLocation.TRUSTED_LEVEL_BAD
  num _trustedLevel;

  ///将定位结果转换为字符串
  String _toString;

  ///格式化后的时间
  String _time;

  ///Constructor
  AiAMapLocationResult({
    bool isLocationSuccessful,
    num errorCode,
    String errorInfo,
    String address,
    num locationType,
    num latitude,
    num longitude,
    num accuracy,
    String adCode,
    num altitude,
    String aoiName,
    num bearing,
    String city,
    String cityCode,
    num conScenario,
    String coordType,
    String country,
    String description,
    String district,
    String floor,
    num gpsAccuracyStatus,
    String locationDetail,
    String locationQualityReportAdviseMessage,
    String poiName,
    String provider,
    String province,
    num satellites,
    num speed,
    String street,
    String streetNum,
    num trustedLevel,
    String toString,
    String time,
  }) {
    _isLocationSuccessful = isLocationSuccessful;
    _errorCode = errorCode;
    _errorInfo = errorInfo;
    _address = address;
    _locationType = locationType;
    _latitude = latitude;
    _longitude = longitude;
    _accuracy = accuracy;

    _adCode = adCode;
    _altitude = altitude;
    _aoiName = aoiName;
    _bearing = bearing;
    _city = city;
    _cityCode = cityCode;
    _conScenario = conScenario;
    _coordType = coordType;
    _country = country;

    _description = description;

    _district = district;
    _floor = floor;
    _gpsAccuracyStatus = gpsAccuracyStatus;

    _locationDetail = locationDetail;

    _locationQualityReportAdviseMessage = locationQualityReportAdviseMessage;

    _poiName = poiName;
    _provider = provider;
    _province = province;

    _satellites = satellites;

    _speed = speed;

    _street = street;
    _streetNum = streetNum;

    _trustedLevel = trustedLevel;

    _toString = toString;
    _time = time;
  }

  AiAMapLocationResult.convertFromNative({
    @required dynamic arguments,
  }) {
    _isLocationSuccessful = arguments['isLocationSuccessful'];
    _errorCode = arguments['errorCode'];
    _errorInfo = arguments['errorInfo'];
    _address = arguments['address'];
    _locationType = arguments['locationType'];
    _latitude = arguments['latitude'];
    _longitude = arguments['longitude'];
    _accuracy = arguments['accuracy'];

    _adCode = arguments['adCode'];
    _altitude = arguments['altitude'];
    _aoiName = arguments['aoiName'];
    _bearing = arguments['bearing'];
    _city = arguments['city'];
    _cityCode = arguments['cityCode'];
    _conScenario = arguments['conScenario'];
    _coordType = arguments['coordType'];
    _country = arguments['country'];

    _description = arguments['description'];

    _district = arguments['district'];
    _floor = arguments['floor'];
    _gpsAccuracyStatus = arguments['gpsAccuracyStatus'];

    _locationDetail = arguments['locationDetail'];

    _locationQualityReportAdviseMessage =
        arguments['locationQualityReportAdviseMessage'];

    _poiName = arguments['poiName'];
    _provider = arguments['provider'];
    _province = arguments['province'];

    _satellites = arguments['satellites'];

    _speed = arguments['speed'];

    _street = arguments['street'];
    _streetNum = arguments['streetNum'];

    _trustedLevel = arguments['trustedLevel'];

    _toString = arguments['toString'];
    _time = arguments['time'];
  }

  String get locationString => _toString;

  ///
  /// location detail
  String get locationDetail {
    //locationDetail字段值不可靠
    //经过多次反复测验得出此结论：
    //locationDetail会在定位成功的情况下出现"一大堆的类似于'对象地址'无实际意义的值"，
    //因此，此字段/此值并不可靠
    return _locationDetail;
  }

  ///
  /// Location whether successful.
  /// @see [haveAddress]
  bool isLocationSuccessful() {
    return _isLocationSuccessful;
  }

  num get errorCode {
    return _errorCode;
  }

  String get errorInfo {
    return _errorInfo;
  }

  ///
  /// 高德地图在定位成功后，会出现：
  /// 有"纬度、经度"却没有"地址、省市区信息"的情况，
  /// 此情况非常严重，严重影响到实际业务
  /// [haveAddress]是为了确保在"定位成功"情况下，并且有"地址信息"。
  bool haveAddress() {
    return _isLocationSuccessful && _address.isNotEmpty;
  }

  String get address {
    return _address;
  }

  num get latitude {
    return _latitude;
  }

  num get longitude {
    return _longitude;
  }

  num get accuracy {
    return _accuracy;
  }

  String get adCode {
    return _adCode;
  }

  String get aoiName {
    return _aoiName;
  }

  String get city {
    return _city;
  }

  String get cityCode {
    return _cityCode;
  }

  String get country {
    return _country;
  }

  String get description {
    return _description;
  }

  String get district {
    return _district;
  }

  String get floor {
    return _floor;
  }

  String get poiName {
    return _poiName;
  }

  String get provider {
    return _provider;
  }

  String get province {
    return _province;
  }

  String get street {
    return _street;
  }

  String get streetNum {
    return _streetNum;
  }

  String get time {
    return _time;
  }

  @override
  String toString() {
    return '''
    AiAMapLocationResult
    {
      _isLocationSuccessful: $_isLocationSuccessful
      , _errorCode: $_errorCode
      , _errorInfo: $_errorInfo
      , _address: $_address
      , _locationType: $_locationType
      , _latitude: $_latitude
      , _longitude: $_longitude
      , _accuracy: $_accuracy
      , _adCode: $_adCode
      , _altitude: $_altitude
      , _aoiName: $_aoiName
      , _bearing: $_bearing
      , _city: $_city
      , _cityCode: $_cityCode
      , _conScenario: $_conScenario
      , _coordType: $_coordType
      , _country: $_country
      , _description: $_description
      , _district: $_district
      , _floor: $_floor
      , _gpsAccuracyStatus: $_gpsAccuracyStatus
      , _locationDetail: $_locationDetail
      , _locationQualityReportAdviseMessage: $_locationQualityReportAdviseMessage
      , _poiName: $_poiName
      , _provider: $_provider
      , _province: $_province
      , _satellites: $_satellites
      , _speed: $_speed
      , _street: $_street
      , _streetNum: $_streetNum
      , _trustedLevel: $_trustedLevel
      , _time: $_time
    }
    ''';
  }
}
