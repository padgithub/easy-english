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
    @IBOutlet weak var lbTitleVideo: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbViewer: UILabel!
    
    var handleMoreOption: (() -> Void)?
    var urlString = ""
    
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
        handleMoreOption?()
    }
    
}

extension VideoPlayCell {
    func configCell(video : Items) {
        let url = video.snippet.thumbnails.medium.url
        urlString = url
        if url.count > 0 {
            self.img.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_delete"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                
            }, completionHandler: { (image, error, cacheType, imageURL) in
                if image != nil && self.urlString == imageURL?.absoluteString{
                    self.img.image = image
                }
            })
        }
        lbDuration.text = video.contentDetails.duration.ISO8601DateComponents()
        lbSub.text = TAppDelegate.titleCatagory
        lbTitleVideo.text = video.snippet.title
        lbViewer.text = "\(Int(video.statistics.viewCount) ?? 0 * 3) lượt xem"
        
    }
    
    func configCell(playlist : Playlist) {
        if let url = playlist.thumbnail {
            urlString = url
            if url.count > 0 {
                self.img.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_delete"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                    
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
