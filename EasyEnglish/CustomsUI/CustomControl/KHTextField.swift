//
//  WTextField.swift
//  Welio
//
//  Created by Hoa on 6/21/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit
private var kAssociationKeyMaxLength: Int = 0
//@IBDesignable
class KHTextField: UITextField {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = .gray {
        didSet {
            attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    @IBInspectable var placeHolderFontSize: CGFloat = 14 {
        didSet {
            attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!.localized : "", attributes:[NSAttributedString.Key.font: UIFont(name: "MyriadPro-Regular", size: placeHolderFontSize) as Any])
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var padding: CGFloat = 0.0 {
        didSet {
            if padding > 0 {
                let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: frame.size.height))
                leftView = paddingView
                leftViewMode = .always
            }
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        selectedTextRange = selection
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor,NSAttributedString.Key.font: UIFont(name: "MyriadPro-Regular", size: placeHolderFontSize) ?? UIFont.systemFont(ofSize: placeHolderFontSize)])
        self.autocorrectionType = .no
        if let realFont = font {
            font = Common.getFontForDeviceWithFontDefault(fontDefault: realFont)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor,NSAttributedString.Key.font: UIFont(name: "MyriadPro-Regular", size: placeHolderFontSize) ?? UIFont.systemFont(ofSize: placeHolderFontSize)])
        self.autocorrectionType = .no
        layoutIfNeeded()
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
