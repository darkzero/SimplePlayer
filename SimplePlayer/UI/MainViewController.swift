//
//  MainViewController.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

let REPEAT_MENU_TAG     = 1001;
let SHUFFLE_MENU_TAG    = 1002;

class MainViewController: UIViewController, ButtonMenuDelegate {
    
    @IBOutlet var songNameLabel: UILabel!;
    @IBOutlet var artistNameLabel : UILabel!;
    @IBOutlet var songImgBgView : UIView!;
    @IBOutlet var songImgView : UIImageView!;
    @IBOutlet var playPauseButton : UIButton!;
    @IBOutlet var nextButton : UIButton!;
    @IBOutlet var prevButton : UIButton!;
    @IBOutlet var timeLabel : UILabel!;
    @IBOutlet var libButton : UIButton!;
    
    var progress:AnnularProgress;
    var pauseMask:UIView!;

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.progress = AnnularProgress(outerRadius: 125.0, innerRadius: 119.0);
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        self.progress = AnnularProgress(outerRadius: 125.0, innerRadius: 119.0);
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        songNameLabel!.text = "test";
        
        self.view.addSubview(progress);
        
        self.progress.center        = self.songImgBgView!.center;
        self.progress.maxValue      = 100.0;
        self.progress.currentValue  = 0.0;
        
        var player = MusicPlayer.defaultPlayer();
        
        let notiCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        notiCenter.addObserver(self,
            selector: "onReciveRefreshNotification:",
            name    : "needRefreshPlayerViewNotification",
            object  : nil);
        
        // round image background
        self.songImgBgView!.layer.cornerRadius = self.songImgBgView!.frame.size.width/2;
        self.songImgView!.layer.cornerRadius = 100.0;
        
        // round buttons
        self.playPauseButton!.layer.cornerRadius = self.playPauseButton!.frame.size.width/2;
        self.nextButton!.layer.cornerRadius = self.nextButton!.frame.size.width/2;
        self.prevButton!.layer.cornerRadius = self.prevButton!.frame.size.width/2;
        self.libButton!.layer.cornerRadius = self.libButton!.frame.size.width/2;
        
        // start progress timer
        var progressTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateProgress", userInfo: nil, repeats: true);
        
        // repeat mode buttons
        var repeatMenuButton = ButtonMenu(Location: ButtonMenuLocation.LeftBottom, Direction:ButtonMenuDirection.Right, CloseImage:"", OpenImage:"", TitleArray:["One", "All", "Off"]);
        self.view.addSubview(repeatMenuButton);
        repeatMenuButton.delegate = self;
        repeatMenuButton.tag = REPEAT_MENU_TAG;
        repeatMenuButton.frame = repeatMenuButton.getFrameWithLocation(repeatMenuButton.location);
        
        // shuffle mode buttons
        var shuffleMenuButton = ButtonMenu(Location: ButtonMenuLocation.RightBottom, Direction:ButtonMenuDirection.Up, CloseImage:"", OpenImage:"", TitleArray:["On", "Off"]);
        self.view.addSubview(shuffleMenuButton);
        shuffleMenuButton.delegate = self;
        shuffleMenuButton.tag = SHUFFLE_MENU_TAG;
        shuffleMenuButton.frame = shuffleMenuButton.getFrameWithLocation(shuffleMenuButton.location);
        
        var repeatModeName = ["R", "Off", "One", "All"][MusicPlayer.defaultPlayer().player.repeatMode.hashValue] as NSString;
        repeatMenuButton.btnMain.setTitle(repeatModeName, forState: UIControlState.Normal);
        //repeatMenuButton.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil);
        
        var shuffleModeName = ["S", "Off", "Songs", "Albums"][MusicPlayer.defaultPlayer().player.shuffleMode.hashValue] as NSString;
        shuffleMenuButton.btnMain.setTitle(shuffleModeName, forState: UIControlState.Normal);
        //shuffleMenuButton.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil);
        
        // mask
        self.pauseMask = UIView(frame: self.songImgView.frame);
        self.pauseMask.backgroundColor = UIColor(white: 0.6, alpha: 0.6);
        self.pauseMask.layer.cornerRadius = 100.0;
        self.songImgBgView.addSubview(self.pauseMask);
        self.pauseMask.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPlayPauseButtonClicked(sender:UIButton) {
        if ( MusicPlayer.defaultPlayer().player.playbackState == MPMusicPlaybackState.Playing ) {
            MusicPlayer.defaultPlayer().player.pause();
        }
        else {
            MusicPlayer.defaultPlayer().player.play();
        }
    }
    
    @IBAction func onNextButtonClicked(sender:UIButton) {
        MusicPlayer.defaultPlayer().player.skipToNextItem();
    }
    
    @IBAction func onPrevButtonClicked(sender:UIButton) {
        MusicPlayer.defaultPlayer().player.skipToPreviousItem();
    }
    
    // MARK: - ddd
    
    func updateProgress() {
        self.progress.currentValue   = MusicPlayer.defaultPlayer().currentPlaybackTime;
        // time label
        var currectTime = UInt(MusicPlayer.defaultPlayer().currentPlaybackTime);
        var duration = UInt(MusicPlayer.defaultPlayer().playbackDuration);
        self.timeLabel.text = changeSecToMin(currectTime) + "/" + changeSecToMin(duration);
    }
    
    func changeSecToMin(second:UInt) -> NSString {
        var min = second/60;
        var sec = second%60;
        
        var minStr = format(min, f: "02");
        var secStr = format(sec, f: "02");
        
        return minStr + ":" + secStr;
    }
    
    func format(num:UInt, f: String) -> String {
        return NSString(format: "%\(f)d", num);
    }
    
    func buttonMenu(buttonMenu:ButtonMenu, clickedButtonIndex index:Int) {
        // nothing
        NSLog("\(index)");
        switch buttonMenu.tag {
        case REPEAT_MENU_TAG :
            self.changeRepeatModeTo(buttonMenu, btnIdx:index);
            break;
        case SHUFFLE_MENU_TAG :
            self.changeShuffleModeTo(buttonMenu, btnIdx:index);
            break;
        default:
            NSLog("error");
            break;
        }
        buttonMenu.hideMenuWithAnimation(true);
    }
    
    func changeRepeatModeTo(buttonMenu:ButtonMenu, btnIdx:Int) {
        switch btnIdx {
        case 1 : // One
            MusicPlayer.defaultPlayer().player.repeatMode = MPMusicRepeatMode.One;
            buttonMenu.btnMain.setTitle("One", forState: UIControlState.Normal);
            break;
        case 2 : // All
            MusicPlayer.defaultPlayer().player.repeatMode = MPMusicRepeatMode.All;
            buttonMenu.btnMain.setTitle("All", forState: UIControlState.Normal);
            break;
        case 3 : // Off
            MusicPlayer.defaultPlayer().player.repeatMode = MPMusicRepeatMode.None;
            buttonMenu.btnMain.setTitle("Off", forState: UIControlState.Normal);
            break;
        default :
            break;
        }
    }
    
    func changeShuffleModeTo(buttonMenu:ButtonMenu, btnIdx:Int) {
        switch btnIdx {
        case 1 : // On
            MusicPlayer.defaultPlayer().player.shuffleMode = MPMusicShuffleMode.Songs;
            buttonMenu.btnMain.setTitle("On", forState: UIControlState.Normal);
            buttonMenu.subviews
            break;
        case 2 : // Off
            MusicPlayer.defaultPlayer().player.shuffleMode = MPMusicShuffleMode.Off;
            buttonMenu.btnMain.setTitle("Off", forState: UIControlState.Normal);
            break;
        default :
            break;
        }
    }
    
    ///
    /// Notification listener
    ///
    
    // play state changed / playing item changed
    func onReciveRefreshNotification(noti:NSNotification) {
        self.progress.maxValue       = MusicPlayer.defaultPlayer().playbackDuration;
        self.progress.currentValue   = MusicPlayer.defaultPlayer().currentPlaybackTime;
        
        if ( noti.userInfo?["NotificationName"] as NSString == MPMusicPlayerControllerNowPlayingItemDidChangeNotification ) {
            self.songNameLabel.text = MusicPlayer.defaultPlayer().nowPlayingTitle;
            self.artistNameLabel.text = MusicPlayer.defaultPlayer().nowPlayingArtist;
            
            // image
            self.songImgView.clipsToBounds = true;
            self.songImgView.contentMode = UIViewContentMode.ScaleAspectFill;
            self.songImgView.image = MusicPlayer.defaultPlayer().nowPlayingArtwork
            self.songImgView.frame.size = CGSizeMake(200, 200);
        }
        
        if ( noti.userInfo?["NotificationName"] as NSString! == MPMusicPlayerControllerPlaybackStateDidChangeNotification ) {
            // play/pause status
            self.pauseMask.hidden = (MusicPlayer.defaultPlayer().player.playbackState == MPMusicPlaybackState.Playing);
            if ( MusicPlayer.defaultPlayer().player.playbackState == MPMusicPlaybackState.Playing ) {
                self.playPauseButton.setTitle("PAUSE", forState: UIControlState.Normal);
            }
            else {
                self.playPauseButton.setTitle("PLAY", forState: UIControlState.Normal);
            }
        }
    }

// MARK: KVO
    //override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer) {
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        NSLog("\(change)");
//        if ( keyPath == "playbackState" ) {
//            if ( object.tag == REPEAT_MENU_TAG ) {
//                
//            }
//            else if ( object.tag == SHUFFLE_MENU_TAG ) {
//                
//            }
//        }
    }
}
