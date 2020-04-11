//
//  GiaoTiepCoBanVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/7/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class GiaoTiepCoBanVC: BaseVC {
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    
    var isDetail = false
    var category = GiaoTiepCatagoryObj()
    
    var arrData = [GiaoTiepCatagoryObj]()
    var arrData2 = [Phrase2Obj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navi.handleProfile = {
            self.openMenu()
        }
        navi.handleBack = {
            self.clickBack()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellCategateGiaoTiep.self)
        if isDetail {
            navi.hasBack = true
            navi.hasProfile = false
            navi.title = category.vietnamese.uppercased()
            arrData2 = GiaoTiepManger.shared.fetchAllDataWithCatagory(category._id)
        }else{
            navi.hasBack = false
            navi.hasProfile = true
            navi.hasViewReight = false
            arrData = GiaoTiepManger.shared.fetchAllGiaoTiepCategory()
        }
        
        
        GCDCommon.mainQueue {
            AdmobManager.shared.addBannerInView(view: self.adView, inVC: self)
        }
    }
}

extension GiaoTiepCoBanVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isDetail ? arrData2.count : arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellCategateGiaoTiep
        if isDetail {
            let obj = arrData2[indexPath.row]
            cell.imgIcon.circle = false
            cell.imgIcon.image = indexPath.row % 2 == 0 ? indexPath.row % 3 == 0 ? UIImage.init(named: "enable-sound") : UIImage.init(named: "ear") : UIImage.init(named: "radio")
            cell.lblTitile.text = obj.japan
            cell.lblChild.text = "/\(obj.pinyin)/\n\n\(obj.vietnamese) "
        }else{
            let obj = arrData[indexPath.row]
            cell.imgIcon.circle = true
            cell.imgIcon.image = UIImage.init(named: obj.thumbnail)
            cell.lblTitile.text = obj.vietnamese
            cell.lblChild.text = obj.english
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDetail {
            let obj = arrData2[indexPath.row]
            SoundManager.shared.playSound(obj.voice, type: .m4a)
        }else{
            let vc = GiaoTiepCoBanVC.init()
            vc.isDetail = true
            vc.category = arrData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
