//
//  AiAMapPlatformViewFactory.swift
//  ai_amap
//
//  Created by JamesAir on 2020/6/27.
//

import Foundation
class AiAMapPlatformViewFactory:NSObject,FlutterPlatformViewFactory{
    
    var binaryMessenger:FlutterBinaryMessenger;
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
    
        binaryMessenger = flutterBinaryMessenger;
    
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AiAMapPlatformView(flutterBinaryMessenger:binaryMessenger);
    }
}
