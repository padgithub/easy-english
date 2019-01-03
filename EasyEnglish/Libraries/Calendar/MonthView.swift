//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
//    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthsArr = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
//        btnLeft.isEnabled=false
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 200).isActive=true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        btnRight.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnRight.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        btnLeft.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnLeft.heightAnchor.constraint(equalToConstant: 40).isActive=true
    }
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font=Common.getFontForDeviceWithFontDefault(fontDefault: UIFont.boldSystemFont(ofSize: 20))
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"next"), for: UIControl.State.normal)
        btn.imageView?.tintColor = UIColor.black
        btn.imageView?.contentMode = .scaleToFill
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"previous"), for: .normal)
        btn.imageView?.tintColor = UIColor.black
        btn.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

