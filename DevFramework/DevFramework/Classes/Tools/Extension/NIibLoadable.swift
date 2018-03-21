//
//  NIibLoadable.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/23.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    ///在协议里不允许定义class ，只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        ///Self（大写） 当前类对象   self（小写）当前类
        let loadName = nibname == nil ? "\(self)" : nibname!
        let v = Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
        v.frame = UIScreen.main.bounds
        return v
    }
    
}
