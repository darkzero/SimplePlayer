//
//  ArtistViewController.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/06/16.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var artistsList:NSMutableArray;
    
//    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        self.artistsList = MusicLibrary.defaultPlayer().getiPodArtistList();
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }
    
    required init(coder aDecoder: NSCoder) {
        self.artistsList = MusicLibrary.defaultPlayer().getiPodArtistList();
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
// MARK: - CollectionView dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        NSLog("section count is %d", self.artistsList.count);
        return self.artistsList.count;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("row count is %d", self.artistsList[section].count);
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ArtistCell");
        return self.artistsList[section].count;
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var sectionHeader:UICollectionReusableView = UICollectionReusableView();
        
        if (kind == UICollectionElementKindSectionHeader) {
            sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath) as UICollectionReusableView;
            
            var collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation;
            //var sectionCount = (collation.sectionTitles as NSArray).count;
            var sectionTitle:NSString = collation.sectionTitles[indexPath.section] as NSString;
            (sectionHeader.subviews[0] as UILabel).text = sectionTitle;
        }
        
        return sectionHeader;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        NSLog("now on row %d", indexPath.row);
        let cellIdentifier = "ArtistCell"
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath:indexPath) as? UICollectionViewCell;
        
        if (cell == nil) {
            cell = UICollectionViewCell();
        }
        
        cell!.backgroundColor = UIColor.whiteColor();
        var mediaItemC: MPMediaItemCollection = ((self.artistsList[indexPath.section] as NSMutableArray)[indexPath.row]) as MPMediaItemCollection;
        var image = mediaItemC.representativeItem.artwork.imageWithSize(CGSize(width: 100, height: 100));
        cell!.backgroundView = UIImageView(image: image);
        
        if ( cell!.viewWithTag(998) == nil ) {
            var artistLabel = UILabel(frame: CGRectMake(0, 80, 100, 20));
            artistLabel.backgroundColor = UIColor(white: 0.6, alpha: 0.8);
            artistLabel.textColor = UIColor.blackColor();
            artistLabel.font = UIFont.systemFontOfSize(12.0);
            artistLabel.tag = 998;
            artistLabel.textRectForBounds(CGRectMake(10, 80, 90, 20), limitedToNumberOfLines: 1)
            cell!.contentView.addSubview(artistLabel);
        }
        (cell!.viewWithTag(998) as UILabel).text = mediaItemC.representativeItem.artist;
        
        return cell!;
    }
    
    ///
    /// CollectionView delegate
    ///
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false);
        var mediaItemC: MPMediaItemCollection = ((self.artistsList[indexPath.section] as NSMutableArray)[indexPath.row]) as MPMediaItemCollection;
        NSLog(mediaItemC.representativeItem.artist);
//        var alert:UIAlertView = UIAlertView(title: mediaItemC.representativeItem.artist, message: mediaItemC.representativeItem.albumTitle, delegate: nil, cancelButtonTitle: "Cancel");
//        alert.show();
    }
}
