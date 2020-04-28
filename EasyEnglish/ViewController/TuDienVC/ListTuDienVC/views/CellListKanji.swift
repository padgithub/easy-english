//
//  CellListKanji.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellListKanji: UITableViewCell {

    @IBOutlet weak var lbl: KHLabel!
    @IBOutlet weak var lblAm: KHLabel!
    @IBOutlet weak var lblMoTa: KHLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(obj: KanjiBaseObj) {
        lbl.text = obj.kanji
        lblAm.text = obj.hanviet
        lblMoTa.text = obj.meaning
    }
}
