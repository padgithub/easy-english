//
//  Define.swift
//  Carenefit
//
//  Created by Tony Tuan on 9/4/17.
//  Copyright © 2017 sdc. All rights reserved.
//

import UIKit

let isIPad = DeviceType.IS_IPAD
let heightRatio = (isIPad) ? 1.3 : ScreenSize.SCREEN_HEIGHT/736
let widthRatio = (isIPad) ? 1.4 : ScreenSize.SCREEN_WIDTH/414

class API {
    static let v1 = "/v1"
    static let act = "?act="
    static let feed = "feed"
     static let fullinfo = "fullinfo&id="
}

enum ErrorCode: String {
    case NoCode
}

enum NetworkConnection {
    case available
    case notAvailable
}

enum SaveKey: String {
    case deviceToken = "deviceToken"
    case tokenType = "tokenType"
    case accessToken = "accessToken"
    case email = "email"
    case pass = "pass"
    case isLogin = "isLogin"
    case fbImage = "fbImage"
    case fbName = "fbName"
}

enum TypeMyRife {
    case MyProgram
    case MyFrequencies
}

enum PushFrom {
    case programVC
    case frequencyVC
}

class NotificationCenterKey {
    static let SelectedMenu = "SelectedMenu"
    static let DismissAllAlert = "DismissAllAlert"
}

class TColor {
    static let purpleColor = UIColor("#522B83", alpha: 1.0)
    static let whiteColor = UIColor("#FFFFFF", alpha: 1.0)
}

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}

class FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    struct VidToLive {
        static var livePath = FilePaths.documentsPath.appending("/data/")
    }
}
