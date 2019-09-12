//
//  RXGithubDefaultValidationService.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//

import RxSwift
import Foundation

class RXGithubDefaultValidationService: GitHubValidationService {
    let API: GitHubAPI
    
    static let shareValidationService = RXGithubDefaultValidationService(API: GithubDefaultAPI.shareAPI)
    
    init(API: GitHubAPI) {
        self.API = API
    }
    
    let minPasswordCount = 5
    
    
    func validateUsername(username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名可以只包含数字和字符"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return API
        .usernameAvailabel(username: username)
            .map{ available in
                if available {
                    return .ok(message: "通过验证")
                }else {
                    return .failed(message: "用户名已经被使用")
                }
        }
        .startWith(loadingValue)
        
    }
    
    func validatePassword(password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码最少是\(minPasswordCount)个字符")
        }
        
        return .ok(message: "密码验证通过")
        
    }
    
    func validaterepeatedPassword(password: String, repeadPassword: String) -> ValidationResult {
        if repeadPassword.count == 0 {
            return .empty
        }
        
        if repeadPassword == password {
            return .ok(message: "密码验证通过")
        }else {
            return .failed(message: "两次输入的密码不一致")
        }
    }

}

class GithubDefaultAPI: GitHubAPI {
    let URLSession: Foundation.URLSession
    
    static let shareAPI = GithubDefaultAPI(URLSession: Foundation.URLSession.shared)
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func usernameAvailabel(username: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request)
            .map{pair in
                return pair.response.statusCode == 404
        }
        .catchErrorJustReturn(false)
        
    }
    
    func signup(username: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult)
        .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    
}
