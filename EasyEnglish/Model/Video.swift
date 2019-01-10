//
//  Video.swift
//  VuiHocTiengHan
//
//  Created by Phu Phan on 9/3/18.
//  Copyright © 2018 Phu Phan. All rights reserved.
//

import UIKit
import SwiftyJSON
import GRDBCipher

class Video: NSObject {
    
    var totalResults : Int = 0
    var itemVideo = [ItemsVideo]()
    
    override init() {
        super.init()
    }
    
    init(data : JSON){
        self.totalResults = data["totalResults"].intValue
        self.itemVideo = data["items"].arrayObject as! [ItemsVideo]
    }
    
}

class Videos: NSObject {
    var kind = ""
    var etag = ""
    var pageInfo = PageInfo()
    var items = [Items]()
    
    override init() {
        super.init()
    }

    init(_ data: JSON) {
        self.kind = data["kind"].stringValue
        self.etag = data["etag"].stringValue
        self.pageInfo = PageInfo(data["pageInfo"])
        for item in data["items"].arrayValue {
            let items = Items(item)
            self.items.append(items)
        }
    }
}

class Items: NSObject {
    //DB
    var idDB = 0
    var playlistId = ""
    var notes = ""
    var farvorites = 0
    var timeUpdate = Date().secondsSince1970
    var subTitle = ""
    //
    var kind = ""
    var etag = ""
    var id = ""
    var snippet = Snippet()
    var contentDetails = ContentDetails()
    var statistics = Statistics()
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.kind = data["kind"].stringValue
        self.etag = data["etag"].stringValue
        self.id = data["id"].stringValue
        self.snippet = Snippet(data["snippet"])
        self.contentDetails = ContentDetails(data["contentDetails"])
        self.statistics = Statistics(data["statistics"])
    }
    
    init(dataDB : Row){
        idDB = dataDB["id"]
        id = dataDB["video_id"]
        snippet.title = dataDB["title"]
        snippet.thumbnails.medium.url = dataDB["url"]
        playlistId = dataDB["playlistId"]
        notes = dataDB["notes"]
        farvorites = dataDB["farvorites"]
        timeUpdate = dataDB["timeUpdate"]
        subTitle = dataDB["subTitle"]
        contentDetails.duration = dataDB["duration"]
        statistics.viewCount = dataDB["viewer"]
        statistics.likeCount = dataDB["liker"]
        statistics.dislikeCount = dataDB["disliker"]
    }
}

class ContentDetails: NSObject {
    var duration = ""
    var dimension = ""
    var definition = ""
    var caption = ""
    var licensedContent = false
    var projection = ""
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.duration = data["duration"].stringValue
        self.dimension = data["dimension"].stringValue
        self.definition = data["definition"].stringValue
        self.caption = data["caption"].stringValue
        self.licensedContent = data["licensedContent"].boolValue
        self.projection = data["projection"].stringValue
    }
}

class Snippet: NSObject {
    var publishedAt = ""
    var channelId = ""
    var title = ""
    var decs = ""
    var thumbnails = Thumbnails()
    var channelTitle = ""
    var tags: [String]?
    var categoryId = ""
    var liveBroadcastContent = ""
    var localized = Localized()
    var defaultAudioLanguage = ""
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.publishedAt = data["publishedAt"].stringValue
        self.channelId = data["channelId"].stringValue
        self.title = data["title"].stringValue
        self.decs = data["description"].stringValue
        self.thumbnails = Thumbnails(data["thumbnails"])
        self.channelTitle = data["channelTitle"].stringValue
        self.tags = data["tags"].arrayObject as? [String]
        self.categoryId = data["categoryId"].stringValue
        self.liveBroadcastContent = data["liveBroadcastContent"].stringValue
        self.localized = Localized(data["localized"])
        self.defaultAudioLanguage = data["defaultAudioLanguage"].stringValue
    }
}

class Localized: NSObject {
    var title = ""
    var decs = ""
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.title = data["title"].stringValue
        self.decs = data["description"].stringValue
    }
}

class Thumbnails: NSObject {
    var thumbnailsDefault = Default()
    var medium = Default()
    var high = Default()
    var standard = Default()
    var maxres = Default()
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.thumbnailsDefault = Default(data["thumbnailsDefault"])
        self.medium = Default(data["medium"])
        self.high = Default(data["high"])
        self.standard = Default(data["standard"])
        self.maxres = Default(data["maxres"])
    }
}

class Default: NSObject {
    var url = ""
    var width = 0
    var height = 0
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.url = data["url"].stringValue
        self.width = data["width"].intValue
        self.height = data["height"].intValue
    }
}

class Statistics: NSObject {
    var viewCount = ""
    var likeCount = ""
    var dislikeCount = ""
    var favoriteCount = ""
    var commentCount = ""
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.viewCount = data["viewCount"].stringValue
        self.likeCount = data["likeCount"].stringValue
        self.dislikeCount = data["dislikeCount"].stringValue
        self.favoriteCount = data["favoriteCount"].stringValue
        self.commentCount = data["commentCount"].stringValue
    }
    
}

class PageInfo: NSObject {
    var totalResults = 0
    var resultsPerPage = 0
    
    override init() {
        super.init()
    }
    
    init(_ data: JSON) {
        self.totalResults = data["totalResults"].intValue
        self.resultsPerPage = data["resultsPerPage"].intValue
    }
}
