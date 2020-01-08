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
    var handleAutoPlay: (() -> Void)?
    var handleReadyPlay: (() -> Void)?
    
    override init() {
        super.init()
        viewPlayer.delegate = self
        if UserDefaults.standard.bool(forKey: "TOOLBARPLAY") {
            viewPlayer.playerVars = ["playsinline": "1"
                                        as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
        }else{
            viewPlayer.playerVars = ["playsinline": "1",
                                     "controls": "0"
                                        as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
        }
        viewPlayer.backgroundColor = UIColor.clear
    }
}

extension VideoServiceView: YouTubePlayerDelegate {
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
        TAppDelegate.isPlay = true
        videoPlayer.getDuration { (dura) in
            self.handleDuration?(dura ?? "")
        }
        
        Timer.every(1) {
            videoPlayer.getCurrentTime { (time) in
                videoPlayer.getDuration { (duration) in
                    self.handleCurentime?(time ?? "",duration ?? "")
                }
            }
        }
        handleReadyPlay?()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        switch playerState {
        case .playing:
            TAppDelegate.isPlay = true
        case .paused:
            if !UserDefaults.standard.bool(forKey: "TOOLBARPLAY") {
                handlePlayWhenPause?()
            }
            TAppDelegate.isPlay = false
            break
        case .ended:
            if TAppDelegate.isAutoPlay {
                TAppDelegate.indexPlaying += 1
                if TAppDelegate.indexPlaying == TAppDelegate.arrVideoPlaying.count{
                    TAppDelegate.indexPlaying = 0
                }
                viewYoutubePlayer.loadVideoID(TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id)
                handleAutoPlay?()
            }
            break
        default:
            break
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
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            TAppDelegate.indexPlaying -= 1
            if TAppDelegate.indexPlaying < 0{
                TAppDelegate.indexPlaying = 0
            }
            self.viewPlayer.loadVideoID(TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id)
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            TAppDelegate.indexPlaying -= 1
            if TAppDelegate.indexPlaying < 0{
                TAppDelegate.indexPlaying = 0
            }
            self.viewPlayer.loadVideoID(TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id)
            return .commandFailed
        }
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
