//
//  Video.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Video: NSObject {
    
    var totalResults : Int = 0
    var itemVideo = [ItemsModel]()
    
    override init() {
        super.init()
    }
    init(data : JSON){
        self.totalResults = data["totalResults"].intValue
        self.itemVideo = data["items"].arrayObject as! [ItemsModel] 
    }
}
