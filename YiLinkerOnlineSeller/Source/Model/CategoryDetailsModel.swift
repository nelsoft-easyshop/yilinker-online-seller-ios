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
    var categoryDetails: CategoryDetailModel?
    var subcategories: [CategoryDetailModel] = []
    var products: [CategoryProductModel] = []
    
    init(message: String, isSuccessful: Bool, categoryDetails: CategoryDetailModel, subcategories: [CategoryDetailModel], products: [CategoryProductModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.categoryDetails = categoryDetails
        self.subcategories = subcategories
        self.products = products
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryDetailsModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var categoryDetails: CategoryDetailModel?
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
                        if let tempVar = dictionary["categoryId"] as? Int {
                            categoryDetails?.categoryId = tempVar
                        }
                    }
                    
                    if tempVar["categoryName"] != nil {
                        if let tempVar = dictionary["categoryName"] as? String {
                            categoryDetails?.categoryName = tempVar
                        }
                    }
                    
                    if tempVar["sortOrder"] != nil {
                        if let tempVar = dictionary["sortOrder"] as? Int {
                            categoryDetails?.sortOrder = tempVar
                        }
                    }
                    
                    if tempVar["subcategories"] != nil {
                        if let tempVar = dictionary["subcategories"] as? NSArray {
                            subcategories = CategoryDetailModel.parseDataWithArray(tempVar)
                        }
                    }
                    
                    if tempVar["products"] != nil {
                        if let tempVar = dictionary["products"] as? NSArray {
                            products = CategoryProductModel.parseDataWithArray(tempVar)
                        }
                    }
                }
                products = CategoryProductModel.parseDataWithArray(dictionary["data"] as! NSArray)
            }
        }
        
        return CategoryDetailsModel(message: message, isSuccessful: isSuccessful, categoryDetails: categoryDetails!, subcategories: subcategories, products: products)
    }
}