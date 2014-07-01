//
//  AnnularProgress.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import QuartzCore
import Darwin

let pi:CGFloat              = 3.1415926;


//@IBDesignable class CustomView : UIView {
//    @IBInspectable var borderColor: UIColor = UIColor.clearColor()
//    @IBInspectable var borderWidth: CGFloat = 0
//    @IBInspectable var cornerRadius: CGFloat = 0
//}

class AnnularProgress: UIView {
    
    var currentValue : CGFloat  = 0;
    var maxValue : CGFloat      = 0;
    
    var outerRadius:CGFloat     = 0;
    var innerRadius:CGFloat     = 0;

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    //
    init(outerRadius:CGFloat, innerRadius:CGFloat) {
        let frame:CGRect = CGRectMake(0, 0, outerRadius * 2.0, outerRadius * 2.0);
        super.init(frame: frame);
        
        self.outerRadius = outerRadius;
        self.innerRadius = innerRadius;
        
        self.backgroundColor = UIColor.clearColor();
        
        //println("Search iTunes API at URL \(outerRadius)")
        NSLog("%f", self.outerRadius);
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        // draw annular background color
        var lineWidth = self.outerRadius - self.innerRadius;
        var processBackgroundPath:UIBezierPath = UIBezierPath();
        processBackgroundPath.lineWidth = lineWidth;
        processBackgroundPath.lineCapStyle = kCGLineCapButt;
        
        var centerPoint:CGPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        var radius:CGFloat      = (self.bounds.size.width - lineWidth)/2;
        var startAngle:CGFloat  = ((self.currentValue/self.maxValue) * 2 * pi) - (pi / 2.0);
        var endAngle:CGFloat    = (2 * pi) - (pi / 2);// + startAngle;
        processBackgroundPath.addArcWithCenter(centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        UIColor.whiteColor().set();
        processBackgroundPath.stroke();
        
        // draw progress
        var processPath:UIBezierPath = UIBezierPath();
        processPath.lineCapStyle = kCGLineCapButt;
        processPath.lineWidth = lineWidth;
        startAngle = -1 * (pi / 2);
        endAngle = ((self.currentValue/self.maxValue) * 2 * pi) + startAngle;
        processPath.addArcWithCenter(centerPoint, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:true);
        UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).set();
        processPath.stroke();
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer) {
        //
        self.setNeedsDisplay();
    }
    
    override func didMoveToSuperview() {
        addObserver(self, forKeyPath: "currentValue", options: NSKeyValueObservingOptions.New|NSKeyValueObservingOptions.Old , context: nil);
        addObserver(self, forKeyPath: "maxValue", options: NSKeyValueObservingOptions.New|NSKeyValueObservingOptions.Old, context: nil);
    }

}
