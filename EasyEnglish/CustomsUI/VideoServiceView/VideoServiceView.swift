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
    var handleDuration: ((String) -> Void)?
    var handleCurentime: ((String,String) -> Void)?
    
    override init() {
        super.init()
        viewPlayer.delegate = self
        viewPlayer.playerVars = ["playsinline": "1",
                                 "controls": "0"
                                    as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
    }
    
    func loadVideo(){
        viewPlayer.loadVideoURL(URL(string: "https://www.youtube.com/watch?v=o6tA8CBRQ5o")!)
    }
}

extension VideoServiceView: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
        handleDuration?(videoPlayer.getDuration() ?? "")
        Timer.every(1) {
            self.handleCurentime?(videoPlayer.getCurrentTime() ?? "",videoPlayer.getDuration() ?? "")
        }
    }
}
