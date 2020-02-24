//
//  PlaylistManager.swift
//  VuiHocTiengHan
//
//  Created by Anh Dũng on 9/3/18.
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
        config.passphrase = "phanhoangtao"
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
    
    func isExistingPlaylist(playlist: Playlist) -> Bool{
        var playlistItem : [Playlist] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM playlists where playlist_id = '\(playlist.playlistId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Playlist(data: row)
                    playlistItem.append(story)
                }
            }
        } catch _ {
        }
        if playlistItem.count != 0 {
            return true
        }else{
            return false
        }
    }
    
    func checkFavorite(playlist: Playlist) -> Bool{
        var playlistItem : [Playlist] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM playlists where playlist_id = '\(playlist.playlistId)' AND favorited = 1")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Playlist(data: row)
                    playlistItem.append(story)
                }
            }
        } catch _ {
        }
        if playlistItem.count != 0 {
            return true
        }else{
            return false
        }
    }
    
    func getInfoPlaylistDB(playlistId: String) -> Playlist{
        var plsItem : [Playlist] = []
        do {
            try dbQueue.inDatabase { db in
                let query = String.init(format: "SELECT * FROM playlists where playlist_id = '\(playlistId)'")
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let story = Playlist(data: row)
                    plsItem.append(story)
                }
            }
        } catch _ {
        }
        if plsItem.count != 0 {
            return plsItem[0]
        }else{
            return Playlist()
        }
    }
    
    func insert_update_playlist(obj: Playlist) {
        if isExistingPlaylist(playlist: obj) {
            do {
                try dbQueue.inDatabase { db in
                    try db.execute(
                        "UPDATE playlists set name = :i1,thumbnail = :i2, totalvideo = :i3 where playlist_id = :i",
                        arguments: ["i":obj.playlistId,"i1":obj.title,"i2":obj.thumbnail,"i3":obj.totalVideo])
                    print("update: \(obj.playlistId)")
                }
            } catch _ {
            }
        }else{
            do {
                try dbQueue.inDatabase { db in
                    try db.execute(
                        "insert into playlists (playlist_id,category_id,favorited,name,thumbnail,totalvideo) values (:i1,:i2,:i3,:i4,:i5)",
                        arguments: [ "i1":obj.playlistId, "i2":obj.categoryId, "i3":obj.categoryId, "i4":obj.thumbnail, "i5":obj.totalVideo])
                    let playerId = db.lastInsertedRowID
                    print("added:\(playerId)")
                }
            } catch _ {
            }
        }
    }
}
