//
//  KanjiManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import GRDBCipher

class KanjiManager: NSObject {
    static let shared = KanjiManager()
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: KanjiManager.database.path, configuration: self.config)
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
        return documentsPath.appendingPathComponent("kanji.db")
    }

    
    func fetchAllDataWithLevel(_ level: Int) -> [KanjiBaseObj] {
        var listVideo:[KanjiBaseObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM kanji_base WHERE level = %d", level)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = KanjiBaseObj(row)
                    listVideo.append(obj)
                }
            }
        } catch _ {
        }
        return listVideo
    }
}

class KanjiBaseObj: NSObject {
    var _id = 0
    var kanji = ""
    var hanviet = ""
    var radical = ""
    var stroke = 0
    var onyomi = ""
    var level = 0
    var kunyomi = ""
    var meaning = ""
    var freq = 0
    
    override init() {
        super.init()
    }
    
    init(_ data: Row) {
        _id = data["_id"]
        kanji = data["kanji"]
        hanviet = data["hanviet"]
        radical = data["radical"]
        stroke = data["stroke"]
        onyomi = data["onyomi"]
        level = data["level"]
        kunyomi = data["kunyomi"]
        meaning = data["meaning"]
        freq = data["freq"]
    }
}

