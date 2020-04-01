//
//  ZFOAuthViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/8.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import SVProgressHUD

class ZFOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        title = "登录微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "放回", image: UIImage.init(named: "back"), horizontalAlignment: .left, target: self, action: #selector(close))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(RedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest.init(url: url)
        
        webView.loadRequest(request)
        
    }
    
    @objc private func close(){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }

    
}

extension ZFOAuthViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(RedirectURI) == false{
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            close()
            return false
        }
        close()
        ///获取授权码
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        ZFNetworkManager.shared().loadAccessToken(code: code) { (isSuccess) in
            if isSuccess{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserloginSuccessNotification), object: nil)
                self.close()
            }else{
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
