//
//  WareFilterModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/8/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WareFilterModel: NSObject {
   
    var filter: [String] = []
    var filterModel: [FilterModel] = []
    
    init(filter: [String], filterModel: [FilterModel]) {
        self.filter = filter
        self.filterModel = filterModel
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> WareFilterModel {
        
        var filter: [String] = []
        var filterModel: [FilterModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
              
            filter.append("Status")
            filter.append("Categories")
            filter.append("Producy Groups")
            
            if let value: NSDictionary = dictionary["data"] as? NSDictionary{
                
                var filterStatusModelValue = FilterModel()
                
                for subValue in value["status"] as! NSArray {
                    
                    if let tempVar =  subValue["id"] as? Int {
                        filterStatusModelValue.id.append(tempVar)
                    }
                    
                    if let tempVar =  subValue["name"] as? String {
                        filterStatusModelValue.name.append(tempVar)
                    }
                }
                    
                filterModel.append(filterStatusModelValue)
                    
                var filterCategoriesModelValue = FilterModel()
                    
                for subValue in value["categories"] as! NSArray {
                    
                    if let tempVar =  subValue["id"] as? Int {
                        filterCategoriesModelValue.id.append(tempVar)
                    }
                    
                    if let tempVar =  subValue["name"] as? String {
                        filterCategoriesModelValue.name.append(tempVar)
                    }
                }
            
                filterModel.append(filterCategoriesModelValue)
                    
                var filterGroupsModelValue = FilterModel()
                    
                for subValue in value["productGroups"] as! NSArray {
                    
                    if let tempVar =  subValue["id"] as? Int {
                        filterGroupsModelValue.id.append(tempVar)
                    }
                    
                    if let tempVar =  subValue["name"] as? String {
                        filterGroupsModelValue.name.append(tempVar)
                    }
                }
                filterModel.append(filterGroupsModelValue)
            }
        }
        
        return WareFilterModel(filter: filter, filterModel: filterModel)
    }
}
