//
//  MKTextField.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

//@IBDesignable
open class MKTextField : UITextField {
    
    @IBInspectable open var padding: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable open var floatingLabelBottomMargin: CGFloat = 0.0
    @IBInspectable open var floatingPlaceholderEnabled: Bool = false
    
    open var rippleLocation: MKRippleLocation = .tapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    
    @IBInspectable open var rippleAniDuration: Float = 0.75
    @IBInspectable open var backgroundAniDuration: Float = 1.0
    @IBInspectable open var shadowAniEnabled: Bool = true
    open var rippleAniTimingFunction: MKTimingFunction = .linear
    
    @IBInspectable open var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable open var rippleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(rippleLayerColor)
        }
    }
    @IBInspectable open var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    
    // floating label
    @IBInspectable open var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            floatingLabel.font = floatingLabelFont
        }
    }
    @IBInspectable open var floatingLabelTextColor: UIColor = UIColor.lightGray {
        didSet {
            floatingLabel.textColor = floatingLabelTextColor
        }
    }
    
    @IBInspectable open var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - 1, width: bounds.width, height: 1)
                bottomBorderLayer?.backgroundColor = UIColor.MKColor.Grey.cgColor
                layer.addSublayer(bottomBorderLayer!)
            }
        }
    }
    @IBInspectable open var bottomBorderWidth: CGFloat = 1.0
    @IBInspectable open var bottomBorderColor: UIColor = UIColor.lightGray
    @IBInspectable open var bottomBorderHighlightWidth: CGFloat = 1.75
    
    override open var placeholder: String? {
        didSet {
            updateFloatingLabelText()
        }
    }
    override open var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    fileprivate lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    fileprivate var floatingLabel: UILabel!
    fileprivate var closeButton: UIButton!
    fileprivate var bottomBorderLayer: CALayer?
    
    var handleShowPlaceholder: (() -> Void)?
    var handleHidePlaceholder: (() -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    fileprivate func setupLayer() {
        cornerRadius = 2.5
        layer.borderWidth = 1.0
        borderStyle = .none
        mkLayer.ripplePercent = 1.0
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(rippleLayerColor)
        
        // floating label
        floatingLabel = UILabel()
        floatingLabel.font = Common.getFontForDeviceWithFontDefault(fontDefault: floatingLabelFont)
        floatingLabel.alpha = 0.0
        updateFloatingLabelText()
        
        if let realFont = font {
            font = Common.getFontForDeviceWithFontDefault(fontDefault: realFont)
        }
        self.autocorrectionType = .no
        
        addSubview(floatingLabel)
        if DeviceType.IS_IPHONE {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done = UIBarButtonItem(title: "Ẩn", style: .done, target: self, action: #selector(doneButtonAction))
            done.tintColor = TColor.greenMainColor
            let items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)
            
            doneToolbar.items = items as? [UIBarButtonItem]
            doneToolbar.sizeToFit()
            
            self.inputAccessoryView = doneToolbar
        }
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        mkLayer.didChangeTapLocation(touch.location(in: self))
        
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.linear, duration: CFTimeInterval(self.rippleAniDuration))
        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.linear, duration: CFTimeInterval(self.backgroundAniDuration))
        
        return super.beginTracking(touch, with: event)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if !floatingPlaceholderEnabled {
            return
        }
        
        if let text = text , text.isEmpty == false {
            floatingLabel.textColor = floatingLabelTextColor
            if floatingLabel.alpha == 0 {
                showFloatingLabel()
            }
        } else {
            hideFloatingLabel()
        }
        if let txt = self.text {
            if txt.count > 0 {
                bottomBorderLayer?.backgroundColor = bottomBorderColor.cgColor
            }else {
                bottomBorderLayer?.backgroundColor = tintColor.cgColor
            }
            
        } else {
            bottomBorderLayer?.backgroundColor = tintColor.cgColor
        }
        let borderWidth = isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var newRect = CGRect(x: rect.origin.x + padding.width, y: rect.origin.y + 3,
                             width: rect.size.width - 2*padding.width, height: rect.size.height)
        
        if !floatingPlaceholderEnabled {
            return newRect
        }
        
        if let text = text , text.isEmpty == false {
//            let dTop = floatingLabel.font.lineHeight/2 + floatingLabelBottomMargin
            newRect = newRect.inset(by: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        }
        
        return newRect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

// MARK - private methods
private extension MKTextField {
    func setFloatingLabelOverlapTextField() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .center:
            originX += textRect.size.width/2 - floatingLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - floatingLabel.bounds.width
        default:
            break
        }
        floatingLabel.frame = CGRect(x: originX, y: padding.height,
                                     width: floatingLabel.frame.size.width, height: floatingLabel.frame.size.height)
    }
    
    func showFloatingLabel() {
        let curFrame = floatingLabel.frame
        floatingLabel.frame = CGRect(x: 0, y: bounds.height/2, width: curFrame.width, height: curFrame.height)
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.floatingLabel.alpha = 1.0
                        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: curFrame.width, height: curFrame.height)
        }, completion: nil)
        handleShowPlaceholder?()
    }
    
    func hideFloatingLabel() {
        floatingLabel.alpha = 0.0
        handleHidePlaceholder?()
    }
    
    func updateFloatingLabelText() {
        floatingLabel.text = placeholder
        floatingLabel.sizeToFit()
        setFloatingLabelOverlapTextField()
    }
    
    @objc func clearText() {
        hideFloatingLabel()
        bottomBorderLayer?.backgroundColor = tintColor.cgColor
        let borderWidth = isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }
}
