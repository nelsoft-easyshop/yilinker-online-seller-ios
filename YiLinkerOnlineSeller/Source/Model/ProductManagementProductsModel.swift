//
//  ProductManagementProductsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class ProductManagementProductsModel {
    
    var id: String = ""
    var name: String = ""
    var category: String = ""
    var image: String = ""
    var status: Int = 0
    
    class func parseDataWithDictionary(products: AnyObject) -> ProductManagementProductsModel {
        
        var model = ProductManagementProductsModel()
        if products.isKindOfClass(NSDictionary) {
            model.id = ParseHelper.string(products, key: "id", defaultValue: "")
            model.name = ParseHelper.string(products, key: "name", defaultValue: "-")
            model.category = ParseHelper.string(products, key: "category", defaultValue: "-")
            model.image = ParseHelper.string(products, key: "image", defaultValue: "")
            model.status = ParseHelper.int(products, key: "status", defaultValue: 0)
//            model.id = products["id"] as! String
//            model.name = products["name"] as! String
            
//            if !(products["category"] is NSNull) {
//                model.category = products["category"] as! String
//            } else {
//                model.category = "Not Categorized"
//            }

//            model.image = products["image"] as! String
//            model.status = products["status"] as! Int
            
        }
        return model
    }
}