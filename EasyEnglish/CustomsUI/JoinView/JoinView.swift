//
//  NotificationVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 9/6/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

class JoinView: UIView {
    @IBOutlet weak var lbTitle: KHLabel!
    
    @IBInspectable open var title: String = "" {
        didSet {
            lbTitle.text = title.localized
        }
    }
    
    @IBInspectable open var isJoin: Bool = false {
        didSet {
            if isJoin {
                lbTitle.textColor = UIColor("AE0000", alpha: 1.0)
            } else {
                lbTitle.textColor = .black
            }
        }
    }
    
    @IBInspectable open var isAddress: Bool = false {
        didSet {
            isJoin = true
            title = isAddress ? "Join Now for Full Address" : "Join Now for Details"
        }
    }
    
    @IBInspectable open var isCenter: Bool = false {
        didSet {
            if isCenter {
                lbTitle.textAlignment = .center
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "JoinView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    //Common.heightOfText(lbEmployeeNo.text ?? "a", width: lbEmployeeNo.bounds.width, font: lbEmployeeNo.font)
    override func awakeFromNib() {
        super.awakeFromNib()
        for ctr in self.constraints {
            if ctr.firstAttribute == .height {
                ctr.constant = 30*heightRatio
            }
        }
    }
    @IBAction func showJoinNow(_ sender: Any) {
//        JoinNowVC.instance().show()
    }
}
