//
//  NotificationVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 9/6/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    
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
    
    @IBInspectable open var hasBack: Bool = true {
        didSet {
            
        }
    }
    
    var handleLeft: (() -> Void)?
    var handleRight: (() -> Void)?
    
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
        handleLeft?()
    }
    @IBAction func actionRight(_ sender: Any) {
        handleRight?()
    }
}
