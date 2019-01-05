//
//  WebService.swift
//  Carenefit
//
//  Created by Rio Phan on 9/14/17.
//  Copyright © 2017 sdc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration
import KRProgressHUD

class WebService: NSObject {
    static let shareInstance = WebService()
    
    var sessionManager : SessionManager? // this line
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    typealias SuccessHandler = (JSON) -> Void
    typealias FailureHandler = (Error) -> Void
    typealias SessionHandler = (Bool) -> Void
    // MARK: - Internet Connectivity
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // MARK: - Helper Methods
    
    func getHeader(_ isHasHeader : Bool) -> [String : String]? {
        if isHasHeader {
            return ["Authorization": "\(Common.getFromUserDefaults(KEY_USERDEFAULT.tokenType) as! String) \(Common.getFromUserDefaults(KEY_USERDEFAULT.accessToken) as! String)",
                    "Content-Type":"application/json"]
            //"Accept":"application/json"]
            
        }
        return nil
    }
    
    func webServiceCall(_ strURL : String, params : [String:Any]?, isShowLoader : Bool, method : HTTPMethod, isHasHeader : Bool, success : @escaping SuccessHandler,  failure :@escaping FailureHandler) {
        if isConnectedToNetwork() {
            if isShowLoader {
                KRProgressHUD.show()
            }
            sessionManager?.request(strURL, method: method, parameters: params, encoding: JSONEncoding.default, headers: getHeader(isHasHeader)).responseJSON(completionHandler: {(resObj) -> Void in
                //print(strURL)
                if params != nil {
                    print(params!)
                }
                
                if resObj.result.isSuccess {
                    let resJson = JSON(resObj.result.value!)
                    if isShowLoader {
                        KRProgressHUD.dismiss()
                    }
                    //print("success: \(resObj)")
                    if resJson["code"].intValue == ERROR_CODE.SESSION_EXPIRED {
                        if !APPDELEGATE.isShowAlertSession {
                            Common.showAlert("Đã hết phiên làm việc. Vui lòng thử lại")
                            APPDELEGATE.isShowAlertSession = true
                        }
                    }else{
                        success(resJson)
                    }
                }
                if resObj.result.isFailure {
                    let error : Error = resObj.result.error!
                    print("error: \(error) \((error as NSError).code == -1005)")
                    if (error as NSError).code == -1005 {
                        self.webServiceCall(strURL, params: params, isShowLoader: isShowLoader, method: method, isHasHeader: true, success: { (respone) in
                            if isShowLoader {
                                KRProgressHUD.dismiss()
                            }
                            success(respone)
                        }, failure: { (error) in
                            if isShowLoader {
                                Common.showAlert("Không thể kết nối đến hệ thống. Vui lòng thử lại")
                                KRProgressHUD.dismiss()
                            }
                            failure(error)
                        })
                    }else{
                        if isShowLoader {
                            Common.showAlert("Không thể kết nối đến hệ thống. Vui lòng thử lại")
                            KRProgressHUD.dismiss()
                        }
                        failure(error)
                    }
                }
                
            })
        }
        else {
            Common.showAlert("Không có kết nối mạng. Vui lòng kiểm tra lại")
        }
    }
}
