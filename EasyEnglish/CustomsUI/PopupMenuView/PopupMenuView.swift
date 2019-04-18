//
//  FilterVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 7/12/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

class PopupMenuView: UIView {
    @IBOutlet weak var tbFilter: UITableView!
    @IBOutlet weak var ctrHeightViewSort: NSLayoutConstraint!
    @IBOutlet weak var postionYForTable: NSLayoutConstraint!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewBorder: UIView!
    
    var arrayTitle = [String]()
    var didDismissHandler: (() -> ())?
    var didSelectedAtIndex: ((String) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "PopupMenuView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setupView() {
        self.initUI()
        self.initData()
    }
    
    @objc func tappedOnView(sender:UITapGestureRecognizer){
        self.removeFromSuperview()
    }
}

extension PopupMenuView {
    func initUI() {
        tbFilter.separatorStyle = .none
        tbFilter.bounces = false
        viewShadow.layer.shadowOpacity = 0.6
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewShadow.layer.shadowRadius = 2.0
        viewShadow.layer.shadowColor = UIColor("7B52AB",alpha: 1.0).cgColor
        viewShadow.layer.cornerRadius = 2
        viewShadow.clipsToBounds = false

        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopupMenuView.tappedOnView(sender:)))
        tapped.numberOfTapsRequired = 1
        tapped.delegate = self
        self.addGestureRecognizer(tapped)
        
        if DeviceType.IS_IPAD {
            postionYForTable.constant = 85 + 10
        } else if DeviceType.IS_IPHONE_X {
            postionYForTable.constant = 59 + UIApplication.shared.statusBarFrame.height + 10
        } else {
            postionYForTable.constant = 75*ScreenSize.SCREEN_HEIGHT/736 + 10
        }
        tbFilter.separatorStyle = .none
    }
    
    func initData() {
        arrayTitle = ["txt_openplayer".localized, "txt_instructions".localized, "txt_settings".localized, "txt_about".localized]
        let space = ScreenSize.SCREEN_MAX_LENGTH - 20 - (50 + 79)*ScreenSize.SCREEN_MAX_LENGTH/736
        let height = CGFloat(arrayTitle.count)*(45*ScreenSize.SCREEN_MAX_LENGTH/736)
        ctrHeightViewSort.constant = (height > space) ? space : height
        tbFilter.reloadData()
    }
    
}

extension PopupMenuView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = arrayTitle[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: isIPad ? 12 : 10)
        cell.textLabel?.textColor = UIColor("522B83", alpha: 1.0)
        return cell
    }
}

extension PopupMenuView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedAtIndex?(arrayTitle[indexPath.row])
        tbFilter.deselectRow(at: indexPath, animated: true)
        self.removeFromSuperview()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10/736*ScreenSize.SCREEN_MAX_LENGTH
    }
}

extension PopupMenuView : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: tbFilter) {
            return false
        }
        return true
    }
}
