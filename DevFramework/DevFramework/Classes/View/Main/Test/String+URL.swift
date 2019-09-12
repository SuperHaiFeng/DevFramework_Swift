//
//  String+URL.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//


extension String {
    var URLEscaped: String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
