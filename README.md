# ai_amap

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_amap/blob/master/README_EN.md)|[中文文档](https://github.com/pdliuw/ai_amap)|
|:-|:-|

## 注意：

内嵌高德地图导航组件时，首次启动app进入导航页面时，没有导航声音；请重启app后再次进入，才有导航声音

## Effect

|iOS-map|Android-map|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_amap/blob/master/example/gif/ai_amap_ios.gif)|![android](https://github.com/pdliuw/ai_amap/blob/master/example/gif/ai_amap_android.gif)|
|:-|:-|


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

Android权限配置:

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

iOS权限配置:


```

    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Location permission</string>


```

iOS支持PlatformView配置：

```
	
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    
```


### 1.使用'地图'的地方中：

* 1、使用地图

```
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: AiAMapPlatformWidget(),
                ),
              ],
            ),
          ),
        );
      }

```


## LICENSE

    BSD 3-Clause License
    
    Copyright (c) 2020, pdliuw
    All rights reserved.