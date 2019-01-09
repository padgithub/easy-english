//
//  API.swift
//  HMKFieldCollector
//
//  Created by Luy Nguyen on 11/21/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import Foundation

enum APIType {
    case dev, live
}

class APIFinal {
    var mainAPI: String
    
    var keyYoutube = "AIzaSyCxwMR6kZROVo7_0wtw0Ax_wZ7irmKcqTY"
    
    static let shared = APIFinal()
    
    private init() {
        mainAPI = ""
    }
    
    func config(_ type: APIType) {
        switch type {
        case .dev:
            mainAPI = ""
            break
            
        case .live:
            mainAPI = ""
            break
        }
    }
}

let apiFinalShared = APIFinal.shared
let mainAPI = apiFinalShared.mainAPI
