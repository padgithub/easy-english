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

    
    @IBOutlet weak var btPlay: UIButton!
    let playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    let playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo(url: "https://drive.google.com/uc?export=download&id=0BzEjdSstVvybck9pSWtJQjVIeXM")
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        btPlay.addGestureRecognizer(tapGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        btPlay.addGestureRecognizer(longGesture)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
