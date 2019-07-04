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
        
        loadVideo(url: "https://video.xx.fbcdn.net/v/t42.9040-2/60755725_430335767752451_5684257317810339840_n.mp4?_nc_cat=103&efg=eyJ2ZW5jb2RlX3RhZyI6InByZW11dGVfc3ZlX3NkIn0%3D&_nc_ht=video-iad3-1.xx&oh=ed5159f12df40866f68a2896fc89ba62&oe=5CDCFF18")
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

