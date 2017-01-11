//
//  AtmManager.swift
//  hackAnATM
//
//  Created by xavier on 1/8/17.
//  Copyright © 2017 John. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON
//NOTE TO SELF: SEPERATE THE ATM INFO CLASS TO IT'S OWN FILE

protocol AtmManagerDelegate: NSObjectProtocol {
    func didRecieveNewAtmInfo(newAtmInfo: [AtmInformation])
}

class AtmManager{
    
    let atmLocationURL = "https://m.chase.com/PSRWeb/location/list.action"
    
    weak var delegate: AtmManagerDelegate!
    
    var atmList = [AtmInformation]()
    
    //MARK: GENERAL HELPING FUNCTIONS
    func getATMLocations(coordinates: CLLocationCoordinate2D){
        let parameters: Parameters = ["lat": "\(coordinates.latitude)",
                                      "lng": "\(coordinates.longitude)"]
        
        Alamofire.request(atmLocationURL, parameters: parameters).responseString(completionHandler: { response in
            if let dataFromString = response.data{
                let json = JSON(data: dataFromString)
                
                self.atmList = AtmFactory.parseJsonToAtmList(atmListFromSearch: json["locations"].arrayValue)
                
                if let recievingClass = self.delegate{
                    recievingClass.didRecieveNewAtmInfo(newAtmInfo: self.atmList)
                }
            }
        })
    }
    
}
