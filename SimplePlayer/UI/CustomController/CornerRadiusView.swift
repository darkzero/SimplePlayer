//
//  CornerRadiusView.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/07/01.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit

@IBDesignable class CornerRadiusView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
    didSet {
        layer.borderColor = borderColor.CGColor
    }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
        layer.borderWidth = borderWidth
    }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
        layer.cornerRadius = cornerRadius
    }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
