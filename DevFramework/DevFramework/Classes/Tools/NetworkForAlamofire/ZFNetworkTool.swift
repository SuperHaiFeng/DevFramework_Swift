//
//  ZFNetworkTool.swift
//  DevFramework
//
//  Created by 张志方 on 2019/5/21.
//  Copyright © 2019 志方. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import HandyJSON


struct ZFNetworkTool {
    static var httpsHeaders: HTTPHeaders = ["Content-Type": "application/json"]
}

//MARK: 二次封装
extension ZFNetworkTool {
    /// 获取数据
    ///
    /// - Parameters:
    ///   - url: 路由地址
    ///   - method: 请求方式
    ///   - parameters: 参数
    ///   - returnType: 返回类型
    /// - Returns: 返回一个Rx序列
    static func fetchData<T:HandyJSON>(with url:ZFRouter, method:HTTPMethod = .get, parameters:Parameters?, returnType:T.Type) -> Observable<T> {
        return Observable<T>.create({ (observer:AnyObserver<T>) -> Disposable in
            self.request(observer: observer, url: url, method: method, parameters: parameters, retuenType: returnType)
            return Disposables.create()
        })
        
    }
    
    
    /// 上传数据
    ///
    /// - Parameters:
    ///   - url: 路由地址
    ///   - method: 请求方式
    ///   - uploadDatas: 上传数据的数组
    ///   - parameters: 参数(可以不填)
    ///   - returnType: 返回类型
    /// - Returns: 返回一个Rx序列
    static func uploadData<T:HandyJSON>(with url:ZFRouter, method:HTTPMethod, uploadDatas: [UploadData]?, parameters:Parameters? = nil, returnType:T.Type) -> Observable<T>{
        return Observable<T>.create({ (observer:AnyObserver<T>) -> Disposable in
            self.uploadRequest(observer: observer, url: url, method: method, uploadDatas: uploadDatas, parameters: parameters, returnType: returnType)
            return Disposables.create()
        })
    }
}

//MARK: 首次封装
extension ZFNetworkTool {
    /// 网络请求方法
    ///
    /// - Parameters:
    ///   - observer: Rx 观察者
    ///   - url: 路由地址
    ///   - method: 请求方式
    ///   - parameters: 参数
    ///   - returnType: 返回类型
    fileprivate static func request<T: HandyJSON>(observer:AnyObserver<T>, url:ZFRouter, method:HTTPMethod, parameters:Parameters?, retuenType: T.Type) {
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpsHeaders).responseJSON { (response) in
            switch response.result {
                case .success:
                    self.successHandle(observer: observer, result: response.result, returnType: retuenType)
                    break
                case .failure(let error):
                    self.failHandle(observer: observer, stateCode: response.response!.statusCode, error: error)
                    break
            }
        }
    }
    
    /// 上传方法
    ///
    /// - Parameters:
    ///   - observer: Rx 观察者
    ///   - url: 路由地址
    ///   - method: 请求方式
    ///   - uploadDatas: 上传的数据数组
    ///   - parameters: 参数
    ///   - returnType: 返回类型
    fileprivate static func uploadRequest<T: HandyJSON>(observer: AnyObserver<T>, url: ZFRouter, method: HTTPMethod, uploadDatas: [UploadData]?, parameters: Parameters?, returnType: T.Type) {
        Alamofire.upload(multipartFormData: { (data: MultipartFormData) in
            // Parameters
            if let parameters = parameters {
                for param in parameters {
                    let value = (param.value as! String).data(using: .utf8)
                    data.append(value!, withName: param.key)
                }
            }
            
            // uploadData
            if let toUploadDatas = uploadDatas {
                for toUploadData in toUploadDatas {
                    if let uploadData = toUploadData.data {
                        data.append(uploadData, withName: toUploadData.name!, fileName: toUploadData.fileName!, mimeType: toUploadData.mimeType!)
                    }
                }
            }
        },
                 to: url,
                 method: method,
                 headers: httpsHeaders) { (result: SessionManager.MultipartFormDataEncodingResult) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                            self.successHandle(observer: observer, result: response.result, returnType: returnType)
                        })
                        break
                        
                    case .failure(let encodingError):
                        self.failHandle(observer: observer, error: encodingError)
                        break
                    }
        }
    }
    
    fileprivate func downloadImage() {
        
    }
    
}

//MARK: 网络成功与失败的回调
extension ZFNetworkTool {
    /// 网络请求成功之后的回调
    ///
    /// - Parameters:
    ///   - observer: Rx 的观察者(传递数据)
    ///   - result: 请求结果
    ///   - retrunType: 返回值类型
    fileprivate static func successHandle<T:HandyJSON>(observer:AnyObserver<T>, result:Result<Any>, returnType:T.Type){
        guard let JSON = result.value, let jsonDic = JSON as? Dictionary<String, AnyObject> else {
            observer.onError(ZFNetError.dataJSON(errorMessage: "服务器返回的格式不是json"))
            observer.onCompleted()
            return
        }
        //jsonDic是原始数据，将其转成HandyJSON
        guard let responseModel = returnType.deserialize(from: NSDictionary(dictionary: jsonDic)) else {
            observer.onError(ZFNetError.dataMatch(errorMessage: "返回的数据不能解析"))
            observer.onCompleted()
            return
        }
        
        observer.onNext(responseModel)
        observer.onCompleted()
    }
    
    /// 网络请求失败的回调
    ///
    /// - Parameters:
    ///   - observer: Rx 的观察者
    ///   - error: 错误信息
    fileprivate static func failHandle<T:HandyJSON>(observer:AnyObserver<T>,stateCode:Int = 0, error:Error){
        observer.onError(ZFNetError.networkError(with: error as NSError))
        observer.onCompleted()
    }
}

/// 上传数据的模型
struct UploadData {
    //可以自定义
    var name: String? = "name"
    var fileName: String? = "fileName"
    var mimeType: String? = "type"
    var data: Data?
    
    init(name: String? = nil, filename: String? = nil, mimeType: String? = nil, data: Data? = nil) {
        
        if let name = name {
            self.name = name
        }
        
        if let fileName = fileName {
            self.fileName = fileName
        }
        
        if let mimeType = mimeType {
            self.mimeType = mimeType
        }
        
        if let data = data {
            self.data = data
        }
    }
}
