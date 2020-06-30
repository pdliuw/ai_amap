package com.air.main.ai_amap.location

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.air.main.ai_amap.GlobalConfig
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.MapView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.text.SimpleDateFormat
import java.util.*

/**
 * <p>
 * @author air on 2029/10/30.
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

    /**
     * Start location
     * @see #[stopLocation]
     * */
    private fun startLocation() {

        if (aMapLocationClient.isStarted) {
            //Location service already started,return
            return;
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

    private fun showMyLocationIndicator(show: Boolean) {
        mMapView.map.isMyLocationEnabled = true;
    }

    private fun doNothing() {}
}