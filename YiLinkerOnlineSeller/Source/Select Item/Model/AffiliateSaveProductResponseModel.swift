//
//  AffiliateSaveProductResponseModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AffiliateSaveProductResponseModel: NSObject {
    var isSuccessful: Bool = true
    
    var save: [NSDictionary] = []
    var remove: [NSDictionary] = []
    
    init(save: [NSDictionary], remove: [NSDictionary], isSuccessful: Bool) {
        self.save = save
        self.remove = remove
        self.isSuccessful = isSuccessful
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> AffiliateSaveProductResponseModel {
        var isSuccessful: Bool = true
        
        var save: [NSDictionary] = []
        var remove: [NSDictionary] = []
        
        if let dataDictionary = dictionary["data"] as? NSDictionary {
            save = ParseHelper.array(dataDictionary, key: "save", defaultValue: []) as! [NSDictionary]
            remove = ParseHelper.array(dataDictionary, key: "remove", defaultValue: []) as! [NSDictionary]
        }
        
        
        isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
        
        return AffiliateSaveProductResponseModel(save: save, remove: remove, isSuccessful: isSuccessful)
    }
}
