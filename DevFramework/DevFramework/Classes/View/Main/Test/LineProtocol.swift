//
//  LineProtocol.swift
//  DevFramework
//
//  Created by macode on 2020/1/8.
//  Copyright © 2020 志方. All rights reserved.
//

import UIKit

protocol IsEqual {
    static func == (lhs: Self, rhs: Self) -> Bool
    
    static func != (lhs: Self, rhs: Self) -> Bool
}

protocol Comparable {
    static func > (lhs: Self, rhs: Self) -> Bool
    static func < (lhs: Self, rhs: Self) -> Bool
    static func >= (lhs: Self, rhs: Self) -> Bool
    static func <= (lhs: Self, rhs: Self) -> Bool
}

/// 遵守协议
class LineProtocol: IsEqual, Comparable {
    var beginPoint: CGPoint
    var endPoint: CGPoint
    
    init() {
        beginPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 0)
    }
    
    init(beginPoint: CGPoint, endPoint: CGPoint) {
        self.beginPoint = CGPoint(x: beginPoint.x, y: beginPoint.y)
        self.endPoint = CGPoint(x: endPoint.x, y: endPoint.y)
    }
    
    /// 计算长度
    func length() -> CGFloat {
        let length = sqrt(pow(endPoint.x - beginPoint.x, 2) + pow(endPoint.y - beginPoint.y, 2))
        return length
    }
    
    static func == (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() == rhs.length()
    }
    
    static func != (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() != rhs.length()
    }
    
    static func < (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() < rhs.length()
    }
    
    static func > (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() > rhs.length()
    }
    
    static func >= (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() >= rhs.length()
    }
    
    static func <= (lhs: LineProtocol, rhs: LineProtocol) -> Bool {
        return lhs.length() <= rhs.length()
    }
}
