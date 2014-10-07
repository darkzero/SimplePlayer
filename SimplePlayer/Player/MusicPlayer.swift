//
//  MusicPlayer.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/06/16.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit

import AVFoundation
import MediaPlayer

// propeties
protocol EnumProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

enum RepeatType : EnumProtocol{
    case Off, On, One;
    
    var simpleDescription: String {
        get {
            return self.getDescription()
        }
    }
    
    func getDescription() -> String{
        switch self{
        case .Off:
            return "No Repeat"
        case .On:
            return "Repeat is On"
        case .One:
            return "Repeat one song"
        default:
            return "Nothing"
        }
    }
    
    mutating func adjust() -> Void{
        self = RepeatType.Off;
    }
}

enum ShuffleMode {
    case Off, On;
}

class MusicPlayer: NSObject {
    
    var currectTime = 0.0;
    var repeat      = RepeatType.Off;
    var shuffle     = ShuffleMode.Off;
    
    var player:MPMusicPlayerController = MPMusicPlayerController.iPodMusicPlayer();
    
    required override init() {
        super.init();
        // add notifications lisener
        self.player.beginGeneratingPlaybackNotifications();
        self.registeriPodPlayerNotifications();
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    class func defaultPlayer() -> MusicPlayer {
        struct Static {
            static var instance: MusicPlayer? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = self()
        }
        
        return Static.instance!
    }
    
    func registeriPodPlayerNotifications() {
        let notiCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        notiCenter.addObserver(self,
            selector: "onRecivePlaybackStateDidChangeNotification:",
            name    : MPMusicPlayerControllerPlaybackStateDidChangeNotification,
            object  : player);
        notiCenter.addObserver(self,
            selector: "onReciveNowPlayingItemDidChangeNotification:",
            name    : MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
            object  : nil);
        notiCenter.addObserver(self,
            selector: "onReciveVolumeDidChangeNotification:",
            name    : MPMusicPlayerControllerVolumeDidChangeNotification,
            object  : nil);
    }
    
    var currentPlaybackTime : CGFloat {
    get { return CGFloat(self.player.currentPlaybackTime); }
    }
    
    var nowPlayingTitle : NSString {
    get {
        if (( self.player.nowPlayingItem ) != nil) {
            //NSLog("title : %s", self.player.nowPlayingItem.title);
            return self.player.nowPlayingItem.title;
        }
        else {
            return "";
        }
    }
    }
    
    var nowPlayingArtist : NSString {
    get {
        if (( self.player.nowPlayingItem ) != nil) {
            return self.player.nowPlayingItem.artist;
        }
        else {
            return "";
        }
    }
    }
    
    var nowPlayingArtwork : UIImage {
    get {
        if (( self.player.nowPlayingItem ) != nil) {
            var pler:MPMusicPlayerController = MPMusicPlayerController.iPodMusicPlayer();
            var item:MPMediaItem = self.player.nowPlayingItem;
            var image:UIImage = item.artwork.imageWithSize(CGSizeMake(200, 200));
            return image;
            //return MusicPlayer.defaultPlayer().player.nowPlayingItem.artwork.imageWithSize(CGSizeMake(200, 200));
            //return UIImage(named: "defaultArtwork");
        }
        else {
            return UIImage(named: "defaultArtwork");
        }
    }
    }
    
    var playbackDuration : CGFloat {
    get {
        if (( self.player.nowPlayingItem ) != nil) {
            return CGFloat(self.player.nowPlayingItem.playbackDuration);
        }
        else {
            return 0.0;
        }
    }
    }
    
    // on playback state changed
    func onRecivePlaybackStateDidChangeNotification(noti:NSNotification) {
        var userInfo:NSDictionary = NSDictionary(object: noti.name, forKey: "NotificationName");
        NSNotificationCenter.defaultCenter().postNotificationName("needRefreshPlayerViewNotification", object: self, userInfo: userInfo);
    }
    
    // on playing item changed
    func onReciveNowPlayingItemDidChangeNotification(noti:NSNotification) {
        var userInfo:NSDictionary = NSDictionary(object: noti.name, forKey: "NotificationName");
        NSNotificationCenter.defaultCenter().postNotificationName("needRefreshPlayerViewNotification", object: self, userInfo: userInfo);
    }
    
    // on volume changed
    func onReciveVolumeDidChangeNotification(noti:NSNotification) {
        var userInfo:NSDictionary = NSDictionary(object: noti.name, forKey: "NotificationName");
        NSNotificationCenter.defaultCenter().postNotificationName("needRefreshPlayerViewNotification", object: self, userInfo: userInfo);
    }
}
