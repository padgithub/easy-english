//
//  CellKanjiInDetail.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/29/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellKanjiInDetail: UITableViewCell {

    @IBOutlet weak var lblNghia: KHLabel!
    @IBOutlet weak var lblHanTu: KHLabel!
    @IBOutlet weak var lblKanji: KHLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(obj: KanjiBaseObj) {
        lblKanji.text = obj.kanji
        lblNghia.text = obj.meaning
        lblHanTu.text = obj.hanviet
    }
    
    func config(obj: BoThanhPhanObj) {
        lblKanji.text = obj.radical
        lblHanTu.text = obj.hanviet
        lblNghia.text = obj.reading
    }
    
}
