//
//  PlaylistManager.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher
import SwiftyJSON

class PlaylistManager: NSObject {
    
    typealias SuccessHandler = (JSON) -> Void
    typealias FailureHandler = (Error) -> Void
    
    static let shareInstance = PlaylistManager()
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
    
    func fetchPlayList(category_id: Int) -> [Playlist] {
        var playlist : [Playlist] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM playlists WHERE category_id = %d ORDER BY id", category_id)
//                let query = String.init(format: "SELECT * FROM playlists")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Playlist(data: row)
                    if story.title != nil {
                        playlist.append(story)
                    }
                }
            }
        } catch _ {
        }
        return playlist
    }
    
    func fetchPlayListFevorited() -> [Playlist] {
        var playlist : [Playlist] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM playlists WHERE favorited = 1 ORDER BY id")
                //                let query = String.init(format: "SELECT * FROM playlists")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Playlist(data: row)
                    playlist.append(story)
                }
            }
        } catch _ {
        }
        return playlist
    }
    
    func addtotalResults(playlistId: String, count : Int) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE playlists set totalvideo = :i1 where playlistid = :i2",
                    arguments: ["i1":playlistId,"i2":count])
                print("updated")
            }
        } catch _ {
        }
    }
    func addfavorited(playlistId: String) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE playlists set favorited = 1 where  playlist_id = :i",
                    arguments: ["i":playlistId])
                print("added")
            }
        } catch _ {
        }
    }
    func removefavorited(playlistId: String) {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "UPDATE playlists set favorited = 0 where  playlist_id = :i",
                    arguments: ["i":playlistId])
                print("remove")
            }
        } catch _ {
        }
    }
    
    func getInfo(playlistId: String, isShowLoad : Bool, success : @escaping SuccessHandler,  failure :@escaping FailureHandler) {
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?fields=pageInfo(totalResults)&part=snippet&playlistId=\(playlistId)&key=AIzaSyCxwMR6kZROVo7_0wtw0Ax_wZ7irmKcqTY"
//        let url = "https://www.googleapis.com/youtube/v3/playlists?&part=snippet&id=\(playlistId)&key=AIzaSyCxwMR6kZROVo7_0wtw0Ax_wZ7irmKcqTY"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: isShowLoad, method: .get, isHasHeader: false, success: { (respone) in
            success(respone.responeJson)
        })
    }
}
