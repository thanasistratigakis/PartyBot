//
//  MainViewController.swift
//  PartyBot
//
//  Created by Chase Wang on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class MainViewController: UIViewController {
    
    // MARK: - Instance Vars
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var songPlayingTitle: UILabel!
    @IBOutlet weak var artistPlayingTitle: UILabel!
    @IBOutlet weak var albumPlayingTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var player = SPTAudioStreamingController.sharedInstance()
    
    var tracks = [PBTrack]()
    
    var didRemove = false
    
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.playbackDelegate = self
        
        
        
        let ref = FIRDatabase.database().reference().child("Tracks")
        
        
        ref.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            let track = PBTrack(snapshot: snapshot)
            self.tracks.append(track)

//            let uris = self.tracks.map{$0.uri}
//            print(uris)
//            self.player.replaceURIs(uris, withCurrentTrack: 0){(error) in
//                print(error)
//            }
            self.tableView.reloadData()
        }
        
        ref.observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            self.nextSong()
        }
        
        let stateRef = FIRDatabase.database().reference().child("State")
        stateRef.observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            if(snapshot.exists()){
                if(self.player.currentTrackURI != nil){
                    self.player.setIsPlaying(snapshot.value as! Bool, callback: nil)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func pausedTapped(sender: AnyObject) {
        playButton.selected = !playButton.selected
        
        if(player.currentTrackURI == nil){
            removeTrackFromFirebase()
            playButton.selected = false
        }else{
            player.setIsPlaying(!playButton.selected, callback: nil)
            
        }
        
        FIRDatabase.database().reference().child("State").setValue(!playButton.selected)
        
    }
    
    
    func removeTrackFromFirebase(){
        if(tracks.count > 0){
            tracks[0].removeTrack()
        }
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        do{
            try player.stop()
            removeTrackFromFirebase()
        }catch{
            
        }
        
    }
    
    
    @IBAction func addSongButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("toSearch", sender: self)
    }
    
    func nextSong(){
        if(tracks.isEmpty){
            return
        }
        playSong(tracks[0].uri)
        let newTrack = tracks.removeFirst()
        songPlayingTitle.text = newTrack.title
        artistPlayingTitle.text = newTrack.artist
        albumImageView.af_setImageWithURL(NSURL(string: newTrack.album)!)
        albumPlayingTitle.text = newTrack.albumTitle
        tableView.reloadData()
        
    }
    
    func playSong(trackURIString: String) {
        
        
        guard SPTAuth.defaultInstance().session != nil &&
            SPTAuth.defaultInstance().session.isValid() else {
                return
        }
        
        let trackURI = NSURL(string:  trackURIString)!
        do {
            try player.startWithClientId(SPTAuth.defaultInstance().clientID)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        player.loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
        
        player.playURIs([trackURI], fromIndex: 0) { (error) in
            //LightHelper.flashLightsAtTempo(self.player.currentTrackDuration, id: self.parseTrackURI(trackURI))
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func parseTrackURI(uri: NSURL) -> String{
        return uri.absoluteString.componentsSeparatedByString(":").last!
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
        if (player.currentPlaybackPosition >= player.currentTrackDuration){
            print("current: \(player.currentPlaybackPosition) total: \(player.currentTrackDuration) name")
            removeTrackFromFirebase()
        }
    }
    
    
}

