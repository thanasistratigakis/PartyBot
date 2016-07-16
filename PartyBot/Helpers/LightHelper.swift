//
//  LightHelper.swift
//  PartyBot
//
//  Created by Brian Hans on 7/16/16.
//  Copyright © 2016 PartyBot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LightHelper{
    static var url = "http://10.10.60.84/api/23KgD5Dg40HbQLkcgitcSwnNTxrkzuEnzuEEnoL6"
    static var timer: NSTimer!
    static var startDate: NSDate!
    static var duration: Double!
    
    static func turnOffAllLights(){
        Alamofire.request(.PUT, url + "/lights/1/state", parameters: ["on" : false], encoding: .JSON)
        Alamofire.request(.PUT, url + "/lights/2/state", parameters: ["on" : false], encoding: .JSON)
        Alamofire.request(.PUT, url + "/lights/3/state", parameters: ["on" : false], encoding: .JSON)
    }
    
    static func turnOnAllLights(){
        Alamofire.request(.PUT, url + "/lights/1/state", parameters: ["on" : true], encoding: .JSON)
        Alamofire.request(.PUT, url + "/lights/2/state", parameters: ["on" : true], encoding: .JSON)
        Alamofire.request(.PUT, url + "/lights/3/state", parameters: ["on" : true], encoding: .JSON)
    }
    
    static func flashLightsAtTempo(tempo: Double, duration: Double){
        let speed = 1.0 / (tempo / 60.0)
        LightHelper.startDate = NSDate()
        LightHelper.duration = duration
        LightHelper.turnOnAllLights()
        
        LightHelper.timer = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: #selector(flashBulb), userInfo: nil, repeats: true)
 
        
    }
    
    @objc static func flashBulb(){
        let bulb = arc4random_uniform(3) + 1
        
        Alamofire.request(.PUT, url + "/lights/\(bulb)/state", parameters: ["hue" : Int(arc4random_uniform(65535)), "transitiontime" : 0], encoding: .JSON)
        Alamofire.request(.PUT, url + "/lights/\(bulb)/state", parameters: ["on" : true, "transitiontime" :0], encoding: .JSON)
        if(NSDate().timeIntervalSinceDate(LightHelper.startDate) > LightHelper.duration){
            LightHelper.timer.invalidate()
            LightHelper.turnOffAllLights()
        }
    }

}