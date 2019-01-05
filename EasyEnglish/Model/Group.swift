//
//  Group.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher

class Group: NSObject {
    var id = 0
    var name = ""
    var categories: [Category] = []
    var collapsed: Bool = true
    
    init(data: Row) {
        id          = data["id"]
        name       = data["name"] as! String
        categories = CategoryManager.shareInstance.fetchCategories(groupId: id)
    }
    
    override init() {
    }
}
