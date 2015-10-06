//
//  ResolutionCenterDisputeReasonsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionCenterDisputeReasonsModel: NSObject {
   /*
    data": [
    {
    "key": "Replacement",
    "reasons": [
    {
    "id": 25,
    "reason": "I changed my mind. Im no longer interested in the product."
    },
    */
    var id: String = ""
    var reason: String = ""
    
    init(id: String, reason: String) {
        self.id = id
        self.reason = reason
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> ResolutionCenterDisputeReasonsModel {
        var id: String = ""
        var reason: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            
        }
        
        var reasons = ResolutionCenterDisputeReasonsModel(id: id, reason: reason)
        
        return reasons
    }
}
