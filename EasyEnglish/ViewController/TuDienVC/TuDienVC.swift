//
//  TuDienVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/24/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit


class TuDienVC: BaseVC {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var viewTab: UIView!
    
    var arrTabSwipe = ["NHẬT VIỆT", "VIỆT NHẬT", "KANJI", "NGỮ PHÁP"]
    var indexPage = 0
    var arrController = [ListTuDienVC(),ListTuDienVC(),ListTuDienVC(),ListTuDienVC()]
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabSwipe()
        
        tfSearch.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    deinit {
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        self.openMenu()
    }
    
    @objc func textDidChange() {
        keyword = tfSearch.text ?? ""
    }
    
    func configTabSwipe() {
        let tabSwipe = CarbonTabSwipeNavigation(items: arrTabSwipe, delegate: self)

        tabSwipe.toolbar.barTintColor = UIColor.white
        tabSwipe.toolbar.isTranslucent = false
        tabSwipe.setTabExtraWidth(30)
        tabSwipe.setTabBarHeight(40)
        tabSwipe.setIndicatorColor(UIColor("F5B133", alpha: 1.0))

        let someIntToUInt: UInt = UInt(indexPage)
        tabSwipe.setCurrentTabIndex(someIntToUInt, withAnimation: false)
        tabSwipe.setNormalColor(UIColor.black,font: Common.getFontForDeviceWithFontDefault(fontDefault: UIFont(name: "HelveticaNeue-Medium", size: 15)!))
        tabSwipe.setSelectedColor(UIColor("F5B133", alpha: 1.0),font: Common.getFontForDeviceWithFontDefault(fontDefault: UIFont(name: "HelveticaNeue-Medium", size: 15)!))
        tabSwipe.insert(intoRootViewController: self, andTargetView: viewTab)
    }
}

extension TuDienVC: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let vc = arrController[Int(index)]
        vc.type = TypeListTuDien.init(rawValue: Int(index)) ?? .NhatViet
        vc.keyword = keyword
        return vc
    }
}
