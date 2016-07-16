//
//  AppDelegate.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/15/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupThirdPartyFramworks()
        
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        
//        let authViewController = SPTAuthViewController.authenticationViewController()
//        authViewController.delegate = self
//        
//        window!.rootViewController = authViewController
//        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setupThirdPartyFramworks() {
        // Spotify
        SPTAuth.defaultInstance().clientID = Constant.SPTClientID
        SPTAuth.defaultInstance().redirectURL = NSURL(string: "partybot://")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        
        // Firebase
        FIRApp.configure()
    }
}

//extension AppDelegate: SPTAuthViewDelegate {
//    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
//        //
//        
//        print("logged in")
//    }
//    
//    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
//        //
//        
//        print("canceled login")
//    }
//    
//    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
//        print("failed login")
//    }
//}
