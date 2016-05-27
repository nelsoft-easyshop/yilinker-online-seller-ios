//
//  CountryListModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 5/16/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

typealias DefaultLanguage = (id: Int, name: String, code: String)
typealias Currency = (id: Int, code: String, name: String, symbol: String, rate: String)

class CountryListModel: NSObject {
   
    var message: String = ""
    var isSuccessful: Bool = false
    
    var countryId: Int = 0
    var name: String = ""
    var code: String = ""
    var domain: String = ""
    var area_code: String = ""
    var isActive: Bool = false
    var defaultLanguage: DefaultLanguage!
    var flag: String = ""
    var isAvailable: Bool = false
    var currency: Currency!
    
    init(message: String, isSuccessful: Bool, countryId: Int, name: String, code: String, domain: String, area_code: String, isActive: Bool, defaultLanguage: DefaultLanguage, /*defaultLanguageId: Int, defaultLanguageName: String, defaultLanguageCode: String,*/ flag: String, isAvailable: Bool, currency: Currency) {
        
        self.countryId = countryId
        self.name = name
        self.code = code
        self.domain = domain
        self.area_code = area_code
        self.isActive = isActive
        self.defaultLanguage = defaultLanguage
//        self.defaultLanguageId = defaultLanguageId
//        self.defaultLanguageName = defaultLanguageName
//        self.defaultLanguageCode = defaultLanguageCode
        self.flag = flag
        self.isAvailable = isAvailable
        self.currency = currency
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
        var defaultLanguage: DefaultLanguage!
//        var defaultLanguageId: Int = 0
//        var defaultLanguageName: String = ""
//        var defaultLanguageCode: String = ""
        var flag: String = ""
        var isAvailable: Bool = false
        var currency: Currency!
        
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
        
        if let language: AnyObject = data["defaultLanguage"] {
            var defaultLanguageElement: DefaultLanguage
            defaultLanguageElement.id = ParseHelper.int(language, key: "id", defaultValue: 0)
            defaultLanguageElement.name = ParseHelper.string(language, key: "name", defaultValue: "")
            defaultLanguageElement.code = ParseHelper.string(language, key: "code", defaultValue: "")
            defaultLanguage = defaultLanguageElement
        }
        
        flag = ParseHelper.string(data, key: "flag", defaultValue: "")
        isAvailable = ParseHelper.bool(data, key: "isAvailable", defaultValue: false)
        
        if let curData: AnyObject = data["currency"] {
            var currencyElement: Currency
            currencyElement.id = ParseHelper.int(curData, key: "id", defaultValue: 0)
            currencyElement.code = ParseHelper.string(curData, key: "code", defaultValue: "")
            currencyElement.name = ParseHelper.string(curData, key: "name", defaultValue: "")
            currencyElement.symbol = ParseHelper.string(curData, key: "symbol", defaultValue: "")
            currencyElement.rate = ParseHelper.string(curData, key: "rate", defaultValue: "")
            currency = currencyElement
        }
        
//            }  data
//        }  dictionary
    
        return CountryListModel(message: message, isSuccessful: isSuccessful, countryId: countryId, name: name, code: code, domain: domain, area_code: area_code, isActive: isActive, defaultLanguage: defaultLanguage, flag: flag, isAvailable: isAvailable, currency: currency)
        
//        return CountryListModel(message: message, isSuccessful: isSuccessful, countryId: countryId, name: name, code: code, domain: domain, area_code: area_code, isActive: isActive, defaultLanguage: defaultLanguage,/*defaultLanguageId: defaultLanguageId, defaultLanguageName: defaultLanguageName, defaultLanguageCode: defaultLanguageCode,*/ flag: flag, isAvailable: isAvailable, currency: currency)
        
    } // parseDataWithDictionary
    
}
