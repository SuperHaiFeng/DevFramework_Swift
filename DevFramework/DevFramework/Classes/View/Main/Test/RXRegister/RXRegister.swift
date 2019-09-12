//
//  RXRegister.swift
//  DevFramework
//
//  Created by 张志方 on 2019/4/24.
//  Copyright © 2019 志方. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RXRegister: ViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameError: UILabel!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var pwdError: UILabel!
    @IBOutlet weak var repwdTF: UITextField!
    @IBOutlet weak var repwdError: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = RXRegisterViewModel(
            input: (
                username: userNameTF.rx.text.orEmpty.asObservable(),
                password: pwdTF.rx.text.orEmpty.asObservable(),
                repeatedPassword: repwdTF.rx.text.orEmpty.asObservable(),
                loginTaps: commitBtn.rx.tap.asObservable()
            ),
            dependency: (
                    API: GithubDefaultAPI.shareAPI,
                    validationService: RXGithubDefaultValidationService.shareValidationService,
                    wireframe: DefaultWireframe.shared)
        )
        
        viewModel.signupEnabled
            .subscribe(onNext:{[weak self] valid in
                self?.commitBtn.isEnabled = valid
                self?.commitBtn.alpha = valid ? 1.0 : 0.5
            })
        .disposed(by: disposeBag)
        
        viewModel.validatedUsername
        .bind(to: userNameError.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.validatedPassword
        .bind(to: pwdError.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.validatedPasswordRepeated
        .bind(to: repwdError.rx.validationResult)
        .disposed(by: disposeBag)
        
        viewModel.signingIn
        .bind(to: indicator.rx.isAnimating)
        .disposed(by: disposeBag)
        
        viewModel.signedIn
            .subscribe(onNext: { signedIn in
                print("用户登录\(signedIn)")
            }, onError: { error in
                print("用户登录\(error)")
            })
            .disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapBackground)
    }

}
