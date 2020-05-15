//
//  LocalDataHelper.swift
//  HMKFieldCollector
//
//  Created by Hoa on 11/23/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import CoreLocation

class LocalDataHelper: NSObject {
    static let shared = LocalDataHelper()
    
    var coordinate: CLLocationCoordinate2D?
    var time: Double = 0
    var isLogin: Bool = false
    var playVC = PlayVC(nibName: "PlayVC", bundle: nil)
    var handleSearchTuDien:((String,TypeListTuDien) -> Void)?
    
    override init() {
        super.init()
    }
}

let localDataShared = LocalDataHelper.shared

