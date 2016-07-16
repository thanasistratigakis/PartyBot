//
//  MainPageViewController.swift
//  PartyBot
//
//  Created by Nicholas Swift on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import Foundation
import UIKit

class MainPageViewController: UIViewController {
    
    // Variables
    @IBOutlet weak var tableView: UITableView!
    
    let sectionArray = ["HEADER OR SOME SHIT", "Currently Playing...", "Up Next..."]
    
    // For View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For Table View Controller
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell") as! InformationCell
            cell.informationTextLabel.text = "HEADER OR SOME SHIT"
            return cell
        }
        else if section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell") as! InformationCell
            cell.informationTextLabel.text = "Current Song"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell") as! InformationCell
            cell.informationTextLabel.text = "Next songs"
            return cell
        }*/
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell") as! InformationCell
        
        cell.informationTextLabel.text = sectionArray[section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentSongCell") as! CurrentSongTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NextSongCell") as! NextSongTableViewCell
            return cell
        }
    }
    
}