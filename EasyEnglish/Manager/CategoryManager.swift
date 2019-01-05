//
//  CategoryManager.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher

class CategoryManager: NSObject {
    static let shareInstance = CategoryManager()
    var dbQueue: DatabaseQueue!
    
    override init() {
        do {
            dbQueue = try DatabaseQueue(path: CategoryManager.database.path, configuration: self.config)
        } catch _ {
        }
    }
    
    let config: Configuration = {
        var config = Configuration()
        config.foreignKeysEnabled = true
        config.passphrase = "xemcailon"
        return config
    }()
    
    static var database: URL{
        let documentsPath = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return documentsPath.appendingPathComponent("sqlite.db")
    }
    
    func fetchCategories(groupId: Int) -> [Category] {
        var listCategory:[Category] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM categories WHERE group_id = %d ORDER BY ord", groupId)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Category(data: row)
                    listCategory.append(story)
                }
            }
        } catch _ {
        }
        return listCategory
    }
}
