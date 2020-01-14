//
//  MenuCell.swift
//  CNPM
//
//  Created by Luy Nguyen on 12/2/18.
//  Copyright © 2018 Luy Nguyen. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var title: KHLabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MenuCell {
    func config(_ menuObj: MenuObj) {
        self.title.text = menuObj.title
        self.img.image = menuObj.img
    }
}
