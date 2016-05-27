//
//  ProductLanguageModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductLanguageModel: NSObject {
   
    var languageId: Int = 0
    var languageName: String = ""
    var languageCode: String = ""
    var countryId: Int = 0
    var countryName: String = ""
    var countryCode: String = ""
    var isSelected: Bool = false
    
    
    
    init(languageId: Int, languageName: String, languageCode: String, countryId: Int, countryName: String, countryCode: String, isSelected: Bool) {
        
        self.languageId = languageId
        self.languageName = languageName
        self.languageCode = languageCode
        self.countryId = countryId
        self.countryName = countryName
        self.countryCode = countryCode
        self.isSelected = isSelected
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductLanguageModel {
        
        var languageId = ParseHelper.int(dictionary, key: "languageId", defaultValue: 0)
        var languageName = ParseHelper.string(dictionary, key: "languageName", defaultValue: "")
        var languageCode = ParseHelper.string(dictionary, key: "languageCode", defaultValue: "")
        var countryId = ParseHelper.int(dictionary, key: "countryId", defaultValue: 0)
        var countryName = ParseHelper.string(dictionary, key: "countryName", defaultValue: "")
        var countryCode = ParseHelper.string(dictionary, key: "countryCode", defaultValue: "")
        var isSelected = ParseHelper.bool(dictionary, key: "isSelected", defaultValue: false)
        
        return ProductLanguageModel(languageId: languageId, languageName: languageName, languageCode: languageCode, countryId: countryId, countryName: countryName, countryCode: countryCode, isSelected: isSelected)
        
    }
    
    class func parseArrayDataWithDictionary(dictionary: AnyObject) -> [ProductLanguageModel] {
        var productLanguages: [ProductLanguageModel] = []
        
        for subValue in ParseHelper.array(dictionary, key: "data", defaultValue: []) {
            productLanguages.append(ProductLanguageModel.parseDataWithDictionary(subValue))
        }
        
        return productLanguages
    }
    
}
