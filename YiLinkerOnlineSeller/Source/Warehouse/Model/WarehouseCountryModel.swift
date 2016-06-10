//
//  WarehouseCountryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseCountryModel: NSObject {
    
    var countryId: [Int] = []
    var location: [String] = []
    
    init (countryId: [Int], location: [String]) {
        self.countryId = countryId
        self.location = location
    }
    
    class func parseDataWithDictionary (dictionary: NSDictionary) -> WarehouseCountryModel {
        
        var countryId: [Int] = []
        var location: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            for value in dictionary["data"] as! NSArray {
                if let tempVar =  value["countryId"] as? Int {
                    countryId.append(tempVar)
                }
                
                if let tempVar =  value["location"] as? String {
                    location.append(tempVar)
                }
            }
        }
        
        return WarehouseCountryModel(countryId: countryId, location: location)
    }
}
