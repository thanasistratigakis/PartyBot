//
//  SearchViewController.swift
//  PartyBot
//
//  Created by Chase Wang on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    var searchResult = [SPTPartialTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    func search() {
        guard SPTAuth.defaultInstance().session != nil &&
            SPTAuth.defaultInstance().session.isValid() else {
                return
        }
        
        SPTSearch.performSearchWithQuery("zero chris brown",
                                         queryType: SPTSearchQueryType.QueryTypeTrack,
                                         accessToken: SPTAuth.defaultInstance().session.accessToken) { (error, results) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                                return
                                            }
                                            
                                            let items = (results as! SPTListPage).items
                                            let track = items[0] as! SPTPartialTrack
                                            
//                                            self.playSong(track.playableUri)
        }
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        let ref = FIRDatabase.database().reference().child("Tracks")
        
        ref.childByAutoId().updateChildValues(["title" : searchResult[indexPath.row].name, "uri" : searchResult[indexPath.row].playableUri, "artist" : searchResult[indexPath.row].artists.first!])
        
    }
}