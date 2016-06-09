//
//  WarehouseCityModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseCityModel: NSObject {
    
    var cityId: [Int] = []
    var location: [String] = []
    
    init (cityId: [Int], location: [String]) {
        self.cityId = cityId
        self.location = location
    }
    
    class func parseDataWithDictionary (dictionary: NSDictionary) -> WarehouseCityModel {
        
        var cityId: [Int] = []
        var location: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            for value in dictionary["data"] as! NSArray {
                if let tempVar =  value["cityId"] as? Int {
                    cityId.append(tempVar)
                }
                
                if let tempVar =  value["location"] as? String {
                    location.append(tempVar)
                }
            }
        }
        
        return WarehouseCityModel(cityId: cityId, location: location)
    }
}
