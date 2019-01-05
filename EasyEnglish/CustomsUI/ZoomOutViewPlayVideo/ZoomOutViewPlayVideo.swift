//
//  ZoomOutViewPlayVideo.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/3/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ZoomOutViewPlayVideo: UIView {
    
    @IBOutlet weak var ctrHeight: NSLayoutConstraint!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewPlayer: UIView!
    
    var isPlay: Bool = true {
        didSet{
            imgPlay.image = isPlay ? UIImage(named: "pause-button") : UIImage(named: "play-button")
        }
    }
    
    var handleReturnView:(() -> Void)?
    var handleRemoveView:(() -> Void)?
    var handlePlayPause:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSubviews() {
        let xibFileName = "ZoomOutViewPlayVideo" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        ctrHeight.constant = 85*heightRatio
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionReturnView(_ sender: Any) {
        handleReturnView?()
    }
    
    @IBAction func actionRemoveView(_ sender: Any) {
        viewYoutubePlayer.stop()
        handleRemoveView?()
    }
    
    @IBAction func actionPlayPause(_ sender: Any) {
        isPlay = !isPlay
        TAppDelegate.isPlay = !TAppDelegate.isPlay
        if !isPlay {
            viewYoutubePlayer.pause()
        }else{
            viewYoutubePlayer.play()
        }
    }
}

extension ZoomOutViewPlayVideo {
    
    func addSubViewVideo() {
        viewYoutubePlayer.translatesAutoresizingMaskIntoConstraints = false
        viewPlayer.addSubview(viewYoutubePlayer)
        frameViewPlay(viewPlayer)
    }
    
    func frameViewPlay(_ view : UIView) {
        viewYoutubePlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewYoutubePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewYoutubePlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewYoutubePlayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}
