//
//  MainViewController.swift
//  PartyBot
//
//  Created by Chase Wang on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    // MARK: - Instance Vars
    
    var player = SPTAudioStreamingController.sharedInstance()
    
    var tracks = [PBTrack]()
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("Tracks")
        ref.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            self.tracks.append(PBTrack(snapshot: snapshot))
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addSongButtonTapped(sender: UIButton) {
    
    }
    
    func playSong(trackURI: NSURL) {
        guard SPTAuth.defaultInstance().session != nil &&
            SPTAuth.defaultInstance().session.isValid() else {
                return
        }
        
        do {
            try player.startWithClientId(SPTAuth.defaultInstance().clientID)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        player.loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
        
        player.playURIs([trackURI], fromIndex: 0) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
