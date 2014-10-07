//
//  AlbumCover.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/10/07.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit
import QuartzCore
import Darwin
import Foundation

@IBDesignable class AlbumCover: UIView {
    
    @IBInspectable var outerRadius:CGFloat = 120.0;
    @IBInspectable var innerRadius:CGFloat = 100.0;
    
    var imageView:UIImageView;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        imageView = UIImageView();
        imageView.frame = CGRectMake(outerRadius-innerRadius, outerRadius-innerRadius, innerRadius*2, innerRadius*2);
        self.addSubview(imageView);
    }
    
    func setImage(image:UIImage) {
        imageView.image = image;
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        self.layer.cornerRadius = outerRadius;
        imageView.layer.cornerRadius = innerRadius;
    }
}