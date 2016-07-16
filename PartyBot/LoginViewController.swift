//
//  ViewController.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/15/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Instance Vars
    
    var authViewController: SPTAuthViewController!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor()
        
        authViewController = SPTAuthViewController.authenticationViewController()
        authViewController.delegate = self
        presentViewController(authViewController, animated: false, completion: nil)
    }
}

extension LoginViewController: SPTAuthViewDelegate {
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        performSegueWithIdentifier("toQueue", sender: self)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("canceled login")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("failed login")
    }
}

