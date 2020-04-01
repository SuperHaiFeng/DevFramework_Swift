//
//  ZFCommon.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/8.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 应用程序信息
let AppKey = ""
let AppSecret = ""
let RedirectURI = "http://www.baidu.com"

let iphoneX = UIApplication.shared.statusBarFrame.height > 20
let kNavigationHeight = UIApplication.shared.statusBarFrame.height+44
let kContentHeight = UIScreen.main.bounds.height - CGFloat(kNavigationHeight)
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

///用户需要注册通知
let ZFUserShouldRegisterNotification = "ZFUserShouldRegisterNotification"
///用户需要登录通知
let ZFUserShouldLoginNotification = "ZFUserShouldLoginNotification"
///用户登录成功通知
let ZFUserloginSuccessNotification = "ZFUserloginSuccessNotification"

//MARK: - 微博配图视图常量
/// 配图外侧的间距
let ZFStatusPictureViewOutterMargin = CGFloat(12)
///配图内部图像视图的间距
let ZFStatusPictureViewInnerMargin = CGFloat(3)
///视图的宽度
let ZFStatusPictureViewWidth = UIScreen.main.bounds.width - 2 * ZFStatusPictureViewOutterMargin
///每个item的宽度
let ZFStatusPictureItemWidth = (ZFStatusPictureViewWidth - 2 * ZFStatusPictureViewInnerMargin) / 3
