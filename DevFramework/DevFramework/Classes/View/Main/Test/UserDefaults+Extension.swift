//
//  UserDefaults+Extension.swift
//  DevFramework
//
//  Created by macode on 2020/1/8.
//  Copyright © 2020 志方. All rights reserved.
//

import Foundation

struct PreferenceName<T>: RawRepresentable {
    typealias RawValue = String
    
    var rawValue: String
    init(rawValue: PreferenceName.RawValue) {
        self.rawValue = rawValue
    }
}

extension UserDefaults {
    /// 使用subscript下标语法
    subscript(key: PreferenceName<Bool>) -> Bool {
        set {set(newValue, forKey: key.rawValue)}
        get {return bool(forKey: key.rawValue)}
    }
    
    subscript(key: PreferenceName<Int>) -> Int {
        set {set(newValue, forKey: key.rawValue)}
        get {return integer(forKey: key.rawValue)}
    }
    
    subscript(key: PreferenceName<Any>) -> Any? {
        set {set(newValue, forKey: key.rawValue)}
        get {return value(forKey: key.rawValue)}
    }
}

struct PreferenceNames {
    static let maxCacheSize = PreferenceName<Int>(rawValue: "MaxCacheSize")
}

/// 使用的时候
func test() {
    UserDefaults.standard[PreferenceNames.maxCacheSize] = 30
}
