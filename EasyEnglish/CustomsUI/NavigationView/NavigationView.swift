//
//  NotificationVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 9/6/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit
import Kingfisher

class NavigationView: UIView {
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var viewReight: UIView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var imgRight: KHImageView!
    @IBOutlet weak var imgLeft: KHImageView!
    @IBOutlet weak var ctrHeightStatusBar: NSLayoutConstraint!
    @IBOutlet weak var lbTitleNav: KHLabel!
    
    @IBInspectable open var title: String = "" {
        didSet {
            lbTitleNav.text = title.localized 
        }
    }
    
    @IBInspectable open var hasViewLeft: Bool = true {
        didSet {
            viewLeft.isHidden = !hasViewLeft
        }
    }
    
    @IBInspectable open var hasViewReight: Bool = false {
        didSet {
            viewReight.isHidden = !hasViewReight
        }
    }
    
    @IBInspectable open var hasBack: Bool = true {
        didSet {
            if hasBack {
                imgLeft.image = UIImage(named: "icon-arrow-left")
                imgLeft.contentMode = .center
            }
        }
    }
    
    @IBInspectable open var hasProfile: Bool = false {
        didSet {
            if hasProfile {
                if let image = SaveHelper.get(.fbImage) as? String, image != "" {
                    imgLeft.downloaded(from: image)
                }else{
                    imgLeft.image = randomAvatar()
                }
                imgLeft.contentMode = .scaleToFill
            }
        }
    }
    
    @IBInspectable open var hasSetting: Bool = true {
        didSet {
            if hasSetting {
                imgRight.image = UIImage(named: "settings")
            }
        }
    }
    
    @IBInspectable open var hasSearch: Bool = false {
        didSet {
            if hasSetting {
                imgRight.image = UIImage(named: "navi_search")
            }
        }
    }
    
    var handleBack: (() -> Void)?
    var handleProfile: (() -> Void)?
    var handleSetting: (() -> Void)?
    var handleSearch: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "NavigationView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for ctr in self.constraints {
            if ctr.firstAttribute == .height {
                if DeviceType.IS_IPAD {
                    ctr.constant = 85
                } else if DeviceType.IS_IPHONE_X {
                    ctr.constant = 49 + UIApplication.shared.statusBarFrame.height
                } else {
                    ctr.constant = 70*ScreenSize.SCREEN_HEIGHT/736
                }
            }
        }
        ctrHeightStatusBar.constant = UIApplication.shared.statusBarFrame.height
    }
    
    @IBAction func actionLeft(_ sender: Any) {
        if hasBack {
            handleBack?()
        }else if hasProfile {
            handleProfile?()
        }
    }
    @IBAction func actionRight(_ sender: Any) {
        if hasSetting {
            handleSetting?()
        }else if hasSearch {
            handleSearch?()
        }
    }
}

extension NavigationView {
    func randomAvatar() -> UIImage {
        let number = Int.random(in: 1 ..< 10)
        return UIImage(named: "\(number)")!
    }
}
