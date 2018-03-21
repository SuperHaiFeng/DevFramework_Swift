//
//  ZFUser.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/23.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFUser: NSObject {

    @objc var id: Int64 = 0
    ///用户昵称
    @objc var screen_name: String?
    ///用户头像地址（中国），50*50
    @objc var profile_image_url: String?
    ///认证类型，-1：没有认证，0：认证用户。2，3，5：企业认证，220:达人
    @objc var verified_type: Int = 0
    ///会员等级
    @objc var mbrank: Int = 0
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
