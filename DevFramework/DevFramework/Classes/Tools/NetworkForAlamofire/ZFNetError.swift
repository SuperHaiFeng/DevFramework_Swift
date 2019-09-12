//
//  ZFNetError.swift
//  DevFramework
//
//  Created by 张志方 on 2019/5/21.
//  Copyright © 2019 志方. All rights reserved.
//

import Foundation

enum ZFNetError : Error{
    //普通的错误信息
    case error(errorMessage:String)
    //数据不是json格式
    case dataJSON(errorMessage:String)
    //数据不匹配
    case dataMatch(errorMessage:String)
    //数据为空
    case dataEmpty(errorMessage:String)
    //网络错误
    case network(errorMessage:String)
    
    static func networkError(with error: NSError) -> ZFNetError {
        if error.domain == "Alamofire.AFError" {
            if error.code == 4 {
                return ZFNetError.dataEmpty(errorMessage: "数据为空")
            }
        }
        return ZFNetError.network(errorMessage: "未知的网络错误")
    }
}

enum NetErrorCode:Int{
    case NET_ERROR_CODE = 0
    case SESSION_EXPIRE_CODE = -1001                        //会话过期
    case CAPTCHA_ERROR_CODE = -1002                         //验证码错误
    case VOICE_LIMIT_CODE   = -1023                         //语音验证码超次数限制
    case PASSWORD_ERROR_CODE = -1020                        //密码输入错误
    case UNWANTED_ViSITORS_CODE = -1003                     //恶意访问
    case LQ_AUTH_CODE     = -20002                          //零钱计划认证
    case LQ_ARGEE_CODE    = -20001                          //零钱计划协议
    case MOBILE_UNREGISTER_CODE = -1021                     //手机号未注册，找回密码第一步
    case MOBILE_REPEATED_CODE = -1022                       //手机号已绑定，注册第一步
    case NET_CANCELLED_CODE   = -1                          //取消请求
    case RISK_LEVEL_UNMATCH   = -3001                       //风险承受能力不符合加入要求
    case COUPON_INVALID       = -3002                       //优惠券不可用
    case NOT_FOUNT_404        = 404
    case NOT_AUTO_BID_CODE    = -10086                      //未授权投标
}
