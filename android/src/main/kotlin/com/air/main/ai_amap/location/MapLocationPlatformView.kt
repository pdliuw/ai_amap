package com.air.main.ai_amap.location

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.os.Bundle
import android.view.View
import com.air.main.ai_amap.GlobalConfig
import com.amap.api.fence.GeoFence
import com.amap.api.fence.GeoFenceClient
import com.amap.api.fence.GeoFenceListener
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.DPoint
import com.amap.api.maps.MapView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * <p>
 * @author air on 2029/10/30.
 * Include:
 * 1、Basic map
 * 2、Location
 * 3、GeoFence
 * 4、Location convert('GPS -> <- AMap -> <- BMap')
 * and location judgment(the location whether is in The China)
 * 5、Calculate distance
 * </p>
 * <p>
 *
 * </p>
 */
class MapLocationPlatformView(binaryMessenger: BinaryMessenger, context: Context?, viewid: Int, args: Any?) : PlatformView, MethodChannel.MethodCallHandler, GeoFenceListener, BroadcastReceiver() {

    /** Context */
    private val mContext = context;

    /** MethodChannel:'flutter -> android' + 'android -> flutter' */
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger, GlobalConfig.METHOD_CHANNEL_ID_MAP_LOCATION_PLATFORM_VIEW);

    /** MapView */
    private var mMapView: MapView = MapView(context);

    /** Location client service */
    private var aMapLocationClient: AMapLocationClient = AMapLocationClient(mContext);

    /** Location Option */
    private var mLocationClientOption: AMapLocationClientOption = AMapLocationClientOption();

    /** GeoFence client */
    private var mGeoFenceClient: GeoFenceClient = GeoFenceClient(mContext?.applicationContext);

    /** Init */
    init {
        //Method call handler
        methodChannel.setMethodCallHandler(this);
    }

    /** Platform view */
    override fun getView(): View {

        mMapView.let {
            mMapView.onCreate(null);
            mMapView.onResume();
        }


        return mMapView;
    }

    /** Platform view's resource release and destroy */
    override fun dispose() {
        mMapView.apply {
            onPause();
            onDestroy();
        }
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
            "showMyLocationIndicator" -> {
                showMyLocationIndicator(true);
            }
            "hideMyLocationIndicator" -> {
                showMyLocationIndicator(false);
            }
            "recreateGeoFenceClient" -> {
                recreateGeoFenceClient();
            }
            "addGeoFence" -> {
                val latitude: Double = call.argument("latitude")!!;
                val longitude: Double = call.argument("longitude")!!;
                val radiusDoubleType: Double = call.argument("radius")!!;
                val radius: Float = radiusDoubleType.toFloat();
                val customId: String = call.argument("customId")!!;
                addGeoFence(latitude = latitude, longitude = longitude, radius = radius, customId = customId);
            }
            "clearAllGeoFence" -> {
                clearAllGeoFence();
            }
            "destroyGeoFenceClient" -> {
                destroyGeoFenceClient();
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

    private fun sendLocationResult(description: String) {
        methodChannel.invokeMethod("startLocationResult", description);
    }

    /**
     * Show my location indicator
     * If Show:
     * if show my location indicator ,the map show my location with indicator,
     * and my location always auto move to the center of the map.
     *
     * If hide:
     * if hide my location indicator ,the map do not show my location with indicator,
     * and my location do not auto move to the center of the map.
     * */
    private fun showMyLocationIndicator(show: Boolean) {
        mMapView.map.isMyLocationEnabled = show;
    }
//
//    /**
//     * Other location convert to amap location
//     * Other location(BAIDU,
//     * MAPBAR,
//     * MAPABC,
//     * SOSOMAP,
//     * ALIYUN,
//     * GOOGLE,
//     * GPS)
//     * convert to amap location,
//     * */
//    private fun convertToAMapLocation(sourceLatLng: DPoint): DPoint {
//        val converter = CoordinateConverter(mContext);
//        // CoordType.GPS 待转换坐标类型
//        converter.from(CoordinateConverter.CoordType.GPS)
//        // sourceLatLng待转换坐标点 DPoint类型
//        converter.coord(sourceLatLng)
//        // 执行转换操作
//        return converter.convert();
//    }
//
//    private fun isChina() {
//        val converter = CoordinateConverter(mContext)
//
//        //返回true代表当前位置在大陆、港澳地区，反之不在。
//        //返回true代表当前位置在大陆、港澳地区，反之不在。
////        val isAMapDataAvailable: Boolean = converter.(latitude, longitude)
//        //第一个参数为纬度，第二个为经度，纬度和经度均为高德坐标系。
//    }
//
//    private fun distance() {
////        DPoint startLatlng, DPoint endLatlng
//        val coordinateConverter = CoordinateConverter(mContext);
//    }
    /**
     * Create geoFence client service
     * 创建地理围栏对象
     * @see [destroyGeoFenceClient]
     */
    private fun recreateGeoFenceClient() {
        //实例化地理围栏客户端
        mGeoFenceClient = GeoFenceClient(mContext?.applicationContext);
        //
        mGeoFenceClient.setGeoFenceListener(this);
        //创建并设置PendingIntent
        mGeoFenceClient.createPendingIntent(GEOFENCE_BROADCAST_ACTION);
        //注册接收地理围栏的消息
        registerGeoFenceBroadcast();
    }

    /**
     * 当不再需要使用围栏时，可以调用以下代码对已经设定的围栏进行清除操作。
     */
    private fun clearAllGeoFence() {
        mGeoFenceClient.removeGeoFence();
    }

    /**
     *
     * @see [recreateGeoFenceClient]
     */
    private fun destroyGeoFenceClient() {

    }

    private fun addGeoFence(latitude: Double, longitude: Double, radius: Float, customId: String) {
        //设置希望侦测的围栏触发行为，默认只侦测用户进入围栏的行为
        //public static final int GEOFENCE_IN 进入地理围栏
        //public static final int GEOFENCE_OUT 退出地理围栏
        //public static final int GEOFENCE_STAYED 停留在地理围栏内10分钟
        mGeoFenceClient.setActivateAction(GeoFenceClient.GEOFENCE_IN);
        //point:围栏中心点
        //radius:要创建的围栏半径 ，半径无限制，单位米
        //customId:与围栏关联的自有业务Id
        var centerPoint: DPoint = DPoint();
        //设置中心点纬度
        centerPoint.latitude = latitude;
        //设置中心点经度
        centerPoint.longitude = longitude;

        mGeoFenceClient.addGeoFence(centerPoint, radius, customId);
    }

    //定义接收广播的action字符串
    val GEOFENCE_BROADCAST_ACTION = "com.air.main.ai_amap.location.geoFence.broadcast"

    private fun doNothing() {
        //empty function
        //do nothing function
        //please do not add anything in this body
    }

    /**
     * 围栏创建完毕的信息会通过 GeoFenceListener 进行回调。可以在回调中知道创建围栏成功与否，以及查看所创建围栏的具体内容。
     */
    override fun onGeoFenceCreateFinished(geoFenceList: List<GeoFence?>?, errorCode: Int, customId: String?) {

        var isAddGeoFenceSuccess: Boolean = false;
        var errorInfo: String;
        if (errorCode == GeoFence.ADDGEOFENCE_SUCCESS) {
            isAddGeoFenceSuccess = true;
            errorInfo = "添加围栏成功";
            //geoFenceList是已经添加的围栏列表，可据此查看创建的围栏
        } else {
            isAddGeoFenceSuccess = false;
            errorInfo = "添加围栏失败";
        }


        methodChannel.invokeMethod("addGeoFenceFinished", mutableMapOf(
                Pair("isAddGeoFenceSuccess", isAddGeoFenceSuccess),//判断围栏是否创建成功
                Pair("errorCode", errorCode),//获取错误码
                Pair("errorInfo", errorInfo)//获取错误信息
        ));
    }

    /**
     * 注册接收地理围栏触发广播
     */
    private fun registerGeoFenceBroadcast() {
        val filter = IntentFilter(
                ConnectivityManager.CONNECTIVITY_ACTION)
        filter.addAction(GEOFENCE_BROADCAST_ACTION)
        mContext?.registerReceiver(this, filter)
    }

    /**
     * 创建广播监听
     */
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null) {
            val action: String? = intent.action;
            if (action != null) {
                if (GEOFENCE_BROADCAST_ACTION == action) {
                    //解析广播内容
                    //获取Bundle
                    val bundle: Bundle? = intent.extras;

                    //解析数据
                    if (bundle != null) {

                        //获取围栏行为：
                        val status: Int = bundle.getInt(GeoFence.BUNDLE_KEY_FENCESTATUS)
                        //获取自定义的围栏标识：
                        val customId: String? = bundle.getString(GeoFence.BUNDLE_KEY_CUSTOMID)
                        //获取围栏ID:
                        val fenceId: String? = bundle.getString(GeoFence.BUNDLE_KEY_FENCEID)
                        //获取当前有触发的围栏对象：
                        val fence: GeoFence? = bundle.getParcelable(GeoFence.BUNDLE_KEY_FENCE)

                        val locationErrorCode: Int = bundle.getInt(GeoFence.BUNDLE_KEY_LOCERRORCODE);

                        if (status == GeoFence.STATUS_IN) {
                            //进入
                        } else if (status == GeoFence.STATUS_OUT) {
                            //离开
                        } else if (status == GeoFence.STATUS_STAYED) {
                            //停留
                        } else {
                            //默认
                            doNothing();
                        }

                        methodChannel.invokeMethod("startGeoFenceReceiverResult", mutableMapOf(
                                Pair("status", status),//获取围栏行为：
                                Pair("customId", customId),//获取自定义的围栏标识：
                                Pair("fenceId", fenceId)//获取围栏ID:
                        ));

                    }
                }
            }

        }

    }


}