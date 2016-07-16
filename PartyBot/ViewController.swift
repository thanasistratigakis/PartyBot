//
//  ViewController.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/15/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var player = SPTAudioStreamingController.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SPTAuth.defaultInstance().session == nil {
            
            let vc = SPTAuthViewController.authenticationViewController()
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        search()
    }
    
    func search() {
        guard SPTAuth.defaultInstance().session != nil &&
            SPTAuth.defaultInstance().session.isValid() else {
                return
        }
        
        SPTSearch.performSearchWithQuery("kanye",
                                         queryType: SPTSearchQueryType.QueryTypeTrack,
                                         accessToken: SPTAuth.defaultInstance().session.accessToken) { (error, results) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                                return
                                            }
                                            
                                            let items = (results as! SPTListPage).items
                                            let track = items[0] as! SPTPartialTrack
                                            
                                            self.playSong(track.playableUri)
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

