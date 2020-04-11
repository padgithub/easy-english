//
//  LearnKanjiVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class LearnKanjiVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var navi: NavigationView!
    
    var arrData = ["Kanji N5", "Kanji N4", "Kanji N3", "Kanji N2", "Kanji N1"]
    var arrTuyChon = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellFlashCard.self)
        navi.handleProfile = {
            self.openMenu()
        }
        
        GCDCommon.mainQueue {
            AdmobManager.shared.addBannerInView(view: self.adView, inVC: self)
        }
    }
}

extension LearnKanjiVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTuyChon.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = "TỔNG HỢP"
            case 1:
                sectionName = "TÙY CHỌN"
            default:
                sectionName = ""
        }
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return arrData.count
            case 1:
                return arrTuyChon.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellFlashCard
        cell.lblText.text = arrData[indexPath.row]
        cell.viewContens.backgroundColor = .random()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FlashCardVC.init()
        if indexPath.section == 0 {
            vc.level = 5 - indexPath.row
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
