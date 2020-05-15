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
                let query = key == "" ? String.init(format: "SELECT * FROM grammar limit 20 OFFSET %d", key, key, page*20) : String.init(format: "SELECT * FROM grammar WHERE kana like %@ or origin like %@ limit 20 OFFSET %d", key, key, page*20)
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
    
    func fetchExampleWithID(_ id: Int)-> [ExampleObj] {
        var listData:[ExampleObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM grammar INNER JOIN grammar_example ON grammar._id = grammar_example.ex_id WHERE grammar_example.word_id = %d",id)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = ExampleObj(row)
                    listData.append(obj)
                }
            }
        } catch _ {
        }
        return listData
    }
    
    func updateNote(_ obj: TuDienBaseObj) {
        do {
            try dbQueues.write { db in
                try db.execute(
                    "UPDATE grammar set note = :i2 where _id = :i1",
                    arguments: ["i1":obj._id,"i2":obj.note])
                print("updated")
            }
        } catch _ {
        }
    }
}
