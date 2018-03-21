//
//  ZFComposeTypeView.swift
//  DevFramework
//
//  Created by 志方 on 2018/3/2.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFComposeTypeView:UIView, NibLoadable {
    
    ///显示当前视图
    func show() {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return;
        }
        vc.view.addSubview(self)
        
    }
}
