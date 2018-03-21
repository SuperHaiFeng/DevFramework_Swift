//
//  UIImage+Extension.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/24.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

extension UIImage {
    ///创建头像图像
    func zf_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect.init(origin: CGPoint(), size: size!)
        UIGraphicsBeginImageContextWithOptions(size!, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath.init(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath.init(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
        
    }
}
