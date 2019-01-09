//
//  VideoManager.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
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
    
    func fetchVideoListDB() -> [ItemsVideo] {
        var videoItem : [ItemsVideo] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos")
                //                let query = String.init(format: "SELECT * FROM playlists")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = ItemsVideo(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func checkFavorited(videoId: String) -> Bool{
        var videoItem : [ItemsVideo] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videos where video_id = '\(videoId)' AND farvorites = 1")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = ItemsVideo(dataDB: row)
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
    
    func addVideo(videoItem: ItemsVideo) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "insert into videos (video_id,title,url) values (?,?,?)",
                    arguments: [videoItem.videoId,videoItem.title,videoItem.urlImage])
                let playerId = db.lastInsertedRowID
                print("added:\(playerId)")
            }
        } catch _ {
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
    
    func fethVideoListAPI(playlistId: String, isShowLoad : Bool, success: @escaping (JSON) -> Void) {
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistId)&key=\(apiFinalShared.keyYoutube)&maxResults=50"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: true, method: .get, isHasHeader: false) { (respone) in
            success(respone.responeJson)
        }
    }
    
    func getInfoVideo(videoId: String, isShowLoading: Bool = true, success: @escaping (Videos) -> Void) {
        let url = "https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=\(videoId.encode())&key=\(apiFinalShared.keyYoutube)"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: true, method: .get, isHasHeader: false) { (respone) in
            success(parseShared.parseListVideos(respone.responeJson))
        }
    }
    
}
