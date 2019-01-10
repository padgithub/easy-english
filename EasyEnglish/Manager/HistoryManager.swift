//
//  HistoryManager.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/10/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import GRDBCipher

class HistoryManger: NSObject {
    static let shared = HistoryManger()
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
    
    func fetchHistory(groupId: Int) -> [HistoryObj] {
        var listHistory:[HistoryObj] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM categories WHERE group_id = %d ORDER BY ord", groupId)
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = HistoryObj(data: row)
                    listHistory.append(story)
                }
            }
        } catch _ {
        }
        return listHistory
    }
    
    func insertVideo(_ obj: HistoryObj) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE playlists set totalvideo = :i1 where playlistid = :i2",
                    arguments: ["i1":obj.id,"i2":obj.id])
                print("updated")
            }
        } catch _ {
        }
    }
    
    func updateVideo(_ obj: HistoryObj) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE playlists set totalvideo = :i1 where playlistid = :i2",
                    arguments: ["i1":obj.id,"i2":obj.id])
                print("updated")
            }
        } catch _ {
        }
    }
    
    func isExistVidoe(_ obj: HistoryObj) {
    
    }
}

class HistoryObj: NSObject {
    var id = 0
    var video_id = ""
    var creatDate = 0
    
    init(data: Row) {
        id = data["id"]
        video_id = data["video_id"]
        creatDate = data["creatDate"]
    }
}
