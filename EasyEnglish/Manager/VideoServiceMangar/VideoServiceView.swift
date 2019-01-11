//
//  VideoServiceView.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/3/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import YouTubePlayer
import AVFoundation
import MediaPlayer
import AVKit

class VideoServiceView: NSObject {
    
    static let shared = VideoServiceView()
    //
    let playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    let playerLayer = AVPlayerLayer()
    //
    var viewPlayer = YouTubePlayerView()
    var handleDuration: ((String) -> Void)?
    var handleCurentime: ((String,String) -> Void)?
    var handlePlayWhenPause: (() -> Void)?
    
    override init() {
        super.init()
        viewPlayer.delegate = self
        viewPlayer.playerVars = ["playsinline": "1",
                                 "controls": "0"
                                    as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
    }
    
    func loadVideo(){
        viewPlayer.loadVideoURL(URL(string: "https://www.youtube.com/watch?v=o6tA8CBRQ5o")!)
//        loadVideo(url: "https://www.fufanapp.com/wallpaper/wallpaper/abstract/10/video.MOV")
    }
}

extension VideoServiceView: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
        TAppDelegate.isPlay = true
        handleDuration?(videoPlayer.getDuration() ?? "")
        Timer.every(1) {
            self.handleCurentime?(videoPlayer.getCurrentTime() ?? "",videoPlayer.getDuration() ?? "")
        }
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Paused {
            handlePlayWhenPause?()
        }
    }
    
    func turnAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            self.setupRemoteTransportControls()
            try audioSession.setCategory(.playback, mode: .default, options: .allowAirPlay)
            try audioSession.setActive(true)
        }catch{
        }
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
//            if self.player.rate == 0.0 {
//                self.player.play()
//                return .success
//            }
            self.viewPlayer.play()
            TAppDelegate.isPlay = true
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
//            if self.player.rate == 1.0 {
//                self.player.pause()
//                return .success
//            }
            TAppDelegate.isPlay = false
            self.viewPlayer.pause()
            return .commandFailed
        }
        
//        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
//            return .commandFailed
//        }
//        
//        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
//            return .commandFailed
//        }
//        
    }
}

extension VideoServiceView {
    
    private func loadVideo(url: String) {
        playerViewController.player = player
        let u = URL.init(string: url)
        if u != nil {
            self.player = AVPlayer(url: u!)
            playerLayer.player = player
            playerLayer.frame = self.viewPlayer.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.zPosition = -1
            self.viewPlayer.layer.addSublayer(playerLayer)
        }
    }
    
}

let viewYoutubePlayer = VideoServiceView.shared.viewPlayer
let youtubeShare = VideoServiceView.shared