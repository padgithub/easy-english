//
//  VideoHomeCell.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds

class VideoHomeCell: UITableViewCell {

    @IBOutlet weak var contentViews: KHView!
    @IBOutlet weak var imageVideo: UIImageView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lbSub: KHLabel!
    @IBOutlet weak var lbTitleVideo: KHLabel!
    @IBOutlet weak var lbDuration: KHLabel!
    
    var bannerView: GADBannerView!
    
    var handleMoreOption: (() -> Void)?
    var urlString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionMoreOption(_ sender: Any) {
        print("more option")
        handleMoreOption?()
    }
    
}

extension VideoHomeCell {
    func configCell(obj: Items) {
        let url = obj.snippet.thumbnails.medium.url
        urlString = url
        if url.count > 0 {
            self.imageVideo.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_app"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                
            }, completionHandler: { (image, error, cacheType, imageURL) in
                if image != nil && self.urlString == imageURL?.absoluteString{
                    self.imageVideo.image = image
                }
            })
        }
        imageAvatar.image = randomAvatar()
        lbSub.text = obj.subTitle
        lbTitleVideo.text = obj.snippet.title
        lbDuration.text = obj.contentDetails.duration.ISO8601DateComponents()
        if let _ = self.bannerView {
            self.bannerView.removeFromSuperview()
        }
    }
    
    func randomAvatar() -> UIImage {
        let number = Int.random(in: 1 ..< 10)
        return UIImage(named: "\(number)")!
    }
}
