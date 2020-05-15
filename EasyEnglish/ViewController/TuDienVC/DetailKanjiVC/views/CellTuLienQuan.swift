//
//  CellTuLienQuan.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 5/15/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellTuLienQuan: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblKana: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configNhatViet(obj: TuDienBaseObj) {
        lblContent.text = obj.definition
        lblText.text = obj.origin
        lblKana.text = obj.kana
    }
    
}
