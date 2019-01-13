//
//  VideoManager.swift
//  VuiHocTiengHan
//
//  Created by Anh Dũng on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import SwiftyJSON
import GRDBCipher
class VideoManager: NSObject {
    
    static let shareInstance = VideoManager()
    
    override init() {
        super.init()
        do {
            dbQueue = try DatabaseQueue(path: CategoryManager.database.path, configuration: self.config)
        } catch _ {
        }
    }
    
    var dbQueue: DatabaseQueue!

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
    
    func fetchVideoListDB() -> [Items] {
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos")
                //                let query = String.init(format: "SELECT * FROM playlists")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func fetchVideoListDBRanDom() -> [Items] {
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos ORDER BY RANDOM() LIMIT 20")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func checkFavorited(videoId: String) -> Bool{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where video_id = '\(videoId)' AND farvorites = 1")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
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
    
    func isExistingVideo(video: Items) -> Bool{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where video_id = '\(video.id)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
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
    
    func fetchAllFavorited() -> [Items]{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where farvorites = 1")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func fetchAllForPlaylistId(playlistId: String) -> [Items]{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where playlistId = '\(playlistId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func fetchAllForNote() -> [Items]{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where notes != ''")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func addVideo(videoItem: Items) {
        if !isExistingVideo(video: videoItem) {
            do {
                try dbQueue.inDatabase { db in
                    try db.execute(
                        "insert into videos (video_id,title,url,farvorites,notes,playlistId,timeUpdate,subTitle,duration,viewer,liker,disliker) values (:i1,:i2,:i3,:i4,:i5,:i6,:i7,:i8,:i9,:i10,:i11,:i12)",
                        arguments: ["i1":videoItem.id, "i2": videoItem.snippet.title, "i3":videoItem.snippet.thumbnails.medium.url, "i4":videoItem.farvorites, "i5":videoItem.notes, "i6":videoItem.playlistId,"i7":videoItem.timeUpdate, "i8":videoItem.subTitle,"i9":videoItem.contentDetails.duration,"i10":videoItem.statistics.viewCount,"i11":videoItem.statistics.likeCount,"i12":videoItem.statistics.dislikeCount])
                    let playerId = db.lastInsertedRowID
                    print("added:\(playerId)")
                }
            } catch _ {
            }
        }else{
            print("video tồn tại")
        }
    }
    
    func removeVideo(videoId: String) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "delete from videos where video_id = :i",
                    arguments: ["i":videoId])
                let playerId = db.lastInsertedRowID
                print("remove:\(playerId)")
            }
        } catch _ {
        }
    }
    
    func add_remove_favorited(video: Items, _ bool: Bool) {
        if bool {
            do {
                try dbQueue.inDatabase { db in
                    try db.execute(
                        "UPDATE videos set farvorites = 1 where  video_id = :i",
                        arguments: ["i":video.id])
                    print("added")
                }
            } catch _ {
            }
        }else{
            do {
                try dbQueue.inDatabase { db in
                    try db.execute(
                        "UPDATE videos set farvorites = 0 where video_id = :i",
                        arguments: ["i":video.id])
                    print("remove")
                }
            } catch _ {
            }
        }
    }
    
    func updateNotesVideo(video: Items) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE videos set notes = :i1, timeUpdate = :i3 where video_id = :i2",
                    arguments: ["i1":video.notes,"i2":video.id,"i3":video.timeUpdate])
                print("update note")
            }
        } catch _ {
        }
    }
    
    func getInfoVideoDB(video: Items) -> Items{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where video_id = '\(video.id)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        if videoItem.count != 0 {
            return videoItem[0]
        }else{
            return Items()
        }
    }
    
    func getInfoVideoDB(videoId: String) -> Items{
        var videoItem : [Items] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where video_id = '\(videoId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Items(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        if videoItem.count != 0 {
            return videoItem[0]
        }else{
            return Items()
        }
    }
    
    func fethVideoListAPI(playlistId: String, isShowLoad : Bool, success: @escaping (JSON) -> Void) {
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistId)&key=\(apiFinalShared.keyYoutube)&maxResults=50"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: isShowLoad, method: .get, isHasHeader: false) { (respone) in
            success(respone.responeJson)
        }
    }
    
    func getInfoVideo(videoId: String, isShowLoading: Bool = true, success: @escaping (Videos) -> Void) {
        let url = "https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=\(videoId.encode())&key=\(apiFinalShared.keyYoutube)"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: isShowLoading, method: .get, isHasHeader: false) { (respone) in
            success(parseShared.parseListVideos(respone.responeJson))
        }
    }
    
}
