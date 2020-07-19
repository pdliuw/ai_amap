//
//  CustomMAPinAnnotationView.swift
//  ai_amap
//
//  Created by JamesAir on 2020/7/18.
//

import Foundation
import Flutter
import AMapFoundationKit
import AMapNaviKit
import AMapLocationKit
import UIKit

import UIKit
 
class CustomMAPinAnnotationView: MAAnnotationView {
    //定义气泡背景与内容对象
    var calloutView : CustomCalloutView?
    
    var content : String?
    
    //重写选中效果
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected{
            return;
        }
        if selected {
            if calloutView == nil {
                calloutView = CustomCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
                calloutView!.center = CGPoint.init(x: bounds.width/2 + calloutOffset.x, y: -calloutView!.bounds.height/2 + calloutOffset.y)
            
            }
            
            //传入数据给气泡内容
            let image = UIImage.init(named: "MyImageName")
            calloutView?.setImage(image: image!)
 
            calloutView?.setTitle(title: "我是商家名")
            calloutView?.setSubtitle(subtitle: "我是商家地址")
 
            addSubview(calloutView!)
        } else {
            calloutView!.removeFromSuperview()
        }
        
        isDraggable = true;
        isSelected = true;
        canShowCallout = true;
        
        
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(content : String){
        self.content = content
    }
}
