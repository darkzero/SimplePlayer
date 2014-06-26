//
//  MainViewController.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class MainViewController: UIViewController, ButtonMenuDelegate {
    
    @IBOutlet var songNameLabel : UILabel;
    @IBOutlet var artistNameLabel : UILabel;
    @IBOutlet var songImgBgView : UIView;
    @IBOutlet var songImgView : UIImageView;
    @IBOutlet var playPauseButton : UIButton;
    @IBOutlet var nextButton : UIButton;
    @IBOutlet var prevButton : UIButton;
    @IBOutlet var timeLabel : UILabel;
    @IBOutlet var volumeLabel : UILabel;
    
    var progress:AnnularProgress;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.progress = AnnularProgress(outerRadius: 120.0, innerRadius: 116.0);
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        self.progress = AnnularProgress(outerRadius: 125.0, innerRadius: 119.0);
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        songNameLabel.text = "test";
        
        self.view.addSubview(progress);
        
        self.progress.center        = self.songImgBgView.center;
        self.progress.maxValue      = 100.0;
        self.progress.currentValue  = 40.0;
        
        var player = MusicPlayer.defaultPlayer();
        
        let notiCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        notiCenter.addObserver(self,
            selector: "onReciveRefreshNotification:",
            name    : "needRefreshPlayerViewNotification",
            object  : nil);
        
        // round image background
        self.songImgBgView.layer.cornerRadius = songImgBgView.frame.size.width/2;
        self.songImgView.layer.cornerRadius = 100.0;
        
        // round buttons
        self.playPauseButton.layer.cornerRadius = self.playPauseButton.frame.size.width/2;
        self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width/2;
        self.prevButton.layer.cornerRadius = self.prevButton.frame.size.width/2;
        
        // start progress timer
        var progressTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateProgress", userInfo: nil, repeats: true);
        
        // songs count
        self.volumeLabel.text = "V:\(Int(MusicPlayer.defaultPlayer().player.volume*100))";
        
        // repeat mode buttons
        var repeatMenuButton = ButtonMenu(Location: ButtonMenuLocation.LeftBottom, Direction:ButtonMenuDirection.Right, CloseImage:"", OpenImage:"", TitleArray:["One", "All", "Off"]);
        self.view.addSubview(repeatMenuButton);
        repeatMenuButton.delegate = self;
        repeatMenuButton.frame = repeatMenuButton.getFrameWithLocation(repeatMenuButton.location);
        
        // shuffle mode buttons
        var shuffleMenuButton = ButtonMenu(Location: ButtonMenuLocation.RightBottom, Direction:ButtonMenuDirection.Up, CloseImage:"", OpenImage:"", TitleArray:["On", "Off"]);
        self.view.addSubview(shuffleMenuButton);
        shuffleMenuButton.delegate = self;
        shuffleMenuButton.frame = shuffleMenuButton.getFrameWithLocation(shuffleMenuButton.location);
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
    
    func drawVolumeBar() {
    }
    
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
    
    //
    func onReciveRefreshNotification(noti:NSNotification) {
        self.progress.maxValue       = MusicPlayer.defaultPlayer().playbackDuration;
        self.progress.currentValue   = MusicPlayer.defaultPlayer().currentPlaybackTime;
        
        self.songNameLabel.text = MusicPlayer.defaultPlayer().player.nowPlayingItem.title;
        self.artistNameLabel.text = MusicPlayer.defaultPlayer().player.nowPlayingItem.artist;
        
        // image
        self.songImgView.clipsToBounds = true;
        self.songImgView.contentMode = UIViewContentMode.ScaleAspectFit;
        var img = MusicPlayer.defaultPlayer().player.nowPlayingItem.artwork.imageWithSize(CGSizeMake(200, 200));
        self.songImgView.image = img
        self.songImgView.frame.size = CGSizeMake(200, 200);
        
        // volume
        self.volumeLabel.text = "V:\(Int(MusicPlayer.defaultPlayer().player.volume*100))";
    }
    
    func buttonMenu(buttonMenu:ButtonMenu, clickedButtonIndex index:Int) {
        // nothing
        NSLog("\(index)");
    }
}
