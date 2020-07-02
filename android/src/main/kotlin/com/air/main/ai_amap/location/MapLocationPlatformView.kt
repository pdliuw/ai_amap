package com.air.main.ai_amap.location

import android.content.Context
import android.view.View
import com.air.main.ai_amap.GlobalConfig
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.MapView
import com.amap.api.navi.model.AMapServiceAreaInfo
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.text.SimpleDateFormat
import java.util.*

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
class MapLocationPlatformView(binaryMessenger: BinaryMessenger, context: Context?, viewid: Int, args: Any?) : PlatformView, MethodChannel.MethodCallHandler {

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
            "setApiKey"->{
                val key:String? = call.argument("apiKey");
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
            //

        }
    }

    private fun setApiKey(key:String?){
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
                    if (it.errorCode == 0) {
                        //定位成功回调信息，设置相关消息

                        it.locationType;//获取当前定位结果来源，如网络定位结果，详见定位类型表
                        it.latitude;//获取纬度
                        it.longitude;//获取经度
                        it.accuracy;//获取精度信息
                        it.province;
                        it.city;

                        val df = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                        val date = Date(it.time)
                        val formattedDate = df.format(date) //定位时间
                    } else {

                        //显示错误信息ErrCode是错误码，errInfo是错误信息，详见错误码表。
                        it.errorCode;
                        it.errorInfo;
                    }


                }

                //测试代码
                sendLocationResult(description = "${it.address}");

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

    private fun doNothing() {}
}