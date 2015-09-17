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
    
    class func parseCategoryProducts(products: AnyObject) -> CategoryProductModel {
        
        let model = CategoryProductModel()
        
        if products.isKindOfClass(NSDictionary) {
            model.productId = products["productId"] as! String
            model.productName = products["productName"] as! String
            model.image = products["image"] as! String
        }
        return model
    }
}