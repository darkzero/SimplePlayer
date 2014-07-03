//
//  SongsViewController.swift
//  SimplePlayer
//
//  Created by Lihua Hu on 2014/07/03.
//  Copyright (c) 2014年 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var songsTable:UITableView;
    
    var itemCollection:MPMediaItemCollection!;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
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
    
    ///
    /// UITableViewDataSource
    ///
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.itemCollection.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellIdentifier = "SongCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell;
        
        if  !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier);
        }
        
        cell!.textLabel.text = (self.itemCollection.items[indexPath.row] as MPMediaItem).title;
        
        //NSLog("%@", self.playlistList[indexPath.row]);
        
        return cell;
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //var mediaItem:MPMediaItem = self.playlistList[indexPath.row] as MPMediaItem;
        
        MusicPlayer.defaultPlayer().player.setQueueWithItemCollection(self.itemCollection);
        MusicPlayer.defaultPlayer().player.play();
        
        self.dismissModalViewControllerAnimated(true);
    }

}
