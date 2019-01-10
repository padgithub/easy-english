//
//  ItemsVideo.swift
//  VuiHocTiengHan
//
//  Created by Mac on 9/4/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import SwiftyJSON
import GRDBCipher

class ItemsVideo : NSObject {
    var id = 0
    var title: String = ""
    var videoId: String = ""
    var urlImage : String = ""
    var width : Int = 0
    var height : Int = 0
    var duration = ""
    var desc = ""
    var playlistId : String = ""
    var isSelected : Bool = false
    
    override init() {
        super.init()
    }
    
    init(data: JSON) {
        self.title = data["snippet"]["title"].stringValue
        self.urlImage = data["snippet"]["thumbnails"]["medium"]["url"].stringValue
        self.width = data["snippet"]["thumbnails"]["medium"]["width"].intValue
        self.height = data["snippet"]["thumbnails"]["medium"]["height"].intValue
        self.videoId = data["snippet"]["resourceId"]["videoId"].stringValue
        self.playlistId = data["snippet"]["playlistId"].stringValue
    }
    
    init(dataDB : Row){
        id = dataDB["id"]
        videoId = dataDB["video_id"]
        title = dataDB["title"]
        urlImage = dataDB["url"]
    }
}

