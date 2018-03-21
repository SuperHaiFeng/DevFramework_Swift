//
//  String+Extension.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/11.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation

extension String {
    ///获取沙盒路径
    func zf_appendDocumentDir() -> String {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = (docDir as NSString).appendingPathComponent(self)
        return path
    }
    
    ///从当前字符串中，提取链接和文本,正则表达式
    func zf_regxHref() -> (link: String, text: String)? {
        ///匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        ///创建正则表达式
        guard let regx = try? NSRegularExpression.init(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange.init(location: 0, length: self.count)) else{
            return nil
        }
        ///获取结果
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link,text)
    }
}
