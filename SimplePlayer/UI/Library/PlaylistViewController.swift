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
    
    @IBOutlet var songsTable : UITableView!;
    var playlistList:NSMutableArray;

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.playlistList = MusicLibrary.defaultPlayer().getiPodPlaylists();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        self.playlistList = MusicLibrary.defaultPlayer().getiPodPlaylists();
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistList.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SongCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell;
        
        if  (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier);
        }
        
        cell!.textLabel!.text = (self.playlistList[indexPath.row] as MPMediaPlaylist).name;
        
        //NSLog("%@", self.playlistList[indexPath.row]);
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var mediaItem:MPMediaItem = self.playlistList[indexPath.row] as MPMediaItem;
        
        var songsVC:SongsViewController = SongsViewController(nibName: "SongsViewController", bundle: nil);
        
        var mCollection:MPMediaItemCollection = self.playlistList[indexPath.row] as MPMediaItemCollection;
        songsVC.itemCollection = mCollection;
        self.navigationController?.pushViewController(songsVC, animated: true);
        
//        var player = MusicPlayer.defaultPlayer();
//        player.player.setQueueWithItemCollection(MPMediaItemCollection(items:self.getiPodPlaylists));
//        player.player.nowPlayingItem = mediaItem;
//        player.player.play();
        
        //self.dismissModalViewControllerAnimated(true);
    }

}
