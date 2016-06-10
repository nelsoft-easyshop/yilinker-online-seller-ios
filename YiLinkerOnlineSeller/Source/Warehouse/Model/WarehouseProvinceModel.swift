//
//  WarehouseProvinceModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseProvinceModel: NSObject {
    
    var provinceId: [Int] = []
    var location: [String] = []
    
    init (provinceId: [Int], location: [String]) {
        self.provinceId = provinceId
        self.location = location
    }
    
    class func parseDataWithDictionary (dictionary: NSDictionary) -> WarehouseProvinceModel {
        
        var provinceId: [Int] = []
        var location: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            for value in dictionary["data"] as! NSArray {
                if let tempVar =  value["provinceId"] as? Int {
                    provinceId.append(tempVar)
                }
                
                if let tempVar =  value["location"] as? String {
                    location.append(tempVar)
                }
            }
        }
        
        return WarehouseProvinceModel(provinceId: provinceId, location: location)
    }
}
