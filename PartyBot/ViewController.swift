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
        
        let trackURL = NSURL(string:"spotify:track:58s6EuEYJdlb0kO7awm3Vp")!
        
        player.playURIs([trackURL], fromIndex: 0) { (error) in
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

