//
//  AppUpdate.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 8/5/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration

protocol AppUpdateDelegate {
    func appUpdaterDidShowUpdateDialog()
    func appUpdaterUserDidLaunchAppStore()
    func appUpdaterUserDidCancel()
    func appUpdaterHaveNotUpdate()
}

class AppUpdate: NSObject {
    static let shared = AppUpdate()
    var delegate: AppUpdateDelegate?
    var alertTitle: String = ""
    var alertMessage: String = ""
    var alertUpdateButtonTitle: String = ""
    var alertCancelButtonTitle: String = ""
    
    override init() {
        super.init()
        self.alertTitle = "New Version"
        self.alertMessage = "A new version of %@ is available than the current version of %@. Please update!"
        self.alertUpdateButtonTitle = "Update"
        self.alertCancelButtonTitle = "Not Now"
    }
    
    func showUpdateWithForce() {
        let hasConnection = self.hasConnection()
        if !hasConnection {
            return
        }
        
        checkNewAppVersion({ newVersion, version, oldVer in
            if newVersion {
                self.alertUpdate(newVer: version, currentVer: oldVer, withForce: true)
            } else {
                self.delegate?.appUpdaterHaveNotUpdate()
            }
        })
    }
    
    func showUpdateWithConfirmation() {
        let hasConnection = self.hasConnection()
        if !hasConnection {
            return
        }
        
        checkNewAppVersion({ newVersion, version, oldVer in
            if newVersion {
                self.alertUpdate(newVer: version, currentVer: oldVer, withForce: false)
            } else {
                self.delegate?.appUpdaterHaveNotUpdate()
            }
        })
    }
    
    func showUpdateWithConfirmationOnce() {
        let hasConnection = self.hasConnection()
        if !hasConnection {
            return
        }
        checkNewAppVersion({ newVersion, version, oldVer in
            if newVersion {
                let keyUD_versionPromptInfo = "versionPromptInfo"
                let keyPromptInfo_version = "version"
                let keyPromptInfo_date = "promptedAt"
                let info = UserDefaults.standard.object(forKey: keyUD_versionPromptInfo) as? [AnyHashable : Any]
                let versionPrompted = info?[keyPromptInfo_version] as? String
                
                //not showing dialog, if prompted for this version already
                let showDialog = (versionPrompted == version) ? false : true
                if showDialog {
                    self.alertUpdate(newVer: version, currentVer: oldVer, withForce: false)
                    let newInfo = [
                        keyPromptInfo_version: version ?? 0,
                        keyPromptInfo_date: Date()
                        ] as [String : Any]
                    UserDefaults.standard.set(newInfo, forKey: keyUD_versionPromptInfo)
                    UserDefaults.standard.synchronize()
                }
            } else {
                self.delegate?.appUpdaterHaveNotUpdate()
            }
        })
    }
    
    func hasConnection() -> Bool {
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
    
    var appStoreURL: String = ""
    
    func checkNewAppVersion(_ completion: @escaping (_ newVersion: Bool, _ version: String?, _ currentVer: String) -> Void) {
        let bundleInfo = Bundle.main.infoDictionary
        let bundleIdentifier = bundleInfo?["CFBundleIdentifier"] as? String
        let currentVersion = bundleInfo?["CFBundleShortVersionString"] as? String ?? ""
        let lookupURL = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier ?? "")")
        
        DispatchQueue.global(qos: .default).async(execute: {
            
            guard let lookupURL = lookupURL else {
                completion(false, nil, currentVersion)
                return
            }
            do {
                let lookupResults = try Data(contentsOf: lookupURL)
                let jsonResults = try JSON(data: lookupResults)
                DispatchQueue.main.async(execute: {
                    let resultCount = jsonResults["resultCount"].intValue
                    if resultCount != 0 {
                        let appDetails = jsonResults["results"].arrayValue.first
                        let appItunesUrl = appDetails?["trackViewUrl"].stringValue.replacingOccurrences(of: "&uo=4", with: "")
                        let latestVersion = appDetails?["version"].stringValue
                        if latestVersion?.compare(currentVersion, options: .numeric, range: nil, locale: .current) == .orderedDescending {
                            self.appStoreURL = appItunesUrl ?? ""
                            completion(true, latestVersion, currentVersion)
                        } else {
                            completion(false, nil, currentVersion)
                        }
                    } else {
                        completion(false, nil, currentVersion)
                    }
                })
            } catch {
                print(error)
                completion(false, nil, currentVersion)
                return
            }
        })
    }
    
    func alertUpdate(newVer: String?, currentVer: String, withForce force: Bool) {
        let alertMessage = String(format: self.alertMessage, newVer ?? "", currentVer)
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: alertCancelButtonTitle, style: .default, handler: { action in
            self.delegate?.appUpdaterUserDidCancel()
        })
        alert.addAction(cancelAction)
        
        if !force {
            let updateAction = UIAlertAction(title: alertUpdateButtonTitle, style: .cancel, handler: { action in
                if let url = URL(string: self.appStoreURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                self.delegate?.appUpdaterUserDidLaunchAppStore()
            })
            alert.addAction(updateAction)
        }
        if let vc = TAppDelegate.window?.rootViewController {
            vc.present(alert, animated: true, completion: {
                self.delegate?.appUpdaterDidShowUpdateDialog()
            })
        }
    }
}

