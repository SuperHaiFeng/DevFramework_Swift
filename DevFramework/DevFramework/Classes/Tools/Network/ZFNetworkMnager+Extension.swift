//
//  ZFNetworkMnager+Extention.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/2.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation

///封装微博请求方法
extension ZFNetworkManager {
    /**
        since_id int64若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        max_id int64 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    */
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        ///int 可以转换成anyobject，int64不行
        let params = ["since_id":"\(since_id)","max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: urlString, parametes: params as [String : AnyObject]) { (json, isSuccess) in
            //从json获取字典数组
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
}

//MARK: -用户相关
extension ZFNetworkManager {
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        guard let uid = userAccount.uid else{
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        
        tokenRequest(URLString: urlString, parametes: params as [String : AnyObject]) { (json, isSuccess) in
            completion(json as? [String : AnyObject] ?? [:])
        }
    }
}

// MARK: - OAUth相关
extension ZFNetworkManager {
    ///加载accesstoken
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":AppKey,
                      "client_secret":AppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":RedirectURI]
        ///请求accesstoken
        request(method: .POST, URLString: urlString, parametes: params as [String : AnyObject]) { (json, isSuccess) in
            self.userAccount.yy_modelSet(with: (json as? [String : AnyObject]) ?? [:])
            ///加载当前用户信息
            self.loadUserInfo(completion: { (dict) in
                self.userAccount.yy_modelSet(with: dict)
                self.userAccount.saveAccount()
                print(self.userAccount)
                completion(isSuccess)
            })
        }
        
    }
}
