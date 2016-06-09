//
//  WarehouseBarangayModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseBarangayModel: NSObject {
    
    var barangayId: [Int] = []
    var location: [String] = []
    
    init (barangayId: [Int], location: [String]) {
        self.barangayId = barangayId
        self.location = location
    }
    
    class func parseDataWithDictionary (dictionary: NSDictionary) -> WarehouseBarangayModel {
        
        var barangayId: [Int] = []
        var location: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            for value in dictionary["data"] as! NSArray {
                if let tempVar =  value["barangayId"] as? Int {
                    barangayId.append(tempVar)
                }
                
                if let tempVar =  value["location"] as? String {
                    location.append(tempVar)
                }
            }
        }
        
        return WarehouseBarangayModel(barangayId: barangayId, location: location)
    }
}
