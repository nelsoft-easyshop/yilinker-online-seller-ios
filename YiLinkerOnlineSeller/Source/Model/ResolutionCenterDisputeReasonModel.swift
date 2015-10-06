//
//  ResolutionCenterDisputeReasonModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionCenterDisputeReasonModel: NSObject {
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
    
    var key: String = ""
    var resolutionReasons: [ResolutionCenterDisputeReasonsModel] = []
    
    init(key: String, resolutionReasons: [ResolutionCenterDisputeReasonsModel]) {
        self.key = key
        self.resolutionReasons = resolutionReasons
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> ResolutionCenterDisputeReasonModel {
        var key: String = ""
        var resolutionReasons: [ResolutionCenterDisputeReasonsModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                //let reasons: NSArray = value["data"] as! NSArray
                for reasonDictionary in value as! [NSDictionary] {
                    key = reasonDictionary["key"] as! String
                    println("key: \(key)")
                    let  reasons = ResolutionCenterDisputeReasonsModel.parseDataFromDictionary(reasonDictionary["reasons"] as! NSArray)
                    resolutionReasons.append(reasons)
                    println("reasons: \(reasons)")
                }
            }
            
        }
        
        var reason = ResolutionCenterDisputeReasonModel(key: key, resolutionReasons: resolutionReasons)
        return reason
    }
}
