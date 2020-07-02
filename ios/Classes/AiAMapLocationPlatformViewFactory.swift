//
//  AiAMapLocationPlatformViewFactory.swift
//  ai_amap
//
//  @author JamesAir on 2019/11/1.
//

import Foundation
import Flutter

class AiAMapLocationPlatformViewFactory:NSObject,FlutterPlatformViewFactory{
    
    var binaryMessenger:FlutterBinaryMessenger;
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
    
        binaryMessenger = flutterBinaryMessenger;
    
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AiAMapLocationPlatformView(flutterBinaryMessenger:binaryMessenger);
    }
}
