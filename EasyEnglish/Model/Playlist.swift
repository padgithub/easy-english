//
//  Playlist.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import GRDBCipher

class Playlist: NSObject {
    var id : Int = 0
    var playlistId : String = ""
    var categoryId = 0
    var title : String? = ""
    var totalVideo : Int? = 0
    var thumbnail : String? = ""
    var favorited : Int = 0
    
    override init() {
    }
    
    init(data: Row){
        id = data["id"]
        playlistId = data["playlist_id"]
        categoryId = data["category_id"]
        title = data["name"]
        thumbnail = data["thumbnail"]
        totalVideo = data["totalvideo"]
        favorited = data["favorited"]
    }
}
