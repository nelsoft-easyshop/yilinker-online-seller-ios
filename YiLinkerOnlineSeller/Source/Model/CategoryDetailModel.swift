//
//  CategoryDetail.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//


import UIKit

class CategoryDetailModel: NSObject {
    
    var categoryId: Int = 0
    var categoryName: String = ""
    var sortOrder: Int = 0
    
    init(categoryId: Int, categoryName: String, sortOrder: Int) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.sortOrder = sortOrder
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryDetailModel {
        
        var categoryId: Int = 0
        var categoryName: String = ""
        var sortOrder: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["categoryId"] != nil {
                if let tempVar = dictionary["categoryId"] as? Int {
                    categoryId = tempVar
                }
            }
            
            if dictionary["categoryName"] != nil {
                if let tempVar = dictionary["categoryName"] as? String {
                    categoryName = tempVar
                }
            }
            
            if dictionary["sortOrder"] != nil {
                if let tempVar = dictionary[sortOrder] as? Int {
                    sortOrder = tempVar
                }
            }
            
        }
        
        return CategoryDetailModel(categoryId: categoryId, categoryName: categoryName, sortOrder: sortOrder)
    }
}