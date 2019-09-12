//
//  ZFMessageModel.swift
//  DevFramework
//
//  Created by 张志方 on 2019/5/21.
//  Copyright © 2019 志方. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

struct ZFMessageModel: HandyJSON {
    var code: NSNumber?
    var message: String?
    var data: Message?
    
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.data <-- "data"
    }
}

struct Item: HandyJSON {
    var message_icon: String?
    var message_type: String?
    var is_unread: NSNumber?
    var message_name : String?
    var message_date: String?
    var message_desc: String?
    
}

struct List: HandyJSON {
    var sec_title: String?
    var items: [Item]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.items <-- "items"
    }
}

struct Message: HandyJSON {
    var nav_title: String?
    var message_list: [List]?
    
    func mapping(mapper: HelpingMapper) {
        
    }
}

extension ZFMessageModel {
    func fatchMessageData() -> Observable<ZFMessageModel> {
        return ZFNetworkTool.fetchData(with: ZFRouter.message, parameters: nil, returnType: ZFMessageModel.self).map({ (response: ZFMessageModel) -> ZFMessageModel in
            return response
        })
    }
}


