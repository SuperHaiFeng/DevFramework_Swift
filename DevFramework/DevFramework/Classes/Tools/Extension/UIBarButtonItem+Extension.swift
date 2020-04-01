//
//  UIBarButtonItem+Extension.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String, fontSize: CGFloat = 16, image: UIImage?, horizontalAlignment: UIControl.ContentHorizontalAlignment, target: AnyObject?, action: Selector) {
        let btn : UIButton = UIButton.init()
        btn.setTitle(title, for: [])
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.darkGray, for: [])
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(image, for: [])
        if image != nil {
            btn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -5, bottom: 12, right: 0)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        }
        btn.contentHorizontalAlignment = horizontalAlignment
        btn.imageView?.contentMode = .scaleAspectFit
        btn.frame = CGRect.init(x: 0, y: 0, width: 85, height: 44)
        
        self.init(customView: btn)
    }
}
