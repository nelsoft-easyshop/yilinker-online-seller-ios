//
//  ProductUnitAttributeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductUnitAttributeModel: NSObject {
   
    var id: String = ""
    var name: String = ""
    var value : String = ""
    
    init(id: String, name: String, value : String) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductUnitAttributeModel {
        var id: String = ""
        var name: String = ""
        var value : String = ""
        
        id = ParseHelper.string(dictionary, key: "id", defaultValue: "")
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        value = ParseHelper.string(dictionary, key: "value ", defaultValue: "")
        
        return ProductUnitAttributeModel(id: id, name: name, value: value)
    }
    
    class func parseArrayDataWithDictionary(arr: NSArray) -> [ProductUnitAttributeModel] {
        var attributes: [ProductUnitAttributeModel] = []
        
        for subValue in arr {
            attributes.append(ProductUnitAttributeModel.parseDataWithDictionary(subValue))
        }
        
        return attributes
    }
}
