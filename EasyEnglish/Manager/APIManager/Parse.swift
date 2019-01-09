//
//  Parse.swift
//  HR
//
//  Created by Hoa on 3/28/18.
//  Copyright © 2018 SDC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Parse: NSObject {
    static let shared = Parse()
    override init() {
        super.init()
    }
    
    func parseListVideos(_ data: JSON) -> Videos {
        return Videos(data)
    }
    
}

let parseShared = Parse.shared
