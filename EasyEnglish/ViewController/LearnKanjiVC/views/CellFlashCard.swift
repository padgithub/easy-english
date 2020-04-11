//
//  CellFlashCard.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellFlashCard: UITableViewCell {

    @IBOutlet weak var viewContens: KHView!
    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
