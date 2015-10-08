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
    var id: [Int] = []
    var reason: [String] = []
    var allkey: [String] = []
    var key: [String] = []
    var resolutionReasons: [ResolutionCenterDisputeReasonsModel] = []
    var key2: String = ""
    var resolutionReasons2: [ResolutionCenterDisputeReasonsModel] = []
    init(key: NSArray, resolutionReasons: [ResolutionCenterDisputeReasonsModel], allkey: NSArray, id: NSArray, reason: NSArray) {
        self.key = key as! [String]
        self.allkey = allkey as! [String]
        self.id = id as! [Int]
        self.reason = reason as! [String]
        self.resolutionReasons = resolutionReasons
    }
    
    init(key2: String, resolutionReasons2: [ResolutionCenterDisputeReasonsModel]) {
        self.key2 = key2
        self.resolutionReasons2 = resolutionReasons2
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> ResolutionCenterDisputeReasonModel {
        var key: [String] = []
        var allkey: [String] = []
        var resolutionReasons: [ResolutionCenterDisputeReasonsModel] = []
        var id: [Int] = []
        var reasons: [String] = []
        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                //let reasons: NSArray = value["data"] as! NSArray
                for reasonDictionary in value as! [NSDictionary] {
                    key.append(reasonDictionary["key"] as! String)
                    //println("key: \(key)")
                    if !(reasonDictionary["reasons"] is NSNull) {
                        for subValue in reasonDictionary["reasons"] as! NSArray {
                            allkey.append(reasonDictionary["key"] as! String)
                            //id = subValue["id"] as! Int
                            //reason = subValue["reason"] as! String
                            id.append(subValue["id"] as! Int)
                            reasons.append(subValue["reason"] as! String)
                            resolutionReasons.append(ResolutionCenterDisputeReasonsModel(id: subValue["id"] as! Int, reason: subValue["reason"] as! String))
                        }
                    } else {
                         resolutionReasons.append(ResolutionCenterDisputeReasonsModel(id: 10001, reason: "No reason"))
                    }
                    /*
                    if !(reasonDictionary["reasons"] is NSNull) {
                        let  reasons = ResolutionCenterDisputeReasonsModel.parseDataFromDictionary(reasonDictionary["reasons"] as! NSArray)
                        resolutionReasons.append(reasons)
                        println("reasons: \(reasons.reason)")
                    }*/
                   
                }
            }
            
        }
        
        var reason = ResolutionCenterDisputeReasonModel(key: key, resolutionReasons: resolutionReasons, allkey: allkey, id: id, reason: reasons)
        return reason
    }
}
