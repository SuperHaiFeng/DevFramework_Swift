//
//  BindingExtensions.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "验证中..."
        case let .failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0/255, green: 221.0/255, blue: 109.0/255, alpha: 1.0)
    static let errorColor = UIColor.red
}


extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
    
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult>{
        return Binder(base) { label, result in
            label.text = result.description
            label.textColor = result.textColor
        }
    }
    
}
