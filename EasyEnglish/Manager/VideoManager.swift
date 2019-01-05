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
    
    func fetchVideoListDB() -> [ItemsModel] {
        var videoItem : [ItemsModel] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videofevorited")
                //                let query = String.init(format: "SELECT * FROM playlists")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = ItemsModel(dataDB: row)
                    videoItem.append(story)
                }
            }
        } catch _ {
        }
        return videoItem
    }
    
    func checkFavorited(videoId: String) -> Bool{
        var videoItem : [ItemsModel] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM videofevorited where video_id = '\(videoId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = ItemsModel(dataDB: row)
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
    
    func addfavorited(videoItem: ItemsModel) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "insert into videofevorited (video_id,title,url) values (?,?,?)",
                    arguments: [videoItem.videoId,videoItem.title,videoItem.url])
                let playerId = db.lastInsertedRowID
                print("added:\(playerId)")
            }
        } catch _ {
        }
    }
    func removefavorited(videoId: String) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "delete from videofevorited where video_id = :i",
                    arguments: ["i":videoId])
                let playerId = db.lastInsertedRowID
                print("remove:\(playerId)")
            }
        } catch _ {
        }
    }
    
    typealias SuccessHandler = (JSON) -> Void
    typealias FailureHandler = (Error) -> Void
    
//    func list_videoplaylist(playlistId: String, isShowLoad : Bool, success : @escaping SuccessHandler,  failure :@escaping FailureHandler) {
//        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistId)&key=AIzaSyCxwMR6kZROVo7_0wtw0Ax_wZ7irmKcqTY&maxResults=40"
//        WebService.shareInstance.webServiceCall(url, params: nil, isShowLoader: isShowLoad, method: .get, isHasHeader: false, success: { (respone) in
//            success(respone)
//        }) { (error) in
//            failure(error)
//        }
//    }
    
}
