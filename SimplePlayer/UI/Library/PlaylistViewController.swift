//
//  PlaylistViewController.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var songsTable : UITableView;
    var songsList:NSMutableArray;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.songsList = MusicLibrary.defaultPlayer().getAlliPodSongs();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        self.songsList = MusicLibrary.defaultPlayer().getAlliPodSongs();
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        //self.songsTable.reloadData();
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
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.songsList.count;
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellIdentifier = "SongCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell;
        
        if  !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier);
        }
        
        cell!.textLabel.text = self.songsList[indexPath.row].title;
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var mediaItem:MPMediaItem = self.songsList[indexPath.row] as MPMediaItem;
        
        var player = MusicPlayer.defaultPlayer();
        player.player.setQueueWithItemCollection(MPMediaItemCollection(items:self.songsList));
        player.player.nowPlayingItem = mediaItem;
        player.player.play();
        
        self.dismissModalViewControllerAnimated(true);
    }

}
