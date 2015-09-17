//
//  CategoryProductsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

class CategoryProductsModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var products: [CategoryProductModel] = []
    
    init(message: String, isSuccessful: Bool, products: [CategoryProductModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.products = products
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryProductsModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        let products: [CategoryProductModel] = []
        
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
            
//            if dictionary["data"] != nil {
//                if let tempVar = dictionary["data"] as? NSDictionary {
//                    if tempVar["products"] != nil {
//                        if let tempProducts = tempVar["products"] as? NSArray {
//                            products = CategoryProductModel.parseDataWithArray(tempProducts as NSArray)
//                        }
//                    }
//                }
//            }
        }
        
        return CategoryProductsModel(message: message, isSuccessful: isSuccessful, products: products)
    }
}