//
//  ProductVariantValueModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductVariantValueModel: NSObject {
    var id: String = ""
    var value: String = ""
    
    init(id: String, value: String) {
        self.id = id
        self.value = value
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductVariantValueModel {
        var id: String = ""
        var value: String = ""
        
        id = ParseHelper.string(dictionary, key: "id", defaultValue: "")
        value = ParseHelper.string(dictionary, key: "value", defaultValue: "")
        
        return ProductVariantValueModel(id: id, value: value)
    }
    
    class func parseArrayDataWithDictionary(arr: NSArray) -> [ProductVariantValueModel] {
        var values: [ProductVariantValueModel] = []
        
        for subValue in arr {
            values.append(ProductVariantValueModel.parseDataWithDictionary(subValue))
        }
        
        return values
    }
}
