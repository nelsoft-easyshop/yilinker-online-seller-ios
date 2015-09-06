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
            
            model.id = products["id"] as! String
            model.name = products["name"] as! String
            model.category = products["category"] as! String
            model.image = products["image"] as! String
            model.status = products["status"] as! Int
            
        }
        return model
    }
}