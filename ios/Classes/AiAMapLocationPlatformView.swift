//
//  AiAMapLocationPlatformView.swift
//  ai_amap
//
//  @author JamesAir on 2019/11/1.
//

import Foundation
import Flutter
import AMapFoundationKit
import AMapNaviKit
import AMapLocationKit
import UIKit

//
//  AiAMapLocationPlatformView
class AiAMapLocationPlatformView:NSObject,FlutterPlatformView,MAMapViewDelegate, AMapLocationManagerDelegate{
    
    // MethodChannel
    var methodChannel:FlutterMethodChannel?;
    
    // MapView
    var mapView: MAMapView!
    
    var binaryMessenger:FlutterBinaryMessenger!;
    
    // Location Manager
    var mAMapLocationManager:AMapLocationManager = AMapLocationManager.init();
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
        
        super.init();
        
        self.binaryMessenger = flutterBinaryMessenger;
        
        initMethodChannel()
        
        
        initMapView()
        
    }
    func initMapView(){
        mapView = MAMapView()
    }
    
    func view() -> UIView {
        
        return mapView;
    }
    
    func initMethodChannel(){
        
        
        //create method channel single instance.
        methodChannel = FlutterMethodChannel.init(name: "method_channel_id_map_location_platform_view", binaryMessenger: binaryMessenger);
        
        
        // method channel call handler
        methodChannel?.setMethodCallHandler { (call :FlutterMethodCall, result:@escaping FlutterResult)  in
            
            
            let arg = call.arguments as? [String:Any]
            
            switch(call.method){
            case "setApiKey":
                let apiKey = arg?["apiKey"] as? String
                //set api key
                self.setApiKey(key: apiKey);
               
                break;
            case "recreateLocationService":
                //recreate location service
                self.recreateLocationService();
                break;
            case "destroyLocationService":
                //destroy location service
                self.destroyLocationService();
                break;
            case "startLocation":
                //start location
                self.startLocation();
                break;
                
            case "stopLocation":
                //stop location
                self.stopLocation();
                break;
                
            case "showMyLocationIndicator":
                //show my location indicator
                self.showMyLocationIndicator(show:true);
                break;
            case "hideMyLocationIndicator":
                //hide my location indicator
                self.showMyLocationIndicator(show:false);
                break;
            default:
                result("method:\(call.method) not implement");
            }
            
        }
    }
    //MARK: - AMapLocationManagerDelegate
    
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        let error = error as NSError
        NSLog("didFailWithError:{\(error.code) - \(error.localizedDescription)};")
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)};");
//
//        let locationResultMap:[String:Any] = [
//            "isLocationSuccessful":true,
//            "address": reGeocode?.formattedAddress ?? "",
//            "latitude": location?.coordinate.latitude ?? 0,
//            "longitude": location?.coordinate.longitude ?? 0,
//            "adCode": reGeocode?.adcode ?? "",
//            "altitude": location?.altitude ?? 0,
//            "aoiName":reGeocode?.aoiName ?? "",
//            "bearing":0,
//            "city":reGeocode?.city ?? "",
//            "cityCode":reGeocode?.citycode ?? "",
//            "conScenario":0,
//            "coordType":"",
//            "country":reGeocode?.country ?? "",
//            "description":reGeocode?.description ?? "",
//            "district":reGeocode?.district ?? "",
//            "floor":location?.floor ?? "",
//            "gpsAccuracyStatus":0,
//            "locationDetail":"",
//            "poiName":reGeocode?.poiName ?? "",
//            "provider":"",
//            "province":reGeocode?.province ?? "",
//            "satellites":0,
//            "speed":0,
//            "street":reGeocode?.street ?? "",
//            "streetNum":reGeocode?.number ?? "",
//            "trustedLevel":0,
//            "toString":"",
//            "time":"\(String(describing: location?.timestamp))",
//        ]
//
//        //测试代码，还需要进一步修改
//        self?.methodChannel?.invokeMethod("startLocationResult", arguments: locationResultMap);
    }
    
    
    //
    // Set ApiKey
    func setApiKey(key:String?){
        //您只需在配置高德 Key 前，添加开启 HTTPS 功能的代码
        AMapServices.shared().enableHTTPS = true
        //在调用定位时，需要添加Key，需要注意的是请在 SDK 任何类的初始化以及方法调用之前设置正确的 Key
        AMapServices.shared().apiKey = key;
    }
    func recreateLocationService(){
        mAMapLocationManager = AMapLocationManager.init();
    }
    
    func destroyLocationService(){
        
    }
    
    
    private func doRequireLocationAuth(_ manager: AMapLocationManager?, doRequireLocationAuth locationManager: CLLocationManager?) {
        locationManager?.requestAlwaysAuthorization()
    }
    
    func startLocation(){
        
        mAMapLocationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
                    
            //location whether successful
            var isLocationSuccessful:Bool = true;
            var errorCode = 0;
            var errorInfo = "";
            
            if let error = error {
                let error = error as NSError
                
                //errorCode,errorInfo
                errorCode = error.code;
                errorInfo = error.localizedDescription;
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    self?.sendLocationResult(message: "定位错误:{\(error.code) - \(error.localizedDescription)};")
                    isLocationSuccessful = false;
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                    self?.sendLocationResult(message: "逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    isLocationSuccessful = false;
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                    isLocationSuccessful = true;
                }
            }
            
            if let location = location {
                NSLog("location:%@", location)
            }
            
            if let reGeocode = reGeocode {
            
                NSLog("reGeocode:%@", reGeocode)
            }
            
            
            let locationResultMap:[String:Any] = [
                "isLocationSuccessful" : isLocationSuccessful,
                "errorCode": errorCode,
                "errorInfo": errorInfo,
                "address": reGeocode?.formattedAddress ?? "",
                "latitude": location?.coordinate.latitude ?? 0,
                "longitude": location?.coordinate.longitude ?? 0,
                "accuracy": location?.horizontalAccuracy ?? 0,
                "adCode": reGeocode?.adcode ?? "",
                "altitude": location?.altitude ?? 0,
                "aoiName":reGeocode?.aoiName ?? "",
                "bearing":0,
                "city":reGeocode?.city ?? "",
                "cityCode":reGeocode?.citycode ?? "",
                "conScenario":0,
                "coordType":"",
                "country":reGeocode?.country ?? "",
                "description":reGeocode?.description ?? "",
                "district":reGeocode?.district ?? "",
                "floor":location?.floor ?? "",
                "gpsAccuracyStatus":0,
                "locationDetail":"",
                "poiName":reGeocode?.poiName ?? "",
                "provider":"",
                "province":reGeocode?.province ?? "",
                "satellites":0,
                "speed":0,
                "street":reGeocode?.street ?? "",
                "streetNum":reGeocode?.number ?? "",
                "trustedLevel":0,
                "toString":"",
                "time":"\(String(describing: location?.timestamp))",
            ]
            
            //测试代码，还需要进一步修改
            self?.methodChannel?.invokeMethod("startLocationResult", arguments: locationResultMap);
//            self?.sendLocationResult(message: "location信息：\(String(describing: location.))")
        })
    }
    
    func stopLocation(){
        //cancel all once location
        mAMapLocationManager.stopUpdatingLocation();
    }
    
    func showMyLocationIndicator(show :Bool){
        mapView.showsUserLocation = show;
        mapView.userTrackingMode = MAUserTrackingMode.follow;
        let r = MAUserLocationRepresentation();
        r.showsHeadingIndicator = show;
        r.showsAccuracyRing = show;
        r.enablePulseAnnimation = show;
        mapView.update(r);
    }
    
    
    func doNothing(){
        //do nothing
    }
    
    //
    // Send location result ("ios -> flutter")
    func sendLocationResult(message:String?){
        methodChannel?.invokeMethod("startLocationResult", arguments: message);
    }
    
}

