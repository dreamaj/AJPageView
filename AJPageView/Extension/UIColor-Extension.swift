//
//  UIColor-Extension.swift
//  XMGTV
//
//  Created by 艾晶 on 2017/4/14.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

extension UIColor {
    // 在extension中给系统的类扩充构造函数，只能扩充便利构造函数
    // RGB
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
        
    }
    
    //十六进制
    convenience init?(hex : String, alpha: CGFloat = 1.0) {
        
        //解析十六进制
        //1.判断字符串长度是否符合
        guard hex.characters.count >= 6 else {
            return nil
        }
        
        //2.将字符串转成大写
        var tempHex = hex.uppercased()
        
        //判断开头：0x/#/##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
            
        }
        
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        // 4.分别取出RGB
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        
        let bHex = (tempHex as NSString).substring(with: range)
        
        //5.将十六进制转成数字 类似emoji表情
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        
        self.init(r: CGFloat(r), g: CGFloat(r), b: CGFloat(r), alpha: alpha)
        
    }
    
    class func randomColor() -> UIColor {
    
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
        
    }
    
    class func randomColorWithAlpha() -> UIColor {
        
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)),alpha:  CGFloat(drand48()))
        
    }
    
    class func getRGBDelta(_ firstColor: UIColor, _ secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat){
        
        guard let firstCpm = firstColor.cgColor.components else {
            
            fatalError("保证选中颜色是RGB方式传入")
            
        }
        
        let firstRGB = firstColor.getRGB()
        
        guard let secondCpm = secondColor.cgColor.components else {
            
            fatalError("保证默认颜色是RGB方式传入")
            
        }
        
        let secondRGB = secondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
        
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        
        guard let cmp = cgColor.components else {
            
            fatalError("保证默认颜色是RGB方式传入")
            
        }
        
        return (cmp[0] * 255, cmp[1] * 255, cmp[2] * 255)
        
    }
}







