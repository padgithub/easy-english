//
//  VideoPlayCell.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
import Kingfisher

class VideoPlayCell: UITableViewCell {

    @IBOutlet weak var viewDuration: KHView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitleVideo: KHLabel!
    @IBOutlet weak var lbSub: KHLabel!
    @IBOutlet weak var lbDuration: KHLabel!
    @IBOutlet weak var lbViewer: KHLabel!
    
    var handleMoreOption: (() -> Void)?
    var urlString = ""
    var isHistoryView = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected { // (isSelectedCell && iss) ||
            self.lbTitleVideo.textColor = UIColor("FB3325", alpha: 1.0)
        }else{
            self.lbTitleVideo.textColor = UIColor.black
        }
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionMoreOption(_ sender: Any) {
        print("more option")
        handleMoreOption?()
    }
    
}

extension VideoPlayCell {
    func configCell(video : Items) {
        let url = video.snippet.thumbnails.medium.url
        urlString = url
        if url.count > 0 {
            self.img.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_app"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                
            }, completionHandler: { (image, error, cacheType, imageURL) in
                if image != nil && self.urlString == imageURL?.absoluteString{
                    self.img.image = image
                }
            })
        }
        lbDuration.text = video.contentDetails.duration.ISO8601DateComponents()
        let developer = video.subTitle
        let array = developer.components(separatedBy: " / ")
        lbSub.text = array[0]
        lbTitleVideo.text = video.snippet.title
        lbViewer.text = isHistoryView ? Date.init(seconds: Double(video.timeHistory)).string("dd/MM/YYYY hh:mm a") : "\(Int(video.statistics.viewCount) ?? 0 * 3) lượt xem"
        if isHistoryView {
            lbViewer.textAlignment = .right
            lbSub.text = ""
        }
        
    }
    
    func configCell(playlist : Playlist) {
        if let url = playlist.thumbnail {
            urlString = url
            if url.count > 0 {
                self.img.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_app"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                    
                }, completionHandler: { (image, error, cacheType, imageURL) in
                    if image != nil && self.urlString == imageURL?.absoluteString{
                        self.img.image = image
                    }
                })
            }
        }
        lbSub.text = ""
        lbViewer.text  = "Có \(playlist.totalVideo ?? 0) videos"
        viewDuration.isHidden = true
        lbTitleVideo.text = playlist.title
    }
}
