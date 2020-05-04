//
//  CellViduInDetail.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/29/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class CellViduInDetail: UITableViewCell {
    
    @IBOutlet weak var lblContent: RubyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setUpLabel(obj: ExampleObj) {
        let conv = converToTeex(str: obj.example?.trim() ?? "")
        print(conv)
        lblContent.text = conv  //2
        //3
        lblContent.orientation = .horizontal
        lblContent.lineBreakMode = .byWordWrapping
    }
    
    func converToTeex(str: String) -> String {
        let xuonghang = str.split(separator: "|").compactMap { (sub) -> String? in
            return String(sub)
        }
        
        if xuonghang.count == 0 {
            return ""
        }
        
        let mangtu = xuonghang[0].split(separator: "-").compactMap { (sub) -> String? in
            return String(sub)
        }

        var textcan = [String]()

        for test in mangtu {
            let ab = test.split(separator: ":").compactMap { (sub) -> String? in
                return String(sub)
            }
            
            let bb = ab[0].replacingOccurrences(of: "{", with: "｜").replacingOccurrences(of: ";", with: "《").replacingOccurrences(of: "}", with: "》")
            textcan.append(bb)
        }

        let textdung = textcan.joined() + "\n" + xuonghang[1]
        return textdung
    }
    
}
