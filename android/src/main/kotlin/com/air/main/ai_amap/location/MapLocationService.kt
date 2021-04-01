package com.air.main.ai_amap.location

import android.content.Context
import com.air.main.ai_amap.GlobalConfig
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * <p>
 * Created by air on 3/31/21.
 * </p>
 */
class MapLocationService(binaryMessenger: BinaryMessenger, context: Context?) : MethodChannel.MethodCallHandler {
    /** Context */
    private val mContext = context;

    /** MethodChannel:'flutter -> android' + 'android -> flutter' */
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger, GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION);

    /** Location client service */
    private var aMapLocationClient: AMapLocationClient = AMapLocationClient(mContext);

    /** Location Option */
    private var mLocationClientOption: AMapLocationClientOption = AMapLocationClientOption();

    init {
        //Method call handler
        methodChannel.setMethodCallHandler(this);
    }

    /** MethodChannel: 'flutter -> android' */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        //init location option
        initLocationOption();

        when (call.method) {
            "setApiKey" -> {
                val key: String? = call.argument("apiKey");
                setApiKey(key);
            }

            "recreateLocationService" -> {
                recreateLocationService()
            }
            "destroyLocationService" -> {
                destroyLocationService()
            }
            "startLocation" -> {
                startLocation()
            }
            "stopLocation" -> {
                stopLocation();
            }

            else -> {
                doNothing();
            }
        }
    }

    /** Init location option config information used by location */
    private fun initLocationOption() {
        mLocationClientOption.also {
            ////设置定位模式为高精度模式，Battery_Saving为低功耗模式，Device_Sensors是仅设备模式
            it.locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy;
            //设置定位间隔,单位毫秒,默认为2000ms
            it.interval = 2000;
            //控制是否返回速度值，当设置为true时会通过手机传感器获取速度,如果手机没有对应的传感器会返回0.0
            it.isSensorEnable = true;
        }
    }


    private fun setApiKey(key: String?) {
        //todo
    }


    /**
     * Start location
     * @see #[stopLocation]
     * */
    private fun startLocation() {

        //Location service already started,return
        //本地定位服务是否已经启动，用于用户检查服务是否已经启动
        if (!aMapLocationClient.isStarted) {
            //如果未启动定位服务，则重新创建定位对象
            recreateLocationService()
        }

        aMapLocationClient.apply {
            //设置定位参数
            setLocationOption(mLocationClientOption);
            //设置定位数据接收
            setLocationListener {
                if (it != null) {

                    val successful = it.errorCode == 0;

                    //测试代码
                    methodChannel.invokeMethod("startLocationResult", mutableMapOf(
                            Pair("isLocationSuccessful", successful),
                            Pair("errorCode", it.errorCode),//获取错误码
                            Pair("errorInfo", it.errorInfo),//获取错误信息
                            Pair("address", it.address),//(需要网络通畅，第一次有可能没有地址信息返回）
                            Pair("locationType", it.locationType),//获取当前定位结果来源，如网络定位结果，详见定位类型表
                            Pair("latitude", it.latitude),//获取纬度
                            Pair("longitude", it.longitude),//获取经度
                            Pair("accuracy", it.accuracy),//获取精度信息
                            Pair("adCode", it.adCode),//区域编码
                            Pair("altitude", it.altitude),//获取海拔高度（单位：米）
                            Pair("aoiName", it.aoiName),//获取兴趣面名称
                            Pair("bearing", it.bearing),//获取方向角（单位：度）,取值范围【0,360】，其中0度表示正北方向，90度表示正东，180度表示正南，270度表示正西
                            Pair("city", it.city),//获取城市名称
                            Pair("cityCode", it.cityCode),//获取城市编码
//                            Pair("conScenario", it.conScenario),//室内外置信度。室内：且置信度取值在[1 ～ 100]，值越大在在室内的可能性越大；室外：且置信度取值在[-100 ～ -1] ,值越小在在室内的可能性越大 无法识别室内外：置信度返回值为 0
                            Pair("coordType", it.coordType),//获取坐标系类型。高德定位sdk会返回两种坐标系 AMapLocation.COORD_TYPE_GCJ02 -- GCJ02坐标系 AMapLocation.COORD_TYPE_WGS84 -- WGS84坐标系,国外定位时返回的是WGS84坐标系
                            Pair("country", it.country),//获取国家名称
                            Pair("description", it.description),//获取位置语义信息
                            Pair("district", it.district),//获取区的名称
                            Pair("floor", it.floor),//获取室内定位的楼层信息
//                            Pair("gpsAccuracyStatus", it.gpsAccuracyStatus),//获取卫星信号强度，仅在卫星定位时有效，值为 #GPS_ACCURACY_BAD，#GPS_ACCURACY_GOOD，#GPS_ACCURACY_UNKNOWN
                            Pair("locationDetail", it.locationDetail),//获取定位信息描述
//                            Pair("locationQualityReport", it.locationQualityReport),//获取定位质量AMapLocationQualityReport
//                            Pair("locationQualityReport_adviseMessage", it.locationQualityReport.adviseMessage),//获取定位质量adviseMessage
                            Pair("poiName", it.poiName),//获取兴趣点名称
                            Pair("provider", it.provider),//获取定位提供者
                            Pair("province", it.province),//获取省的名称
//                            Pair("satellites", it.satellites),//获取当前可用卫星数量，仅在卫星定位时有效
                            Pair("speed", it.speed),//获取当前速度（单位：米/秒）
                            Pair("street", it.street),//获取街道名称
                            Pair("streetNum", it.streetNum),//获取门牌号

//
//                            //获取定位结果的可信度。
//                            // 只有在定位成功时才有意义
//                            // 非常可信 AMapLocation.TRUSTED_LEVEL_HIGH
//                            // 可信度一般AMapLocation.TRUSTED_LEVEL_NORMAL
//                            // 可信度较低 AMapLocation.TRUSTED_LEVEL_LOW
//                            // 非常不可信 AMapLocation.TRUSTED_LEVEL_BAD
//                            Pair("trustedLevel", it.trustedLevel),


                            Pair("toString", it.toStr()),//将定位结果转换为字符串
                            Pair("time", "${it.time}")//格式化后的时间
                    )
                    );


                }

            }

            //Start Location
            startLocation()
        };
    }

    /**
     *  Stop location but do not destroy location service
     *  @see #[startLocation]
     * */
    private fun stopLocation() {
        aMapLocationClient.apply {
            setLocationListener(null);
            stopLocation();
        }
    }


    /**
     * Recreate location service
     * recreate location service:
     * @see #[destroyLocationService]
     * */
    private fun recreateLocationService() {
        aMapLocationClient = AMapLocationClient(mContext);
    }

    /**
     * Destroy location service
     * destroy location service : if you want to start location,
     * you must recreate location service before you start location operation.
     * @see #[recreateLocationService]
     * */
    private fun destroyLocationService() {
        aMapLocationClient.onDestroy();
    }

    private fun doNothing() {
        //empty function
        //do nothing function
        //please do not add anything in this body
    }
}