//
//  Bundle.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation

extension Bundle {
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}

