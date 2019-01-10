//
//  NotificationVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 9/6/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

class ToolBarView: UIView {
    @IBOutlet weak var bgReight: UIImageView!
    @IBOutlet weak var bgLeft: UIImageView!
    @IBOutlet weak var buttonG2Left: KHButton!
    @IBOutlet weak var buttonG2Right: KHButton!
    @IBInspectable open var titleG2Left: String = "" {
        didSet {
            buttonG2Left.setTitle(titleG2Left.localized, for: .normal)
        }
    }
    
    @IBInspectable open var titleG2Right: String = "" {
        didSet {
            buttonG2Right.setTitle(titleG2Right.localized, for: .normal)
        }
    }
    
    @IBInspectable open var indexSelected: Int = 0 {
        didSet {
            switch indexSelected {
            case 0:
                bgReight.image = UIImage(named: "ic_list")
                bgLeft.image = UIImage(named: "bg")
                buttonG2Left.setTitleColor(.white, for: .normal)
                buttonG2Right.setTitleColor(UIColor.lightGray, for: .normal)
                break
            default:
                bgReight.image = UIImage(named: "bg")
                bgLeft.image = UIImage(named: "ic_list")
                buttonG2Right.setTitleColor(.white, for: .normal)
                buttonG2Left.setTitleColor(UIColor.lightGray, for: .normal)
                break
            }
        }
    }
    
    var handleActionG2Left: (() -> Void)?
    var handleActionG2Right: (() -> Void)?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "ToolBarView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for ctr in self.constraints {
            if ctr.firstAttribute == .height {
                if DeviceType.IS_IPAD {
                    ctr.constant = 75
                } else {
                    ctr.constant = 60*ScreenSize.SCREEN_HEIGHT/736
                }
            }
            print(ctr.constant)
        }
    }
    
    @IBAction func actionG2Left(_ sender: Any) {
        indexSelected = 0
        handleActionG2Left?()
    }
    
    @IBAction func actionG2Right(_ sender: Any) {
        indexSelected = 1
        handleActionG2Right?()
    }
}
