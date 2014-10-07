//
//  DismissSegue.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/07/16.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    /*- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
*/
    override func perform() {
        var sourceViewController:UIViewController = self.sourceViewController as UIViewController;
        sourceViewController.presentingViewController?.dismissViewControllerAnimated(true, completion:nil);
    }
}
