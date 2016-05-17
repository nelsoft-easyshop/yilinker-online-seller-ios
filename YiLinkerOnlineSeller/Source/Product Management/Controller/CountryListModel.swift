//
//  CountryListModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 5/16/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountryListModel: NSObject {
   
    var message: String = ""
    var isSuccessful: Bool = false
    
    var countryId: Int = 0
    var name: String = ""
    var code: String = ""
    var domain: String = ""
    var area_code: String = ""
    var isActive: Bool = false
    var defaultLanguageId: Int = 0
    var defaultLanguageName: String = ""
    var defaultLanguageCode: String = ""
    var flag: String = ""
    var isAvailable: Bool = false
    
    init(message: String, isSuccessful: Bool, countryId: Int, name: String, code: String, domain: String, area_code: String, isActive: Bool, defaultLanguageId: Int, defaultLanguageName: String, defaultLanguageCode: String, flag: String, isAvailable: Bool) {
        
        self.countryId = countryId
        self.name = name
        self.code = code
        self.domain = domain
        self.area_code = area_code
        self.isActive = isActive
        self.defaultLanguageId = defaultLanguageId
        self.defaultLanguageName = defaultLanguageName
        self.defaultLanguageCode = defaultLanguageCode
        self.flag = flag
        self.isAvailable = isAvailable
    }
    
    class func parseDataWithDictionary(data: AnyObject) -> CountryListModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var countryId: Int = 0
        var name: String = ""
        var code: String = ""
        var domain: String = ""
        var area_code: String = ""
        var isActive: Bool = false
        var defaultLanguageId: Int = 0
        var defaultLanguageName: String = ""
        var defaultLanguageCode: String = ""
        var flag: String = ""
        var isAvailable: Bool = false
        
//        if dictionary.isKindOfClass(NSDictionary) {
        
//            message = ParseHelper.string(dictionary, key: "message", defaultValue: "")
//            isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            
//            if let value: AnyObject = dictionary["data"] {
            
                countryId = ParseHelper.int(data, key: "countryId", defaultValue: 0)
                name = ParseHelper.string(data, key: "name", defaultValue: "")
                code = ParseHelper.string(data, key: "code", defaultValue: "")
                domain = ParseHelper.string(data, key: "domain", defaultValue: "")
                area_code = ParseHelper.string(data, key: "area_code", defaultValue: "")
                isActive = ParseHelper.bool(data, key: "isActive", defaultValue: false)
                
                if let defaultLanguage: AnyObject = data["defaultLanguage"] {
                    defaultLanguageId = ParseHelper.int(defaultLanguage, key: "countryId", defaultValue: 0)
                    defaultLanguageName = ParseHelper.string(defaultLanguage, key: "message", defaultValue: "")
                    defaultLanguageCode = ParseHelper.string(defaultLanguage, key: "message", defaultValue: "")
                }
                
                flag = ParseHelper.string(data, key: "flag", defaultValue: "")
                isAvailable = ParseHelper.bool(data, key: "isAvailable", defaultValue: false)
                
//            }  data
//        }  dictionary
    
        return CountryListModel(message: message, isSuccessful: isSuccessful, countryId: countryId, name: name, code: code, domain: domain, area_code: area_code, isActive: isActive, defaultLanguageId: defaultLanguageId, defaultLanguageName: defaultLanguageName, defaultLanguageCode: defaultLanguageCode, flag: flag, isAvailable: isAvailable)
        
    } // parseDataWithDictionary
    
}
