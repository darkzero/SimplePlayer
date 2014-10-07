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
    
    required override init() {
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
    
    // get playlist
    func getiPodPlaylists() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var playlistQuery:MPMediaQuery = MPMediaQuery.playlistsQuery();
        playlistQuery.groupingType = MPMediaGrouping.Playlist;
        result.addObjectsFromArray(playlistQuery.collections);//MPMediaItemCollection
        
        return result;
    }
    
    // get artists list
    func getiPodArtistList() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var artistsQuery:MPMediaQuery = MPMediaQuery.artistsQuery();
        artistsQuery.groupingType = MPMediaGrouping.AlbumArtist;
        result.addObjectsFromArray(artistsQuery.collections);
        
        result = self.groupArrayByInitial(result, theSelector:"albumArtist");
        
        return result;
    }
    
    // get album list
    func getiPodAlbumList() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var artistsQuery:MPMediaQuery = MPMediaQuery.artistsQuery();
        artistsQuery.groupingType = MPMediaGrouping.Album;
        result.addObjectsFromArray(artistsQuery.collections);
        
        result = self.groupArrayByInitial(result, theSelector:"albumTitle");
        
        return result;
    }
    
    // get all songs
    func getiPodAllSongs() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var playlistQuery:MPMediaQuery = MPMediaQuery.playlistsQuery();
        playlistQuery.groupingType = MPMediaGrouping.Title;
        result.addObjectsFromArray(playlistQuery.collections);//MPMediaItemCollection
        
        result = self.groupArrayByInitial(result, theSelector:"title");
        
        return result;
    }
    
    // group by a-z
    func groupArrayByInitial(inputArray:NSMutableArray, theSelector selector:Selector) -> NSMutableArray {
        var collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation;
        var sectionCount = (collation.sectionTitles as NSArray).count;
        
        var ret:NSMutableArray = NSMutableArray.array();
        for ( var i = 0 ; i < sectionCount ; i++ ) {
            ret.addObject(NSMutableArray.array());
        }

        // TODO:
//        for (var item:MPMediaItemCollection) in inputArray as [MPMediaItemCollection] {
//            var index:NSInteger = collation.sectionForObject(item.representativeItem, collationStringSelector: selector);
//            ret.objectAtIndex(index).addObject(item);
//        }
        
        return ret;
    }
    
    // get albums list
    func getiPodAlbums() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        return result;
    }
    
    //
    func getAlliPodSongs() -> NSMutableArray {
        var result:NSMutableArray = NSMutableArray.array();
        
        var allSongsQuery:MPMediaQuery = MPMediaQuery.songsQuery();
        var tempArray:NSArray = allSongsQuery.items;
        
        for item : AnyObject in tempArray {
            if ( item is MPMediaItem ) {
                let temp = item as MPMediaItem;
                if ( temp.mediaType != MPMediaType.Music ) {
                    continue;
                }
                result.addObject(item);
            }
        }
        
        return result;
    }
}
