//
//  ZFNetworkManager.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/1.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import AFNetworking

///枚举支持任意类型
enum ZFHTTPMethod {
    case GET
    case POST
}

class ZFNetworkManager: AFHTTPSessionManager {

    ///静态区、常量、闭包
    ///第一次执行，会保存在shared中，单例
    static let shared = { ()-> ZFNetworkManager in
        let instance = ZFNetworkManager()
        
        //设置响应的反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }
    
    lazy var userAccount = ZFUserAccount()
    
    var userLogin: Bool {
        return userAccount.access_token != nil
    }
    
    ///专门负责拼接token的网络请求方法
    func tokenRequest(method: ZFHTTPMethod = .GET, URLString:String, parametes: [String: AnyObject]?, completion: @escaping ( _ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        ///判断token是否为nil
        guard let token = userAccount.access_token else {
            // 发送通知（提示登录）
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserShouldLoginNotification), object: nil)
            completion(nil,false)
            return
        }
        
        ///判断参数字典是否存在，如果为nil，应该新建一个字典
        var parametes = parametes
        if parametes == nil {
            parametes = [String: AnyObject]()
        }
        
        ///设置参数字典
        parametes!["access_token"] = token as AnyObject
        
        ///调用request 发起真正的请求方法
        request(method: method ,URLString: URLString, parametes: parametes, completion: completion)
    }
    
    ///使用一个函数封装AFN的get和post请求
    func request(method: ZFHTTPMethod = .GET, URLString:String, parametes: [String: AnyObject]?, completion: @escaping ( _ json: AnyObject?, _ isSuccess: Bool)->()) {

        if method == .GET {
            get(URLString, parameters: parametes, progress: nil, success: { (task: URLSessionDataTask, json) in
                completion(json as AnyObject, true)
            }, failure: { (task: URLSessionDataTask?, error) in
                completion(nil, false)
                ///针对403错误码(token过期)
                if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                    // 发送通知(本方法不知道被谁调用 提示用户登录)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserShouldLoginNotification), object: "bad token")
                }
            })
        }else{
            post(URLString, parameters: parametes, progress: nil, success: { (task: URLSessionDataTask, json) in
                print(json ?? "")
                completion(json as AnyObject, true)
            }, failure: { (task: URLSessionDataTask?, error) in
                completion(nil, false)
                ///针对403错误码(token过期)
                if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                    //发送通知(本方法不知道被谁调用 提示用户登录)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserShouldLoginNotification), object: "bad token")
                }
            })            
        }
        
    }
}
