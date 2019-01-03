//
//  NotificationVC.swift
//  CarZapp
//
//  Created by Pham Khanh Hoa on 9/6/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

class TabbarView: UIView {
    var handleBack: (() -> Void)?
    var handleHome: (() -> Void)?
    var handleSearch: (() -> Void)?
    var handleMore: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "TabbarView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        handleBack?()
    }
    
    @IBAction func actionHome(_ sender: Any) {
        handleHome?()
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        handleSearch?()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        handleMore?()
    }
}
