//
//  Category.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher

class Category: NSObject {
    var id = 0
    var name = ""
    var group_id = 0
    var icon = ""
    var playlists: [Playlist] = []
    
    init(data: Row) {
        id         = data["id"]
        name       = data["name"] as! String
        group_id   = data["group_id"]
        icon       = data["icon"] as! String
        
    }
    
    override init() {
    }
}
