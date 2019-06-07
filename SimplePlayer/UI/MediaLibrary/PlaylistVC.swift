//
//  PlaylistViewController.swift
//  SimplePlayer
//
//  Created by darkzero on 14-6-11.
//  Copyright (c) 2014 darkzero. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistVC: UIViewController {

}

extension PlaylistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        // TODO:
        return cell
    }
    
    
}

extension PlaylistVC: UITableViewDelegate {
    
}
