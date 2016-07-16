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
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var songPlayingTitle: UILabel!
    @IBOutlet weak var artistPlayingTitle: UILabel!
    @IBOutlet weak var albumPlayingTitle: UILabel!
    
    var player = SPTAudioStreamingController.sharedInstance()
    
    var tracks = [PBTrack]()
    
    var currentSong = 0
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.playbackDelegate = self
        
        
        let ref = FIRDatabase.database().reference().child("Tracks")
        ref.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            self.tracks.append(PBTrack(snapshot: snapshot))
            self.tableView.reloadData()
            print(self.tracks.count)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func pausedTapped(sender: AnyObject) {
        if(tracks.count > 0){
            playSong(NSURL(string: tracks[0].uri)!)
        }
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        player.seekToOffset(207, callback: nil)
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
    }
    
    
    @IBAction func addSongButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("toSearch", sender: self)
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
            LightHelper.flashLightsAtTempo(self.player.currentTrackDuration, id: self.parseTrackURI(trackURI))
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func parseTrackURI(uri: NSURL) -> String{
        return uri.absoluteString.componentsSeparatedByString(":").last!
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trackCell") as! TrackCell
        cell.artistNameCell.text = tracks[indexPath.row].artist
        cell.songNameLabel.text = tracks[indexPath.row].title
        
        return cell
    }
}

extension MainViewController: SPTAudioStreamingPlaybackDelegate{
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        if(!isPlaying && currentSong + 1 < tracks.count - 1){
            currentSong += 1
            let track = tracks[currentSong]
            playSong(NSURL(string: track.uri)!)
            
            
        }
    }
}
