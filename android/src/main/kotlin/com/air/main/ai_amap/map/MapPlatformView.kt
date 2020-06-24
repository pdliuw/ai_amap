package com.air.main.ai_amap.map

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.core.view.LayoutInflaterCompat
import com.air.main.ai_amap.R
import com.amap.api.maps.AMap
import com.amap.api.maps.MapView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

/**
 * <p>
 * Created by air on 2020/6/24.
 * </p>
 */
class MapPlatformView(binaryMessenger: BinaryMessenger, context: Context?, viewid: Int, args: Any?) : PlatformView {

    private var mContext: Context? = context;
    private var mMapView = MapView(mContext);

    @SuppressLint("InflateParams")
    override fun getView(): View {
        val inflater = LayoutInflater.from(mContext);
        val mapViewGroup: View = inflater.inflate(R.layout.map_layout, null, false);
        mMapView = mapViewGroup.findViewById<MapView>(R.id.map_view);
        mMapView.onCreate(null);
        mMapView.onResume();
        return mapViewGroup;
    }

    override fun dispose() {
        mMapView.onPause();
        mMapView.onDestroy();
    }
}