//
//  SubCategoryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class SubCategoryModel: NSObject {
    
    var message: String = ""
    var isSuccessful: Bool = false
    var categoryId: Int = 0
    var categoryName: String = ""
    var parentName: String = ""
    var parentId: Int = 0
    var sortOrder: Int = 0
    var products: [CategoryProductModel] = []
    
    init(message: String, isSuccessful: Bool, categoryId: Int, categoryName: String, parentName: String, parentId: Int, sortOrder: Int, products: [CategoryProductModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.parentName = parentName
        self.parentId = parentId
        self.sortOrder = sortOrder
        self.products = products
    }
    
    class func parseSubCategories(subCategories: NSDictionary) -> SubCategoryModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var categoryId: Int = 0
        var categoryName: String = ""
        var parentName: String = ""
        var parentId: Int = 0
        var sortOrder: Int = 0
        var products: [CategoryProductModel] = []
        
        if subCategories.isKindOfClass(NSDictionary) {

            if subCategories["message"] != nil {
                if let tempVar = subCategories["message"] as? String {
                    message = tempVar
                }
            }
            
            if subCategories["isSuccessful"] != nil {
                if let tempVar = subCategories["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if subCategories["data"] != nil {
                if let value = subCategories["data"] as? NSDictionary {
                    
                    if value["categoryId"] != nil {
                        if let tempVar = value["categoryId"] as? Int {
                            categoryId = tempVar
                        }
                    }
                    
                    if value["categoryName"] != nil {
                        if let tempVar = value["categoryName"] as? String {
                            categoryName = tempVar
                        }
                    }
                    
                    if value["sortOrder"] != nil {
                        if let tempVar = value["sortOrder"] as? Int {
                            sortOrder = tempVar
                        }
                    }
                    
                    if value["parentId"] != nil {
                        if let tempVar = value["parentId"] as? Int {
                            parentId = tempVar
                        }
                    }
                    
                    if value["products"] != nil {
                        for subValue in value["products"] as! NSArray {
                            let model: CategoryProductModel = CategoryProductModel.parseCategoryProducts(subValue as! NSDictionary)
                            products.append(model)
                        }
                    }
                    
                } // data
            } else {
                categoryId = subCategories["categoryId"] as! Int
                categoryName = subCategories["categoryName"] as! String
                sortOrder = subCategories["sortOrder"] as! Int
            }
            
        }
        
        return SubCategoryModel(message: message, isSuccessful: isSuccessful, categoryId: categoryId, categoryName: categoryName, parentName: parentName, parentId: parentId, sortOrder: sortOrder, products: products)
    }
    
}