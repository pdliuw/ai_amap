//
//  CustomCalloutView.swift
//  ai_amap
//
//  @author JamesAir on 2020.
//


import UIKit

class CustomCalloutView: UIView{
    var portraitView : UIImageView!
    var subtitleLabel : UILabel!
    var titleLabel : UILabel!
    
    //初始化定义气泡的背景
    override func draw(_ rect: CGRect) {
        drawInContext(context: UIGraphicsGetCurrentContext()!)
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.red
        
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawInContext(context : CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        getDrawPath(context: context)
        context.fillPath()
    }
    
    func getDrawPath(context : CGContext) {
        let kArrorHeight = 10
        let rect = self.bounds
        let radius = 6.0
        let minx = rect.minX
        let midx = rect.midX
        let maxx = rect.maxX
        let miny = rect.minY
        let maxy = rect.maxY - 10
        
        context.move(to: CGPoint.init(x: midx + CGFloat(kArrorHeight), y: maxy))
        context.addLine(to: CGPoint.init(x: midx, y: maxy + CGFloat(kArrorHeight)))
        context.addLine(to: CGPoint.init(x: midx - CGFloat(kArrorHeight), y: maxy))
        
        context.addArc(tangent1End: CGPoint.init(x: minx, y: maxy), tangent2End: CGPoint.init(x: minx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: minx, y: minx), tangent2End: CGPoint.init(x: maxx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: miny), tangent2End: CGPoint.init(x: maxx, y: maxx), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: maxy), tangent2End: CGPoint.init(x: midx, y: maxy), radius: CGFloat(radius))
        context.closePath();
    }
    
    //初始化定义气泡的内容
    func initSubViews() {
        backgroundColor = UIColor.clear
        let kPortraitMargin = 5.0
        let kPortraitWidth = 70.0
        let kPortraitHeight = 50.0
        let kTitleWidth = 120.0
        let kTitleHeight = 20.0
        
        // 添加图片，即商户图
        portraitView = UIImageView.init(frame: CGRect.init(x: kPortraitMargin, y: kPortraitMargin, width: kPortraitWidth, height: kPortraitHeight))
        portraitView.backgroundColor = UIColor.black
        addSubview(portraitView)
        
        // 添加标题，即商户名
        titleLabel = UILabel.init(frame: CGRect.init(x: kPortraitMargin * 2 + kPortraitWidth, y: kPortraitMargin, width: kTitleWidth, height: kTitleHeight))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "我是商户名"
        addSubview(titleLabel)
        
        // 添加副标题，即商户地址
        subtitleLabel = UILabel.init(frame: CGRect.init(x: kPortraitMargin * 2 + kPortraitWidth, y: kPortraitMargin * 2 + kTitleHeight, width: kTitleWidth, height: kTitleHeight))
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.text = "我是商户地址"
        addSubview(subtitleLabel)
    }
    
    //给控件传入数据
    func setTitle(title : NSString) {
        titleLabel.text = title as String;
    }
    
    func setSubtitle(subtitle : NSString) {
        subtitleLabel.text = subtitle as String;
    }
    
    func setImage(image : UIImage) {
        portraitView.image = image;
    }
    
    ///导航事件
    @objc func guidBtnAction() {
        //        self.guideActionCallBack?()
    }
    
    func guideActionCallBack() {
        print("click btn")
    }
}
