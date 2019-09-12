//
//  RXRegisterViewModel.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//

import RxSwift
import RxCocoa

class RXRegisterViewModel {

    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    // Is signup button enabled
    let signupEnabled: Observable<Bool>
    
    // Has user signed in
    let signedIn: Observable<Bool>
    
    // Is signing process in progress
    let signingIn: Observable<Bool>
    
    // }
    
    init(input: (
            username: Observable<String>,
            password: Observable<String>,
            repeatedPassword: Observable<String>,
            loginTaps: Observable<Void>
        ),
         dependency: (
            API: GitHubAPI,
            validationService: GitHubValidationService,
            wireframe: Wireframe
        )
    ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        /**
         Notice how no subscribe call is being made.
         Everything is just a definition.
         
         Pure transformation of input sequences to output sequences.
         */
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username: username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            }
            .share(replay: 1)
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password: password)
            }
            .share(replay: 1)
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validaterepeatedPassword)
            .share(replay: 1)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(username: pair.username, password: pair.password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
                    .trackActivity(signingIn)
            }
            .flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        loggedIn
                }
            }
            .share(replay: 1)
        
        signupEnabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn.asObservable()
        )   { username, password, repeatPassword, signingIn in
                username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
}
