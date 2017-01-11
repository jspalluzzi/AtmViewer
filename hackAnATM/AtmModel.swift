//
//  AtmModel.swift
//  hackAnATM
//
//  Created by xavier on 1/8/17.
//  Copyright © 2017 John. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AtmInformation{
    
    var state:String
    var locType:String
    var label:String
    var address:String
    var city:String
    var zip:String
    var name:String
    var lat:Double
    var lng:Double
    var bank:String
    var type:String
    var lobbyHrs:Array<JSON>
    var driveUpHrs:Array<JSON>
    var atms:String
    var services:Array<JSON>
    var phone:String
    var distance:String
    
    
    init(jsonData: JSON){
        
        self.state = jsonData["state"].stringValue
        self.locType = jsonData["locType"].stringValue
        self.label = jsonData["label"].stringValue
        self.address = jsonData["address"].stringValue
        self.city = jsonData["city"].stringValue
        self.zip = jsonData["zip"].stringValue
        self.name = jsonData["name"].stringValue
        self.lat = jsonData["lat"].doubleValue
        self.lng = jsonData["lng"].doubleValue
        self.bank = jsonData["bank"].stringValue
        self.type = jsonData["type"].stringValue
        self.lobbyHrs = jsonData["lobbyHrs"].arrayValue
        self.driveUpHrs = jsonData["driveUpHrs"].arrayValue
        self.atms = jsonData["atms"].stringValue
        self.services = jsonData["services"].arrayValue
        self.phone = jsonData["phone"].stringValue
        self.distance = jsonData["distance"].stringValue
        
    }
    
}
