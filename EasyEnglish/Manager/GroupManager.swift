//
//  GroupManager.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher

class GroupManager: NSObject {
    static let shareInstance = GroupManager()
    var dbQueue: DatabaseQueue!
    
    override init() {
        do {
            dbQueue = try DatabaseQueue(path: GroupManager.database.path, configuration: self.config)
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
    
    func fetchGroups() -> [Group] {
        var listGroup:[Group] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM groups ORDER BY ord")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Group(data: row)
                    listGroup.append(story)
                }
            }
        } catch _ {
            
        }
        return listGroup
    }
}
