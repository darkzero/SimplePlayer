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
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.artistsList = MusicLibrary.defaultPlayer().getiPodArtists();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        self.artistsList = MusicLibrary.defaultPlayer().getiPodArtists();
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
    
    // #pragma mark - Navigation
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        NSLog("row count is %d", self.artistsList.count);
        return self.artistsList.count;
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        NSLog("now on row %d", indexPath.row);
        let cellIdentifier = "ArtistCell"
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath:indexPath) as? UICollectionViewCell;
        
        if  !cell {
            cell = UICollectionViewCell();
        }
        
        //cell!.textLabel.text = self.songsList[indexPath.row].title;
        
        return cell;
    }

}
