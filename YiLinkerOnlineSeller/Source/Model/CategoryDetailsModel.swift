//
//  CategoryDetailsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class CategoryDetailsModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var categoryId: Int = 0
    var categoryName: String = ""
    var parentId: String = ""
    var sortOrder: Int = 0
    var subcategories: [CategoryDetailModel] = []
    var products: [CategoryProductModel] = []
    
    init(message: String, isSuccessful: Bool, categoryId: Int, categoryName: String, parentId: String, sortOrder: Int, subcategories: [CategoryDetailModel], products: [CategoryProductModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.parentId = parentId
        self.sortOrder = sortOrder
        self.subcategories = subcategories
        self.products = products
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryDetailsModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var categoryId: Int = 0
        var categoryName: String = ""
        var parentId: String = ""
        var sortOrder: Int = 0
        var subcategories: [CategoryDetailModel] = []
        var products: [CategoryProductModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempVar = dictionary["data"] as? NSDictionary {
                    if tempVar["categoryId"] != nil {
                        if let value = tempVar["categoryId"] as? Int {
                            categoryId = value
                        }
                    }
                    
                    if tempVar["categoryName"] != nil {
                        if let value = tempVar["categoryName"] as? String {
                            categoryName = value
                        }
                    }
                    
                    if tempVar["sortOrder"] != nil {
                        if let value = tempVar["sortOrder"] as? Int {
                            sortOrder = value
                        }
                    }
                    
                    if tempVar["subcategories"] != nil {
                        if let value = tempVar["subcategories"] as? NSArray {
                            subcategories = CategoryDetailModel.parseDataWithArray(value)
                        }
                    }
                    
                    if tempVar["products"] != nil {
                        if let value = tempVar["products"] as? NSArray {
                            products = CategoryProductModel.parseDataWithArray(value)
                        }
                    }
                } // data
            } // data
        }
        
        return CategoryDetailsModel(message: message, isSuccessful: isSuccessful, categoryId: categoryId, categoryName: categoryName, parentId: parentId, sortOrder: sortOrder, subcategories: subcategories, products: products)
    }
}