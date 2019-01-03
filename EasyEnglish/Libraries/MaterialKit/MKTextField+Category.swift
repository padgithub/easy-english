//
//  MKTextField+Category.swift
//  Birth Announcement
//
//  Copyright © 2016 Birth Announcement. All rights reserved.
//

import Foundation
import UIKit

extension MKTextField {
    func configureTextField(){
        self.layer.borderColor = UIColor.clear.cgColor
        self.floatingPlaceholderEnabled = true
        self.rippleLocation = .right
        self.cornerRadius = 0
        self.bottomBorderEnabled = true
        self.bottomBorderColor = TColor.greenMainColor
        self.floatingLabelTextColor = TColor.greenMainColor
        self.tintColor = TColor.blackBorderTFColor
        self.bottomBorderWidth = 1
        self.bottomBorderHighlightWidth = 1.5
        self.isUserInteractionEnabled = true
    }
}
