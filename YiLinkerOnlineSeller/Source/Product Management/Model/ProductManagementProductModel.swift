//
//  ProductManagementProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class ProductManagementProductModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    var products: [ProductManagementProductsModel] = []
    
    init(message: String, isSuccessful: Bool, products: [ProductManagementProductsModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.products = products
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductManagementProductModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var products: [ProductManagementProductsModel] = []
        
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
            
            if let value: AnyObject = dictionary["data"] {
                for subValue in value["products"] as! NSArray {
                    let model: ProductManagementProductsModel = ProductManagementProductsModel.parseDataWithDictionary(subValue as! NSDictionary)
                    products.append(model)
                }
            }
        }
        
        return ProductManagementProductModel(message: message, isSuccessful: isSuccessful, products: products)
    }
}
