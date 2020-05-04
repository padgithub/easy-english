//
//  NguPhapManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import GRDBCipher

class NguPhapManager: NSObject {
    static let shared = NguPhapManager()
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: NguPhapManager.database.path, configuration: self.config)
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
        return documentsPath.appendingPathComponent("grammar.db")
    }
    

    func fetchAllDataWithKeyword(_ key: String = "",_ page: Int = 0) -> [TuDienBaseObj] {
        var listData:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = key == "" ? String.init(format: "SELECT * FROM fts_main_content limit 10 OFFSET %d", key, key, page*10) : String.init(format: "SELECT * FROM fts_main_content WHERE kana like %@ or origin like %@ limit 10 OFFSET %d", key, key, page*10)
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
                let query = String.init(format: "SELECT * FROM grammar")
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
}
