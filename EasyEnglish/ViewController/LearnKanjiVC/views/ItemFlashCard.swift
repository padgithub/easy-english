//
//  ItemFlashCard.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class ItemFlashCard: UICollectionViewCell {

    @IBOutlet weak var viewKanji: UIView!
    @IBOutlet weak var viewContents: KHView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblKanji: UILabel!
    
    var handleActionDetail: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func actionDetail(_ sender: Any) {
        handleActionDetail?()
    }
    
    @IBAction func actionShowDetail(_ sender: Any) {
        viewDetail.isHidden = !viewDetail.isHidden
        viewKanji.isHidden = !viewKanji.isHidden
    }
}
