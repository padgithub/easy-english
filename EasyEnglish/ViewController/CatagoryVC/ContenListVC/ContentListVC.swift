//
//  ContentListVC.swift
//  RLEnglish
//
//  Created by Anh Dũng on 11/22/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
//import FBAudienceNetwork

class ContentListVC: BaseVC {
    
    @IBOutlet weak var baner: UIView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    var listGroup: [Group] = []
//    var adView = FBAdView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initUI() {
        isShowInterestl = false
        navi.title = "txt_catalogue".localized.uppercased()
        navi.handleSetting = {
            self.openSetting()
        }
        navi.handleProfile = {
            self.openProfile()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
//        adView = FBAdView(placementID: "335878217019048_339002996706570", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
//        baner.addSubview(adView)
//        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 90)
//        adView.delegate = self
//        adView.loadAd()
    }
    
    func initData() {
        self.listGroup = GroupManager.shareInstance.fetchGroups()
    }
}

extension ContentListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGroup[section].collapsed ? 0 : listGroup[section].categories.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item: Category = listGroup[indexPath.section].categories[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.detailLabel.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = listGroup[section].name
        header.setCollapsed(listGroup[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListPlaylistVC(nibName: "ListPlaylistVC",bundle: nil)
        vc.categories = listGroup[indexPath.section].categories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
// MARK: - Section Header Delegate
//
extension ContentListVC: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !listGroup[section].collapsed
        listGroup[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
//
//extension ContentListVC : FBAdViewDelegate {
//    func adView(_ adView: FBAdView, didFailWithError error: Error) {
//        print("Ad failed to load")
//        print(error)
//    }
//
//    func adViewDidLoad(_ adView: FBAdView) {
//        showBanner()
//    }
//    func showBanner() {
//        if (self.adView.isAdValid) {
//            self.baner.addSubview(self.adView)
//        }
//    }
//}
