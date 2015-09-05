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
    var subcategories: [SubCategoryModel] = []
    var products: [CategoryProductModel] = []
    
    init(message: String, isSuccessful: Bool, categoryId: Int, categoryName: String, parentId: String, sortOrder: Int, subcategories: [SubCategoryModel], products: [CategoryProductModel]) {
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
        var subcategories: [SubCategoryModel] = []
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
                if let value = dictionary["data"] as? NSDictionary {
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
                    
                    for subValue in value["subcategories"] as! NSArray {
                        let model: SubCategoryModel = SubCategoryModel.parseSubCategories(subValue as! NSDictionary)
                        subcategories.append(model)
                    }
                    
                    for subValue in value["products"] as! NSArray {
                        let model: CategoryProductModel = CategoryProductModel.parseCategoryProducts(subValue as! NSDictionary)
                        products.append(model)
                    }

                } // data
            } // data
        }
        
        return CategoryDetailsModel(message: message, isSuccessful: isSuccessful, categoryId: categoryId, categoryName: categoryName, parentId: parentId, sortOrder: sortOrder, subcategories: subcategories, products: products)
    }
}