//
//  VideoServiceView.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/3/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoServiceView: NSObject {
    static let shared = VideoServiceView()
    
    var viewPlayer = YouTubePlayerView()
    
    override init() {
        super.init()
        viewPlayer.delegate = self
        viewPlayer.playerVars = ["playsinline": "1" as AnyObject]
    }
    
    func loadVideo(){
        viewPlayer.loadVideoURL(URL(string: "https://www.youtube.com/watch?v=ehKc-5alWek")!)
    }
}

extension VideoServiceView: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
}
