//
//  ViewController.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/15/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var player = SPTAudioStreamingController.sharedInstance()

    var tracks = [PBTrack]()
    
    var authViewController: SPTAuthViewController!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("Tracks")
        ref.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            self.tracks.append(PBTrack(snapshot: snapshot))
        }
        
        authViewController = SPTAuthViewController.authenticationViewController()
        authViewController.delegate = self
        presentViewController(authViewController, animated: false, completion: nil)
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

extension ViewController: SPTAuthViewDelegate {
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        print("logged in")
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("canceled login")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("failed login")
    }
}

