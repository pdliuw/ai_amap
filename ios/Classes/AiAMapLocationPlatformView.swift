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
class AiAMapLocationPlatformView:NSObject,FlutterPlatformView,MAMapViewDelegate, AMapLocationManagerDelegate,AMapGeoFenceManagerDelegate,AMapNaviCompositeManagerDelegate{
    
    // MethodChannel
    var methodChannel:FlutterMethodChannel?;
    
    // MapView
    var mapView: MAMapView!
    
    var binaryMessenger:FlutterBinaryMessenger!;
    
    // Location Manager
    var mAMapLocationManager:AMapLocationManager = AMapLocationManager.init();
    //GeoFence Manager
    var mAMapGeoFenceManager:AMapGeoFenceManager = AMapGeoFenceManager.init();
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
        
        super.init();
        
        self.binaryMessenger = flutterBinaryMessenger;
        
        initMethodChannel()
        
        
        initMapView()
        
    }
    func initMapView(){
        mapView = MAMapView()
        mapView.delegate = self
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
            case "addMarker":
                let latitude: Double = arg?["latitude"] as! Double;
                let longitude: Double = arg?["longitude"] as! Double;
                let title:String = arg?["title"] as! String;
                let snippet:String = arg?["snippet"] as! String;
                self.addMarker(latitude: latitude, longitude: longitude, title: title, snippet: snippet);
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
            case "recreateGeoFenceClient":
                self.recreateGeoFenceClient();
                break;
            case "addGeoFence":
                let latitude: Double = arg?["latitude"] as! Double;
                let longitude: Double = arg?["longitude"] as! Double;
                let radiusDoubleType: Double = arg?["radius"] as! Double;
                let customId: String = arg?["customId"] as! String;
                self.addGeoFence(latitude: latitude, longitude: longitude, radius: radiusDoubleType, customId: customId);
                break;
            case "clearAllGeoFence":
                self.clearAllGeoFence();
                break;
            case "startNavigatorWidget":
                self.showAMapNavigatorPage();
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
    
    func addMarker(latitude: Double, longitude: Double, title: String, snippet: String) {
        let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pointAnnotation.title = title;
        pointAnnotation.subtitle = snippet
    
        mapView.addAnnotation(pointAnnotation)
    }
    func clearAllOverlay(){
        
    
    }
    func recreateLocationService(){
        mAMapLocationManager = AMapLocationManager.init();
    }
    
    func destroyLocationService(){
        
    }

    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            
            if(annotation.isKind(of: MAUserLocation.self)){
                return nil;
            }else{
                
                let pointReuseIndetifier = "pointReuseIndetifier"
                var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
                
                if annotationView == nil {
                    annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                }
                
                let button = UIButton(type: UIButton.ButtonType.system);
                button.frame = CGRect(x: 10, y: 10, width: 60, height: 40);
                button.setTitle("去导航", for: UIControl.State.normal)
                button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
                button.backgroundColor = UIColor.white
                button.setImage(UIImage(named: "Image"), for: UIControl.State.normal)
                naviTitle = annotation.title as! String;
                naviSnippet = annotation.subtitle as! String;
                naviLatitude  = annotation.coordinate.latitude;
                naviLongitude = annotation.coordinate.longitude;
                
                button.addTarget(self, action:#selector(buttonAtion(button:)), for:UIControl.Event.touchUpInside)
                
                annotationView!.canShowCallout = true
                annotationView!.animatesDrop = true
                annotationView!.isDraggable = true
                annotationView!.rightCalloutAccessoryView = button
                
                annotationView!.pinColor = MAPinAnnotationColor.red
                
                return annotationView!
            }
        }
        
        return nil
    }
    var naviTitle:String?;
    var naviSnippet:String?;
    var naviLatitude:Double?;
    var naviLongitude:Double?;
    
    
    @objc func buttonAtion(button:UIButton){
        
        let infoWindowConfirm:[String:Any] = [
            "title" : naviTitle,
            "snippet" : naviSnippet,
            "latitude" : naviLatitude,
            "longitude" : naviLongitude,
        ]
        
        self.methodChannel?.invokeMethod("infoWindowConfirm", arguments: infoWindowConfirm);
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
    
    func recreateGeoFenceClient(){
        self.mAMapGeoFenceManager = AMapGeoFenceManager()
        self.mAMapGeoFenceManager.delegate = self
        
    }
    
    func addGeoFence(latitude: Double, longitude: Double, radius: Double, customId: String){
        //进入，离开，停留都要进行通知
        self.mAMapGeoFenceManager.activeAction = [AMapGeoFenceActiveAction.inside, AMapGeoFenceActiveAction.outside, AMapGeoFenceActiveAction.stayed]
        //允许后台定位
        self.mAMapGeoFenceManager.allowsBackgroundLocationUpdates = true
        
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.mAMapGeoFenceManager.addCircleRegionForMonitoring(withCenter: coordinate, radius: radius, customID: customId);

    }
    
    func showAMapNavigatorPage(){
        let naviManager = AMapNaviCompositeManager.init();
        naviManager.delegate = self;
        naviManager.presentRoutePlanViewController(withOptions: nil);
    }
    
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didAddRegionForMonitoringFinished regions: [AMapGeoFenceRegion]!, customID: String!, error: Error!) {
        
        var isAddGeoFenceSuccess: Bool = false;
        var errorCode:Int;
        var errorInfo: String;
        

        if let error = error {
            isAddGeoFenceSuccess = false;
            let error = error as NSError
            errorCode = error.code
            errorInfo = "添加围栏失败";
        }
        else {
            isAddGeoFenceSuccess = true;
            errorCode = 0;
            errorInfo = "添加围栏成功";
        }
        let geoFenceFinishedMap:[String:Any] = [
            "isAddGeoFenceSuccess":isAddGeoFenceSuccess,
            "errorCode":errorCode
        ];
        self.methodChannel?.invokeMethod("addGeoFenceFinished", arguments: geoFenceFinishedMap);
    }
    
    func amapGeoFenceManager(_ manager: AMapGeoFenceManager!, didGeoFencesStatusChangedFor region: AMapGeoFenceRegion!, customID: String!, error: Error!) {
        
        
        
        if error == nil {
            
            print("status changed \(region.description)")
            
            
            let geoFenceResultMap:[String:Any] = [
                "status":region.fenceStatus.rawValue,
                "customId":region.customID ?? "",
                "fenceId":region.identifier ?? "",//AMapGeoFenceRegion的唯一标识符
            ];
            
            self.methodChannel?.invokeMethod("startGeoFenceReceiverResult", arguments: geoFenceResultMap);
            
            
            
        } else {
            print("status changed error \(String(describing: error))")
        }
        
        
    }
    
    func clearAllGeoFence(){
        
        mAMapGeoFenceManager.removeAllGeoFenceRegions();
        
    }
}

