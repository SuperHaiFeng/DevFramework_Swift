//
//  ZFStatuses.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/2.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import YYModel

class ZFStatuses: NSObject {
    override init() {
        super.init()
    }
    @objc var id: Int64 = 0
    ///微博信息内容
    @objc var text: String?
    ///转发数
    @objc var reposts_count: Int = 0
    ///评论数
    @objc var comments_count: Int = 0
    ///微博创建时间
    @objc var created_at: String?
    ///发布微博来源-使用的客户端
    @objc var source: String? {
        didSet{
            source = "来自" + (source?.zf_regxHref()?.text ?? "")
        }
    }
    ///点赞数
    @objc var attitudes_count: Int = 0
    ///配图模型数组
    @objc var pic_urls: [ZFStatusPicture]?
    ///被转发的原创微博
    @objc var retweeted_status: ZFStatuses?
    
    ///用户
    @objc var user: ZFUser?
    
    override var description: String{
        return yy_modelDescription()
    }
    ///yymodel的类函数(遇到数组类型的属性，数组中存放的对象什么类
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": ZFStatusPicture.self]
    }
    
    override func setNilValueForKey(_ key: String) {
        
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
    }
}
