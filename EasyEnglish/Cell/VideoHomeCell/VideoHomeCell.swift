//
//  VideoHomeCell.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class VideoHomeCell: UITableViewCell {

    @IBOutlet weak var imageVideo: UIImageView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var lbTitleVideo: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    
    var handleMoreOption: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageVideo.downloaded(from: "https://drive.google.com/uc?export=download&id=0Bz51iC-_OPfGME90OVcwWmJqMzA")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func actionMoreOption(_ sender: Any) {
         handleMoreOption?()
    }
    
}
