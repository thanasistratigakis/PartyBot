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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [SPTPartialTrack]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchForQuery(query: String) {
        guard SPTAuth.defaultInstance().session != nil &&
            SPTAuth.defaultInstance().session.isValid() else {
                return
        }
        
        SPTSearch.performSearchWithQuery(query,
                                         queryType: SPTSearchQueryType.QueryTypeTrack,
                                         accessToken: SPTAuth.defaultInstance().session.accessToken) { (error, results) in
                                            guard error == nil else {
                                                print(error.localizedDescription)
                                                return
                                            }
                                            
                                            guard let listPage = results as? SPTListPage else {
                                                return
                                            }
                                            
                                            guard let items = listPage.items as? [SPTPartialTrack] else {
                                                return
                                            }
                                            
                                            self.searchResults = items
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchResultTableViewCell
        
        let track = searchResults[indexPath.row]
        cell.nameLabel.text = track.name
        cell.artistLabel.text = (track.artists.first as! SPTPartialArtist).name
        
//        cell.artistLabel.text = track.artists.first as! String
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ref = FIRDatabase.database().reference().child("Tracks")
        
        let selectedResult = searchResults[indexPath.row]
        ref.childByAutoId().updateChildValues(["title" : selectedResult.name,
            "uri" : selectedResult.playableUri.absoluteString,
            "artist" : selectedResult.artists.first!.name, "url" : (selectedResult.album.covers[0].imageURL!.absoluteString)])

        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchForQuery(searchText)
        }
    }
}