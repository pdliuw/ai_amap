package com.air.main.ai_amap

import androidx.annotation.NonNull;
import com.air.main.ai_amap.location.MapLocationPlatformViewFactory
import com.air.main.ai_amap.location.MapLocationService
import com.air.main.ai_amap.map.MapPlatformViewFactory

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AiAmapPlugin */
public class AiAmapPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "ai_amap")
        channel.setMethodCallHandler(this);
        /*
        Register location channel
         */
        MapLocationService(binaryMessenger = flutterPluginBinding.binaryMessenger,context = flutterPluginBinding.applicationContext);
        /*
        Register PlatformView
         */
        flutterPluginBinding.platformViewRegistry.registerViewFactory(GlobalConfig.VIEW_TYPE_ID_MAP_PLATFORM_VIEW, MapPlatformViewFactory(flutterPluginBinding.binaryMessenger));
        flutterPluginBinding.platformViewRegistry.registerViewFactory(GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW, MapLocationPlatformViewFactory(flutterPluginBinding.binaryMessenger));
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "ai_amap")
            channel.setMethodCallHandler(AiAmapPlugin())
            /*
            Register location channel
            */
            MapLocationService(binaryMessenger = registrar.messenger(),context = registrar.context());
            /*
            Register PlatformView
             */
            registrar.platformViewRegistry().registerViewFactory(GlobalConfig.VIEW_TYPE_ID_MAP_PLATFORM_VIEW, MapPlatformViewFactory(registrar.messenger()));
            registrar.platformViewRegistry().registerViewFactory(GlobalConfig.VIEW_TYPE_ID_MAP_LOCATION_PLATFORM_VIEW, MapLocationPlatformViewFactory(registrar.messenger()));
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
