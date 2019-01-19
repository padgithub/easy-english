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
    var dbQueues: DatabaseQueue!
    
    override init() {
        do {
            dbQueues = try DatabaseQueue(path: HistoryManger.database.path, configuration: self.config)
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
        return documentsPath.appendingPathComponent("historys.db")
    }
    
    func fetchAllHistory() -> [Items] {
        var listVideo:[Items] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM historys ORDER BY createDate DESC")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = HistoryObj(data: row)
                    let video = VideoManager.shareInstance.getInfoVideoDB(videoId: story.video_id)
                    video.timeHistory = story.creatDate
                    listVideo.append(video)
                }
            }
        } catch _ {
        }
        return listVideo
    }
    
    func fetchTop10History() -> [Items] {
        var listVideo:[Items] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM historys ORDER BY createDate DESC LIMIT 10")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = HistoryObj(data: row)
                    let video = VideoManager.shareInstance.getInfoVideoDB(videoId: story.video_id)
                    video.timeHistory = story.creatDate
                    listVideo.append(video)
                }
            }
        } catch _ {
        }
        return listVideo
    }
    
    func isExistingVideo(videoId: String) -> Bool{
        var videoItem : [HistoryObj] = []
        do {
            try dbQueues.inDatabase { db in
                let query = String.init(format: "SELECT * FROM historys where video_id = '\(videoId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = HistoryObj(data: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        if videoItem.count != 0 {
            return true
        }else{
            return false
        }
    }
    
    func insertVideo(_ obj: HistoryObj) {
        do {
            try dbQueues.inDatabase { db in
                try db.execute(
                    "insert into historys (video_id,createDate) values(:i1,:i2)",
                    arguments: ["i1":obj.video_id,"i2":obj.creatDate])
                print("insert")
            }
        } catch _ {
        }
    }
    
    func updateHistory(_ obj: HistoryObj) {
        do {
            try dbQueues.inDatabase { db in
                try db.execute(
                    "UPDATE historys set createDate = :i1 where video_id = :i2",
                    arguments: ["i1":obj.creatDate,"i2":obj.video_id])
                print("updated")
            }
        } catch _ {
        }
    }
    
    func removeHistory(_ obj: Items) {
        do {
            try dbQueues.inDatabase { db in
                try db.execute(
                    "DELETE FROM historys WHERE where video_id = :i2",
                    arguments: ["i2":obj.id])
                print("delete recond")
            }
        } catch _ {
        }
    }
    
    func removeAllHistory() {
        do {
            try dbQueues.inDatabase { db in
                try db.execute(
                    "DELETE FROM historys")
                print("delete all")
            }
        } catch _ {
        }
    }

    
    func insertOrUpdate(_ obj: HistoryObj) {
        if isExistingVideo(videoId: obj.video_id) {
            updateHistory(obj)
        }else{
            insertVideo(obj)
        }
    }
}

class HistoryObj: NSObject {
    var id = 0
    var video_id = ""
    var creatDate = 0
    
    override init() {
        super.init()
    }
    
    init(data: Row) {
        id = data["id"]
        video_id = data["video_id"]
        creatDate = data["createDate"]
    }
}
