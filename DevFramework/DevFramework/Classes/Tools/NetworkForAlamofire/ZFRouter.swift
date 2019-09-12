//
//  ZFRouter.swift
//  DevFramework
//
//  Created by 张志方 on 2019/5/21.
//  Copyright © 2019 志方. All rights reserved.
//

import UIKit
import Alamofire

enum ZFRouter: String, URLConvertible {
    case message = "/mock/14/api/message"
    
    func asURL() throws -> URL {
        return URL(string: urlString())!
    }
    
    static var baseUrl: String = "http://api.svc.zuinianqing.com"
    
    private func urlString() -> String{
        return ZFRouter.baseUrl.appending(rawValue)
    }
}
