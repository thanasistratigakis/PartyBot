//
//  PBTrack.swift
//  PartyBot
//
//  Created by Thanasi Stratigakis on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import Foundation
import Firebase

struct Track {
    
    let title: String!
    let artist: String!
    let uri: String!
    let itemRef: FIRDatabaseReference?

    init (title: String, artist: String, uri: String = "") {
        self.title = title
        self.artist = artist
        self.uri = uri
        self.itemRef = nil
    }
    
    init (snapshot:FIRDataSnapshot) {
        itemRef = snapshot.ref
        
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



