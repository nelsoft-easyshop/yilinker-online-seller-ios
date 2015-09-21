//
//  TransactionCancellationModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/10/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionCancellationModel: NSObject {
   
    var cancellationId: Int = 0
    var cancellationReason: String = ""
    var cancellationDescription: String = ""
    
    init(cancellationId: Int, cancellationReason: String, cancellationDescription: String) {
        self.cancellationId = cancellationId
        self.cancellationReason = cancellationReason
        self.cancellationDescription = cancellationDescription
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionCancellationModel {
        
        var cancellationId: Int = 0
        var cancellationReason: String = ""
        var cancellationDescription: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["id"] != nil {
                if let tempVar = dictionary["id"] as? Int {
                    cancellationId = tempVar
                }
            }
            
            if dictionary["reason"] != nil {
                if let tempVar = dictionary["reason"] as? String {
                    cancellationReason = tempVar
                }
            }
            
            if dictionary["description"] != nil {
                if let tempVar = dictionary["description"] as? String {
                    cancellationDescription = tempVar
                }
            }
        }
        
        return TransactionCancellationModel(cancellationId: cancellationId, cancellationReason: cancellationReason, cancellationDescription: cancellationDescription)
    }

}
