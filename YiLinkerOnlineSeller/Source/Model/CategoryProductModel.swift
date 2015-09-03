//
//  CategoryProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CategoryProductModel: NSObject {
    
    var productId: String = ""
    var productName: String = ""
    var image: String = ""
    
    init(productId: String, productName: String, image: String) {
        self.productId = productId
        self.productName = productName
        self.image = image
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryProductModel {
        
        var productId: String = ""
        var productName: String = ""
        var image: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["productId"] != nil {
                if let tempVar = dictionary["productId"] as? String {
                    productId = tempVar
                }
            }
            
            if dictionary["productName"] != nil {
                if let tempVar = dictionary["productName"] as? String {
                    productName = tempVar
                }
            }
            
            if dictionary["image"] != nil {
                if let tempVar = dictionary["image"] as? String {
                    image = tempVar
                }
            }
            
        }
        
        return CategoryProductModel(productId: productId, productName: productName, image: image)
    }
    
    class func parseDataWithArray(array: AnyObject) -> [CategoryProductModel] {
        var products : [CategoryProductModel]  = []
        
        for product in products {
            if product.isKindOfClass(NSDictionary) {
                products.append(CategoryProductModel.parseDataWithDictionary(product))
            }
        }
        
        return products
    }
}