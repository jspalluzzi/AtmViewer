//
//  AtmInformation.swift
//  hackAnATM
//
//  Created by xavier on 1/4/17.
//  Copyright © 2017 John. All rights reserved.
//

import Foundation
import SwiftyJSON

class AtmFactory{
    
    static func parseJsonToAtmList(atmListFromSearch: Array<JSON>)-> [AtmInformation]{
        
        var atmList = [AtmInformation]()
        
        for atm in atmListFromSearch{
            
            let atmInfo = AtmInformation(jsonData: atm)
            
            atmList.append(atmInfo)
        }
        
        return atmList
    }
    
}
