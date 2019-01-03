//
//  TextFieldView.swift
//  Real Estate
//
//  Created by Anh Dũng on 12/24/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class TextFieldView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btAction: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBInspectable open var hasIcon: Bool = true {
        didSet {
            imgIcon.isHidden = !hasIcon
        }
    }
    
    @IBInspectable open var hasDropbox: Bool = true {
        didSet {
            btAction.isHidden = !hasDropbox
        }
    }
    
    @IBInspectable open var hasEidt: Bool = false {
        didSet {
            if hasEidt {
                imgIcon.image = UIImage(named: "search_edit")
            }else{
                imgIcon.image = UIImage(named: "search_collaps")
            }
        }
    }
    
    @IBInspectable open var tfPlaceholder: String = "" {
        didSet {
            textField.placeholder = tfPlaceholder.localized
        }
    }
    
    var handleAction: (() -> Void)?
    var handleDoneTF: ((String) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "TextFieldView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configToolbarTF()
        textField.delegate = self
    }
    
    @IBAction func actionAction(_ sender: Any) {
        handleAction?()
    }
    
    
}

extension TextFieldView {
    
    func configToolbarTF() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.barTintColor = UIColor("AE0000", alpha: 1.0)
        numberToolbar.backgroundColor = UIColor("AE0000", alpha: 1.0)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doneWithNumberPad))
        cancel.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))
        done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        numberToolbar.items = [
            cancel,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),done
            ]
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar
    }
    
    @objc func cancelNumberPad() {
        textField.endEditing(true)
    }
    
    @objc func doneWithNumberPad() {
        textField.endEditing(true)
        handleDoneTF?(textField.text ?? "")
    }
    
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        handleDoneTF?(textField.text ?? "")
        return true
    }
}
