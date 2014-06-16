//
//  MusicLibrary.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/06/16.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicLibrary: NSObject {
    
    @required init() {
        super.init();
    }
    
    class func defaultPlayer() -> MusicLibrary {
        struct Static {
            static var instance: MusicLibrary? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = self();
        }
        
        return Static.instance!
    }
    
    func getAlliPodSongs() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var allSongsQuery:MPMediaQuery = MPMediaQuery.songsQuery();
        var tempArray:NSArray = allSongsQuery.items;
        
        for item : AnyObject in tempArray {
            if ( item is MPMediaItem ) {
                let temp = item as MPMediaItem;
                if ( temp.mediaType.value != MPMediaType.Music.value ) {
                    continue;
                }
                result.addObject(item);
            }
        }
        
        return result;
    }
    
//    func getiPodPlaylists() -> NSDictoray {
//        
//    }
}
