//
//  SystemProtocol.swift
//  DevFramework
//
//  Created by macode on 2020/1/8.
//  Copyright © 2020 志方. All rights reserved.
//

import UIKit

struct Directions: OptionSet {
    typealias RawValue = UInt8
    let rawValue: UInt8
    
    static let up = Directions(rawValue: 1 << 0)
    static let down = Directions(rawValue: 1 << 1)
    static let left = Directions(rawValue: 1 << 2)
    static let right = Directions(rawValue: 1 << 3)
}

protocol RawRepresentableProtocol {
    typealias defaultKey = RawRepresentable
}


class SystemProtocol {
    struct RawStruct: RawRepresentableProtocol {
        enum defaultKey: String {
            case key1 = "123"
        }
    }
    
    func test() {
        let direction = Directions()
        direction.rawValue
    }
}
