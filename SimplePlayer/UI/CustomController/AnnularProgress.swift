//
//  AnnularProgress.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit
import QuartzCore
import Darwin

let pi:CGFloat              = 3.1415926;

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
        let frame:CGRect = CGRectMake(50, 100, outerRadius * 2.0, outerRadius * 2.0);
        super.init(frame: frame);
        
        self.outerRadius = outerRadius;
        self.innerRadius = innerRadius;
        
        self.backgroundColor = UIColor.whiteColor();
        
        //println("Search iTunes API at URL \(outerRadius)")
        NSLog("%f", self.outerRadius);
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
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
        UIColor.redColor().set();
        processBackgroundPath.stroke();
        
        // draw progress
        var processPath:UIBezierPath = UIBezierPath();
        processPath.lineCapStyle = kCGLineCapButt;
        processPath.lineWidth = lineWidth;
        startAngle = -1 * (pi / 2);
        endAngle = ((self.currentValue/self.maxValue) * 2 * pi) + startAngle;
        processPath.addArcWithCenter(centerPoint, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:true);
        UIColor.whiteColor().set();
        processPath.stroke();
    }

}
