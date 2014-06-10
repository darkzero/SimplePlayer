//
//  AnnularProgress.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit

class AnnularProgress: UIView {

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    //
    init(outerRadius:CGFloat, innerRadius:CGFloat) {
        let frame:CGRect = CGRectMake(0, 0, outerRadius * 2.0, innerRadius * 2.0);
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
