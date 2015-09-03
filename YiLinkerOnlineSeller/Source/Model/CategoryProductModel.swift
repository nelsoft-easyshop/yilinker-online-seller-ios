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
    var status: Int = 0
    
    init(productId: String, productName: String, image: String, status: Int) {
        self.productId = productId
        self.productName = productName
        self.image = image
        self.status = status
        var status: Int = 0
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CategoryProductModel {
        
        var productId: String = ""
        var productName: String = ""
        var image: String = ""
        var status: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["productId"] != nil {
                if let tempVar = dictionary["productId"] as? String {
                    productId = tempVar
                }
            } else {
                if dictionary["id"] != nil {
                    if let tempVar = dictionary["id"] as? String {
                        productId = tempVar
                    }
                }
            }
            
            if dictionary["productName"] != nil {
                if let tempVar = dictionary["productName"] as? String {
                    productName = tempVar
                }
            } else {
                if dictionary["name"] != nil {
                    if let tempVar = dictionary["name"] as? String {
                        productName = tempVar
                    }
                }
            }
            
            if dictionary["image"] != nil {
                if let tempVar = dictionary["image"] as? String {
                    image = tempVar
                }
            }
            
            if dictionary["status"] != nil {
                if let tempVar = dictionary["status"] as? Int {
                    status = tempVar
                }
            }
            
        }
        
            return CategoryProductModel(productId: productId, productName: productName, image: image, status: status)
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