//
//  GiaoTiepManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/8/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import Foundation
import GRDBCipher

class GiaoTiepManger: NSObject {
    static let shared = GiaoTiepManger()
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: GiaoTiepManger.database.path, configuration: self.config)
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
        return documentsPath.appendingPathComponent("giaotiep.sqlite")
    }
    
    func fetchAllGiaoTiepCategory() -> [GiaoTiepCatagoryObj] {
        var listVideo:[GiaoTiepCatagoryObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM category")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = GiaoTiepCatagoryObj(data: row)
                    listVideo.append(obj)
                }
            }
        } catch _ {
        }
        return listVideo
    }
    
    func fetchAllDataWithCatagory(_ id: Int) -> [Phrase2Obj] {
        var listVideo:[Phrase2Obj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM phrase2 WHERE category_id = %d", id)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let obj = Phrase2Obj(data: row)
                    listVideo.append(obj)
                }
            }
        } catch _ {
        }
        return listVideo
    }
}

class GiaoTiepCatagoryObj: NSObject {
    //category
    var _id = 0
    var vietnamese = ""
    var thumbnail = ""
    var english = ""
    var cate = ""
    
    override init() {
        super.init()
    }
    
    init(data: Row) {
        _id = data["_id"]
        vietnamese = data["vietnamese"]
        thumbnail = data["thumbnail"]
        english = data["english"]
        cate = data["cate"]
    }
}

class Phrase2Obj: NSObject {
    //phrase2
    var _id = 0
    var category_id = 0
    var pinyin = ""
    var japan = ""
    var voice = ""
    var favorite = 0
    var status = 0
    var vietnamese = ""
    var vnRaw = ""
    
    override init() {
        super.init()
    }
    
    init(data: Row) {
        _id = data["_id"]
        category_id = data["category_id"]
        pinyin = data["pinyin"]
        japan = data["japan"]
        voice = data["voice"]
        favorite = data["favorite"]
        status = data["status"]
        vietnamese = data["vietnamese"]
        vnRaw = data["vnRaw"]
    }
}
