//
//  VideoPlayCell.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class VideoPlayCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitleVideo: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbViewer: UILabel!
    
    var handleMoreOption: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func actionMoreOption(_ sender: Any) {
        handleMoreOption?()
    }
    
}
