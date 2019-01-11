//
//  NotesCell.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/11/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import Kingfisher

class NotesCell: UITableViewCell {

    @IBOutlet weak var lbNotes: KHLabel!
    @IBOutlet weak var lbTitle: KHLabel!
    @IBOutlet weak var imageVideo: UIImageView!
    
    var urlString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NotesCell {
    func configCell(_ obj: Items) {
        lbTitle.text = obj.snippet.title
        lbNotes.text = obj.notes
        let url = obj.snippet.thumbnails.medium.url
        urlString = url
        if url.count > 0 {
            self.imageVideo.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "ic_delete"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                
            }, completionHandler: { (image, error, cacheType, imageURL) in
                if image != nil && self.urlString == imageURL?.absoluteString{
                    self.imageVideo.image = image
                }
            })
        }
    }
}
