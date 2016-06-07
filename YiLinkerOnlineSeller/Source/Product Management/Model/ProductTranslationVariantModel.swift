//
//  ProductTranslationVariantModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductTranslationVariantModel: NSObject {
    var id: String = ""
    var name: String = ""
    var values: [ProductVariantValueModel] = []
    
    init(id: String, name: String, values: [ProductVariantValueModel]) {
        self.id = id
        self.name = name
        self.values = values
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductTranslationVariantModel {
        var id: String = ""
        var name: String = ""
        var values: [ProductVariantValueModel] = []
        
        id = ParseHelper.string(dictionary, key: "id", defaultValue: "")
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        values = ProductVariantValueModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "values", defaultValue: []))
        
        return ProductTranslationVariantModel(id: id, name: name, values: values)
    }
    
    class func parseArrayDataWithDictionary(arr: NSArray) -> [ProductTranslationVariantModel] {
        var values: [ProductTranslationVariantModel] = []
        
        for subValue in arr {
            values.append(ProductTranslationVariantModel.parseDataWithDictionary(subValue))
        }
        
        return values
    }
}
