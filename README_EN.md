# ai_amap

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_amap/blob/master/README_EN.md)|[中文文档](https://github.com/pdliuw/ai_amap)|
|:-|:-|

## Effect

|iOS-map|Android-map|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_amap/blob/master/example/gif/ai_amap_ios.gif)|![android](https://github.com/pdliuw/ai_amap/blob/master/example/gif/ai_amap_android.gif)|
|:-|:-|

|web-map|
|:-|
|![web](https://github.com/pdliuw/ai_amap/blob/master/example/gif/ai_amap_web.gif)|
|:-|

## 1.安装

使用当前包作为依赖库

### 1. 依赖此库

在文件 'pubspec.yaml' 中添加

[![pub package](https://img.shields.io/pub/v/ai_amap.svg)](https://pub.dev/packages/ai_amap)

```

dependencies:

  ai_amap: ^version

```

或者以下方式依赖

```
dependencies:

  # ai_amap package.
  ai_amap:
    git:
      url: https://github.com/pdliuw/ai_amap.git

```

### 2. 安装此库

你可以通过下面的命令行来安装此库

```

$ flutter pub get


```

你也可以通过项目开发工具通过可视化操作来执行上述步骤

### 3. 导入此库

现在，在你的Dart编辑代码中，你可以使用：

```

import 'package:ai_amap/ai_amap.dart';

```

## 2.使用

使用'地图'需要动态申请权限，动态权限推荐：[permission_handler](https://github.com/Baseflow/flutter-permission-handler)

配置权限

<details>
<summary>Android</summary>

```

    <!--
    地图SDK（包含其搜索功能）需要的基础权限
    -->

    <!--允许程序打开网络套接字-->
    <uses-permission android:name="android.permission.INTERNET" />
    <!--允许程序设置内置sd卡的写权限-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <!--允许程序获取网络状态-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!--允许程序访问WiFi网络信息-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <!--允许程序读写手机状态和身份-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <!--允许程序访问CellID或WiFi热点来获取粗略的位置-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <!--
    地图定位需要的权限
    -->

    <!--用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <!--用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <!--用于获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <!--用于访问wifi网络信息，wifi信息会用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <!--用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
    <!--用于访问网络，网络定位需要上网-->
    <uses-permission android:name="android.permission.INTERNET"/>
    <!--用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
    <!--用于写入缓存数据到扩展存储卡-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <!--用于申请调用A-GPS模块-->
    <uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"/>

    <!--
    导航所需权限
    -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />


    <application>
    
    ...    

        <meta-data
            android:name="com.amap.api.v2.apikey"
            android:value="${apiKey}" />
        <!--
        https://lbs.amap.com/api/android-location-sdk/guide/android-location/getlocation
        (请在application标签中声明service组件,每个app拥有自己单独的定位service。)
        -->
        <service android:name="com.amap.api.location.APSService"></service>

        <!--
        地图导航组件
        -->
        <activity android:name="com.amap.api.navi.AmapRouteActivity"
            android:theme="@android:style/Theme.NoTitleBar"
            android:configChanges="orientation|keyboardHidden|screenSize" />

    </application>

```

</details>

<details>
<summary>iOS</summary>


```

	<key>NSFileProviderPresenceUsageDescription</key>
	<string>使用时允许访问文件</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>始终允许定位(提高后台定位准确率)</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>使用时始终允许定位</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>使用时允许定位</string>


```

** 为提高iOS定位成功率，请打开-->'Background Modes' --> 勾选☑ ️'Location Updates' **

iOS支持PlatformView配置：

```
	
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    
```
</details>

<details>
<summary>web</summary>


```
    
    <script src="https://webapi.amap.com/loader.js" type="text/javascript"></script>
    
    
```

</details>


### 1.使用'地图'的地方中：

* 完善的封装组件请参阅：[AppLocationAddressWidget](https://github.com/pdliuw/ai_amap/blob/master/example/lib/app_location_address_widget.dart)
* 相关权限的交互请参阅：[main.dart](https://github.com/pdliuw/ai_amap/blob/master/example/lib/main.dart)

* 1、使用地图Widget

```
    //map widget
    _aMapWidget = AiAMapLocationPlatformWidget(
      platformWidgetController: _locationController,
    );

```

* 2、使用地图Controller

```

    _locationController = AiAMapLocationPlatformWidgetController(
      locationResultCallback:
          (AiAMapLocationResult locationResult, bool isSuccess) {
        setState(() {
          _currentState = "定位:$isSuccess";
        });

        if (locationResult.haveAddress()) {
          _locationController.stopLocation();

          setState(() {
            if (widget._locationResultCallback != null) {
              widget._locationResultCallback(locationResult, isSuccess);
            }
            _locationAddress = locationResult.address;
          });

        }
      },
      platformViewCreatedCallback: (int id) {
        setState(() {
          //1、ApiKey
          AiAMapLocationPlatformWidgetController.setApiKey(
              apiKey: "$_yourPrimaryKey");
          //2、初始化定位服务
          _locationController..recreateLocationService();
          _locationController.startLocation();
          setState(() {
            _currentState = "开始定位";
          });
        });
      },

```

* 地图模块拿来即用：[AppLocationAddressWidget](https://github.com/pdliuw/ai_amap/blob/master/example/lib/app_location_address_widget.dart)
* 相关权限的交互请参阅：[main.dart](https://github.com/pdliuw/ai_amap/blob/master/example/lib/main.dart)

## LICENSE

    BSD 3-Clause License
    
    Copyright (c) 2020, pdliuw
    All rights reserved.