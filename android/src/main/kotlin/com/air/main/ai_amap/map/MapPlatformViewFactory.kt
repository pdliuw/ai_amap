package com.air.main.ai_amap.map

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * <p>
 * Created by air on 2020/6/24.
 * </p>
 */
class MapPlatformViewFactory(private var binaryMessenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return MapPlatformView(binaryMessenger, context, viewId, args);
    }
}