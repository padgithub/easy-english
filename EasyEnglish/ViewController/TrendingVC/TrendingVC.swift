//
//  TrendingVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import AVKit

class TrendingVC: BaseVC {

    
    @IBOutlet weak var navi: NavigationView!
    
    @IBOutlet weak var btPlay: UIButton!
    
    let playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    let playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

extension TrendingVC {
    func initUI(){
        navi.handleBack = {
            self.clickBack()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        btPlay.addGestureRecognizer(tapGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        btPlay.addGestureRecognizer(longGesture)
        
        loadVideo(url: "https://doc-00-18-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/a413mees0h32876oeta9i5hruc11s1n2/1551232800000/04915393280927761197/*/10TIV1W-DQYSXcMWM4d4LqYP9bw0jVn5R")
    }
    
    private func loadVideo(url: String) {
        playerViewController.player = player
        
        let u = URL.init(string: url)
        if u != nil {
            self.player = AVPlayer(url: u!)
            playerLayer.player = player
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.zPosition = -1
            self.view.layer.addSublayer(playerLayer)
        }
    }
    
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
        player?.play()
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            player?.pause()
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            player?.play()
        }
    }
    
    func loopVideo() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
}

