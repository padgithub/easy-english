//
//  ButtonView.swift
//  Real Estate
//
//  Created by Anh Dũng on 12/24/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class ButtonView: UIView {

    @IBOutlet weak var ctrWeight: NSLayoutConstraint!
    @IBOutlet weak var buttom: UIButton!
    
    @IBInspectable open var stype: Int = 0 {
        didSet {
            switch stype {
            case 1:
                ctrWeight.constant = 165*widthRatio
                break
            default:
                ctrWeight.constant = 200*widthRatio
                break
            }
        }
    }
    

    @IBInspectable open var title: String = "" {
        didSet {
            buttom.setTitle(title.localized, for: .normal)
        }
    }
    
    var handleAction: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "ButtonView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for ctr in self.constraints {
            if ctr.firstAttribute == .height {
               ctr.constant = 36*heightRatio
            }
        }
    }
    
    @IBAction func actionAction(_ sender: Any) {
        handleAction?()
    }
    
}
