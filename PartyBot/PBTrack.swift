//
//  PBTrack.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import Foundation
import Firebase

struct PBTrack {
    
    let title: String!
    let artist: String!
    //let album: String!
    let key: String!
    let uri: String!
    let itemRef: FIRDatabaseReference?

    init (title: String, artist: String, uri: String = "") {
        self.title = title
        self.artist = artist
        self.uri = uri
        self.itemRef = nil
        self.key = nil
    }
    
    init (snapshot:FIRDataSnapshot) {
        itemRef = snapshot.ref
        self.key = snapshot.key
        if let trackTitle = snapshot.value!["title"] as? String {
            title = trackTitle
        } else {
            title = ""
        }
        
        if let trackArtist = snapshot.value!["artist"] as? String {
            artist = trackArtist
        } else {
            artist = ""
        }
        
        if let trackUri = snapshot.value!["uri"] as? String {
            uri = trackUri
        } else {
            uri = ""
        }
    }
    
    
}



