//
//  VietNhatManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import GRDBCipher

class VietNhatManager: NSObject {
    static let shared = VietNhatManager()
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: VietNhatManager.database.path, configuration: self.config)
        } catch _ {
        }
    }
    
    let config: Configuration = {
        var config = Configuration()
        config.foreignKeysEnabled = false
        return config
    }()
    
    static var database: URL{
        let documentsPath = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return documentsPath.appendingPathComponent("vie_jpn.db")
    }
    

    func fetchAllDataWithKeyword(_ key: String = "",_ page: Int = 0) -> [TuDienBaseObj] {
        var listData:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = key == "" ? String.init(format: "SELECT * FROM main limit 20 OFFSET %d", key, key, page*20) : String.init(format: "SELECT * FROM main WHERE kana like %@ or origin like %@ limit 20 OFFSET %d", key, key, page*20)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = TuDienBaseObj(row)
                    listData.append(obj)
                }
            }
        } catch _ {
        }
        return listData
    }

    
    func fetchAllData() -> [TuDienBaseObj] {
        var listVideo:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM main")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = TuDienBaseObj(row)
                    listVideo.append(obj)
                }
            }
        } catch _ {
        }
        return listVideo
    }
    
    func updateNote(_ obj: TuDienBaseObj) {
        do {
            try dbQueues.write { db in
                try db.execute(
                    "UPDATE main set note = :i2 where _id = :i1",
                    arguments: ["i1":obj._id,"i2":obj.note])
                print("updated")
            }
        } catch _ {
        }
    }
}

class TuDienBaseObj: NSObject {
    var _id: Int?
    var docid: Int?
    var origin: String?
    var kana: String?
    var definition: String?
    var priority: String?
    var note: String?
    
    override init() {
        super.init()
    }
    
    init(_ data: Row) {
        _id = data["_id"]
        docid = data["docid"]
        origin = data["origin"]
        kana = data["kana"]
        definition = data["definition"]
        priority = data["priority"]
        note = data["note"]
    }
}
