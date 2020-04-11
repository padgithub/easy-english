//
//  CellCategateGiaoTiep.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/7/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellCategateGiaoTiep: UITableViewCell {

    @IBOutlet weak var lblChild: KHLabel!
    @IBOutlet weak var lblTitile: KHLabel!
    @IBOutlet weak var imgIcon: KHImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
