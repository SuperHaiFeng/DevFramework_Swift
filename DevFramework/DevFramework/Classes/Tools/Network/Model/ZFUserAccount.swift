//
//  ZFZFUserAccount.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/11.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

private let accountFile: String = "useraccount.json"

class ZFUserAccount: NSObject {

    override init() {
        super.init()
        ///从磁盘加载保存的文件
        guard case let path = accountFile.zf_appendDocumentDir(),
            let data = NSData.init(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
            else {
                return
        }
        ///使用字典设置属性值
        yy_modelSet(with: dict ?? [:])
        
        ///判断token是否过期
        if expiresDate?.compare(Date()) == .orderedAscending {
            access_token = nil
            uid = nil
            _ = try? FileManager.default.removeItem(atPath: path)
        }
    }
    ///访问令牌
    @objc var access_token : String?
    @objc var uid: String?
    ///access_token的生命周期,单位秒
    @objc var expires_in = TimeInterval() {
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    ///过期日期
    @objc var expiresDate: Date?
    ///用户昵称
    @objc var screen_name: String?
    ///用户头像
    @objc var avatar_large: String?
    
    /**
         保存用户信息
         1、偏好设置
         2、沙盒-归档/plist/json
         3、数据库(FMDB/CoreData)
         4、钥匙串(使用框架 SSKeychain)
    */
    func saveAccount() {
        ///模型转字典（删除expires_in）
        var dict = self.yy_modelToJSONObject() as? [String: AnyObject] ?? [:]
        dict.removeValue(forKey: "expires_in")
        ///序列化
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            case let filePath = accountFile.zf_appendDocumentDir()
        else {
            return
        }
        ///写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print(filePath)
    }
    
    override var description: String{
        return yy_modelDescription()
    }
    
    override func setNilValueForKey(_ key: String) {
        
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
    }
    
}
