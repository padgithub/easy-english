//
//  NhatVietManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import GRDBCipher

class NhatVietManager: NSObject {
    
    static let shared = NhatVietManager()
    
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: NhatVietManager.database.path, configuration: self.config)
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
        return documentsPath.appendingPathComponent("jpn_vie.db")
    }
    

    func fetchAllDataWithKeyword(_ key: String = "",_ page: Int = 0) -> [TuDienBaseObj] {
        var listData:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = key == "" ? String.init(format: "SELECT * FROM fts_main_content limit 20 OFFSET %d", key, key, page*20) : String.init(format: "SELECT * FROM fts_main_content WHERE kana like '%%%@%%' or origin like '%%%@%%' limit 20 OFFSET %d", key, key, page*20)
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

    
    func fetchAllData(_ page: Int = 0) -> [TuDienBaseObj] {
        var listData:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM fts_main_content limit 10 OFFSET %d",page*10)
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
    
    func fetchExampleWithID(_ id: Int)-> [ExampleObj] {
        var listData:[ExampleObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM examples INNER JOIN word_ex ON examples._id = word_ex.ex_id WHERE word_ex.word_id = %d",id)
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
                    "UPDATE fts_main_content set note = :i2 where docid = :i1",
                    arguments: ["i1":obj.docid,"i2":obj.note])
                print("updated")
            }
        } catch _ {
        }
    }
    
    func fetchTuLienQuan(_ kanji: String)-> [TuDienBaseObj] {
        var listData:[TuDienBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM fts_main_content where origin like '%%%@%%'",kanji)
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
}

class ExampleObj: NSObject {
    var _id: Int?
    var example: String?
    
    override init() {
        super.init()
    }
    
    init(_ data: Row) {
        _id = data["_id"]
        example = data["example"]
    }
}


