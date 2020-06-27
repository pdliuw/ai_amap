//
//  AiAMapPlatformView.swift
//  ai_amap
//
//  Created by JamesAir on 2020/6/27.
//

import Foundation
import Flutter
//import AMapFoundationKit
import AMapNaviKit


class AiAMapPlatformView:NSObject,FlutterPlatformView{
    
    var mapView: MAMapView!

    var binaryMessenger:FlutterBinaryMessenger!;
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
        
        super.init();
        
        self.binaryMessenger = flutterBinaryMessenger;
    
        initMapView()
    }
    func initMapView(){
        mapView = MAMapView()
    }
    
    func view() -> UIView {

        return mapView;
    }
    
    
}
