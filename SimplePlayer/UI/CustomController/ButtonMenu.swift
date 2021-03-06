//
//  ButtonMenu.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/06/24.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit

let PADDING:CGFloat         = 10.0;
let BUTTON_DIAMETER:CGFloat = 40.0;
let BUTTON_PADDING:CGFloat  = 4.0;

let BUTTON_TAG_BASE:Int     = 10000;

enum ButtonMenuStatus {
    case Closed, Opened, Closing, Opening;
};

enum ButtonMenuLocation {
    case Free, LeftTop, RightTop, LeftBottom, RightBottom;
}

enum ButtonMenuDirection {
    case None, Left, Right, Up, Down;
}

protocol ButtonMenuDelegate : NSObjectProtocol {
    func buttonMenu(buttonMenu: ButtonMenu, clickedButtonIndex index: Int);
}

class ButtonMenu: UIView {
    
    var delegate:ButtonMenuDelegate!;
    
    var location:ButtonMenuLocation     = ButtonMenuLocation.LeftBottom;
    var direction:ButtonMenuDirection   = ButtonMenuDirection.Up;
    var closeImage:NSString!;
    var openImage:NSString!;
    
    var frameClose:CGRect!;
    var frameOpen:CGRect!;
    
    var status:ButtonMenuStatus = ButtonMenuStatus.Closed;
    
    var buttonCount:Int = 0;
    
    var btnMain:UIButton!;
    
    init(Location _location:ButtonMenuLocation, Direction _direction:ButtonMenuDirection, CloseImage _closeImage:NSString, OpenImage _openImage:NSString, TitleArray _titleArray:NSArray) {
        // init with parameter
        super.init(frame:CGRect.zeroRect);
        //self.frame = getFrameWithLocation(location);
        self.backgroundColor = UIColor.clearColor();
        
        self.location = _location;
        self.direction = _direction;
        self.closeImage = _closeImage;
        if ( _openImage.length > 0 ) {
            self.openImage = _openImage;
        }
        else {
            self.openImage = _closeImage;
        }
        
        self.buttonCount = _titleArray.count;
        
        // create buttons
        for var i = 0 ; i < _titleArray.count ; i++ {
            var s:NSString      = _titleArray[i] as NSString;
            var btn:UIButton    = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
            btn.frame = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
            btn.backgroundColor = UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 0.6);
            btn.setTitle(s, forState: UIControlState.Normal);
            btn.layer.cornerRadius = BUTTON_DIAMETER/2;
            btn.tag = BUTTON_TAG_BASE+i+1;
            btn.alpha = 0.0;
            self.addSubview(btn);
            
            btn.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside);
        }
        // main button
        self.createMainButtonCloseImage(_closeImage, OpenImage:_openImage);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFrameWithLocation(location:ButtonMenuLocation) -> CGRect {
        var rect:CGRect;
        switch location {
            case ButtonMenuLocation.RightBottom:
                rect = CGRect(
                    x: self.superview!.frame.size.width-BUTTON_DIAMETER-PADDING,
                    y: self.superview!.frame.size.height - BUTTON_DIAMETER - PADDING,
                    width: BUTTON_DIAMETER,
                    height: BUTTON_DIAMETER);
                break;
            case ButtonMenuLocation.LeftBottom:
                rect = CGRect(
                    x: PADDING,
                    y: self.superview!.frame.size.height - BUTTON_DIAMETER - PADDING,
                    width: BUTTON_DIAMETER,
                    height: BUTTON_DIAMETER);
                break;
            case ButtonMenuLocation.LeftTop:
                rect = CGRect(
                    x: PADDING,
                    y: PADDING,
                    width: BUTTON_DIAMETER,
                    height: BUTTON_DIAMETER);
                break;
            case ButtonMenuLocation.RightTop:
                rect = CGRect(
                    x: self.superview!.frame.size.width-BUTTON_DIAMETER-PADDING,
                    y: PADDING,
                    width: BUTTON_DIAMETER,
                    height: BUTTON_DIAMETER);
                break;
            default:
                rect = CGRect(
                    x: PADDING,
                    y: self.superview!.frame.size.height - BUTTON_DIAMETER - PADDING,
                    width: BUTTON_DIAMETER,
                    height: BUTTON_DIAMETER);
                break;
        }
        return rect;
    }
    
    func createMainButtonCloseImage(_closeImage:NSString, OpenImage _openImage:NSString) {
        self.btnMain = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        self.btnMain.frame = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
        self.btnMain.backgroundColor = UIColor.grayColor();
        
        self.btnMain.setTitle("▲", forState: UIControlState.Normal);
        self.btnMain.tag = BUTTON_TAG_BASE;
        self.btnMain.layer.cornerRadius = BUTTON_DIAMETER/2;
        self.addSubview(self.btnMain);
        
        self.btnMain.addTarget(self, action: "switchMenuStatus", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func switchMenuStatus() {
        if (self.status == ButtonMenuStatus.Closed)
        {
            self.showMenuWithAnimation(true);
        }
        else if (self.status == ButtonMenuStatus.Opened)
        {
            self.hideMenuWithAnimation(true);
        }
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        //[self setBackgroundColor:[UIColor greenColor]];
        self.frame = getFrameWithLocation(self.location);
        self.frameClose = self.frame;
        
        // calc frame of open
        switch self.direction {
            case ButtonMenuDirection.Left:
                //
                self.frameOpen = CGRectMake(
                    self.frame.origin.x - BUTTON_DIAMETER*CGFloat(self.buttonCount) - BUTTON_PADDING*CGFloat(self.buttonCount),
                    self.frame.origin.y,
                    BUTTON_DIAMETER*CGFloat(self.buttonCount+1) + BUTTON_PADDING*CGFloat(self.buttonCount),
                    BUTTON_DIAMETER);
                break;
            case ButtonMenuDirection.Right:
                //
                self.frameOpen = CGRectMake(
                    self.frame.origin.x,
                    self.frame.origin.y,
                    BUTTON_DIAMETER*CGFloat(self.buttonCount+1) + BUTTON_PADDING*CGFloat(self.buttonCount),
                    BUTTON_DIAMETER);
                break;
            case ButtonMenuDirection.Down:
                //
                self.frameOpen = CGRectMake(
                    self.frame.origin.x,
                    self.frame.origin.y,
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER*CGFloat(self.buttonCount+1) + BUTTON_PADDING*CGFloat(self.buttonCount));
                break;
            case ButtonMenuDirection.Up:
                //
                self.frameOpen = CGRectMake(
                    self.frame.origin.x,
                    self.frame.origin.y - BUTTON_DIAMETER*CGFloat(self.buttonCount) - BUTTON_PADDING*CGFloat(self.buttonCount),
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER*CGFloat(self.buttonCount+1)+BUTTON_PADDING*CGFloat(self.buttonCount));
                break;
            default:
                //
                self.frameOpen = CGRectMake(
                    self.frame.origin.x,
                    self.frame.origin.y - BUTTON_DIAMETER*CGFloat(self.buttonCount) - BUTTON_PADDING*CGFloat(self.buttonCount),
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER*CGFloat(self.buttonCount+1) + BUTTON_PADDING*CGFloat(self.buttonCount));
                break;
        }
    }
    
    func showMenuWithAnimation(animation:Bool) {
        //NSNotificationCenter.defaultCenter().postNotificationName("buttonMenuOpeningNotification", object: self);
        self.status = ButtonMenuStatus.Opening;
        
        UIView.beginAnimations("showMenuWithAnimation", context: nil);
        UIView.setAnimationDelegate(self);
        UIView.setAnimationDidStopSelector("afterShow");
        UIView.setAnimationDuration(0.7);
        
        self.frame = self.frameOpen;
        
        for (var subview:UIView) in self.subviews as [UIView] {
            var tag = subview.tag;
            var targetFrame:CGRect = self.calcButtonFrame(tag-BUTTON_TAG_BASE);
            subview.frame = targetFrame;
            subview.alpha = 1.0;
        }
        UIView.commitAnimations();
    }
    
    func afterShow() {
        self.status = ButtonMenuStatus.Opened;
    }
    
    func hideMenuWithAnimation(animation:Bool) {
        //NSNotificationCenter.defaultCenter().postNotificationName("buttonMenuClosingNotification", object: self);
        self.status = ButtonMenuStatus.Closing;
        
        UIView.beginAnimations("showMenuWithAnimation", context: nil);
        UIView.setAnimationDelegate(self);
        UIView.setAnimationDidStopSelector("afterHide");
        UIView.setAnimationDuration(0.7);
        
        self.frame = self.frameClose;
        
        for subview:UIView in self.subviews as [UIView] {
            var tag = subview.tag;
            var targetFrame:CGRect = CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height);
            subview.frame = targetFrame;
            if subview.tag != BUTTON_TAG_BASE {
                subview.alpha = 0.0;
            }
        }
        UIView.commitAnimations();
        
    }
    
    func afterHide() {
        self.status = ButtonMenuStatus.Closed;
    }
    
    func calcButtonFrame(index:NSInteger) -> CGRect {
        var ret:CGRect = CGRect.zeroRect;
        switch self.direction {
            case ButtonMenuDirection.Left:
                ret = CGRectMake(
                    self.frame.size.width - CGFloat(index+1)*BUTTON_DIAMETER - CGFloat(index)*BUTTON_PADDING,
                    self.frame.size.height - BUTTON_DIAMETER,
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER);
                break;
            case ButtonMenuDirection.Right:
                ret = CGRectMake(
                    self.frame.size.width - CGFloat(self.buttonCount-index+1)*BUTTON_DIAMETER - CGFloat(self.buttonCount-index)*BUTTON_PADDING,
                    self.frame.size.height - BUTTON_DIAMETER,
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER);
                break;
            case ButtonMenuDirection.Up:
                ret = CGRectMake(
                    self.frame.size.width - BUTTON_DIAMETER,
                    self.frame.size.height - CGFloat(index+1)*BUTTON_DIAMETER - CGFloat(index)*BUTTON_PADDING,
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER);
                break;
            case ButtonMenuDirection.Down:
                ret = CGRectMake(
                    self.frame.size.width - BUTTON_DIAMETER,
                    self.frame.size.height - CGFloat(self.buttonCount-index+1)*BUTTON_DIAMETER - CGFloat(self.buttonCount-index)*BUTTON_PADDING,
                    BUTTON_DIAMETER,
                    BUTTON_DIAMETER);
                break;
            default:
                break;
        }
        
        return ret;
    }
    
    // delegate
    func buttonClicked(sender:UIButton) {
        if self.delegate.respondsToSelector("buttonMenu:clickedButtonIndex:") {
            delegate.buttonMenu(self, clickedButtonIndex:sender.tag - BUTTON_TAG_BASE);
        }
    }
}
