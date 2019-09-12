//
//  Protocols.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//

import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message:String)
    case empty
    case validating
    case failed(message:String)
}

protocol GitHubAPI {
    func usernameAvailabel(username:String) -> Observable<Bool>
    func signup(username:String, password:String) -> Observable<Bool>
}

enum SignupState {
    case signedUp(signedUp:Bool)
}

protocol GitHubValidationService {
    func validateUsername(username:String) -> Observable<ValidationResult>
    func validatePassword(password:String) -> ValidationResult
    func validaterepeatedPassword(password:String, repeadPassword:String) -> ValidationResult
}


extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
