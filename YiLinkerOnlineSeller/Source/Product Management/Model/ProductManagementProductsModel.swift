//
//  ProductManagementProductsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

typealias DateElement = (date: String, timezone_type: Int, timezone: String)
typealias SelectedCountriesElement = (code: String, countryId: Int, image: String, name: String)
typealias SelectedLanguagesElement = (countryCode: String, countryId: Int, countryName: String, languageCode: String, languageId: String, languageName: String)

class ProductManagementProductsModel {
    
    var id: String = ""
    var name: String = ""
    var category: String = ""
    var image: String = ""
    var status: Int = 0
    var slug: String = ""
    var dateCreated: DateElement!
    var dateLastModified: DateElement!
    var selectedCountries: [SelectedCountriesElement] = []
    var selectedLanguages: [SelectedLanguagesElement] = []
    
    class func parseDataWithDictionary(products: AnyObject) -> ProductManagementProductsModel {
        
        var model = ProductManagementProductsModel()
        if products.isKindOfClass(NSDictionary) {

            model.id = products["id"] as! String
            model.name = products["name"] as! String

            if !(products["category"] is NSNull) {
                model.category = products["category"] as! String
            } else {
                model.category = "Not Categorized"
            }

            model.image = products["image"] as! String
            model.status = products["status"] as! Int
         
            // dateCreated
            if let dateCreatedData: AnyObject = products["dateCreated"] {
                var element: DateElement
                element.date = ParseHelper.string(dateCreatedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateCreatedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateCreatedData, key: "timezone", defaultValue: "")
                model.dateCreated = element
            }
            // dateLastModified
            if let dateLastModifiedData: AnyObject = products["dateLastModified"] {
                var element: DateElement
                element.date = ParseHelper.string(dateLastModifiedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateLastModifiedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateLastModifiedData, key: "timezone", defaultValue: "")
                model.dateLastModified = element
            }
            // selectedCountries
            for selectedCountry in products["selectedCountries"] as! NSArray {
                var element: SelectedCountriesElement
                element.code = ParseHelper.string(selectedCountry, key: "code", defaultValue: "")
                element.countryId = ParseHelper.int(selectedCountry, key: "countryId", defaultValue: 0)
                element.image = ParseHelper.string(selectedCountry, key: "image", defaultValue: "")
                element.name = ParseHelper.string(selectedCountry, key: "name", defaultValue: "")
                model.selectedCountries.append(element)
            }
//            if let dateCreatedData: AnyObject = products["dateCreated"] {
//                var element: SelectedCountriesElement
//                element.code = ParseHelper.string(dateCreatedData, key: "code", defaultValue: "")
//                element.countryId = ParseHelper.int(dateCreatedData, key: "countryId", defaultValue: 0)
//                element.image = ParseHelper.string(dateCreatedData, key: "image", defaultValue: "")
//                element.name = ParseHelper.string(dateCreatedData, key: "name", defaultValue: "")
//                model.selectedCountries.append(element)
//            }
            // selectedLanguages
            for selectedLanguage in products["selectedLanguages"] as! NSArray {
                var element: SelectedLanguagesElement
                element.countryCode = ParseHelper.string(selectedLanguage, key: "countryCode", defaultValue: "")
                element.countryId = ParseHelper.int(selectedLanguage, key: "countryId", defaultValue: 0)
                element.countryName = ParseHelper.string(selectedLanguage, key: "countryName", defaultValue: "")
                element.languageCode = ParseHelper.string(selectedLanguage, key: "languageCode", defaultValue: "")
                element.languageId = ParseHelper.string(selectedLanguage, key: "languageId", defaultValue: "")
                element.languageName = ParseHelper.string(selectedLanguage, key: "languageName", defaultValue: "")
                model.selectedLanguages.append(element)
            }
//            if let dateCreatedData: AnyObject = products["dateCreated"] {
//                var element: SelectedLanguagesElement
//                element.countryCode = ParseHelper.string(dateCreatedData, key: "countryCode", defaultValue: "")
//                element.countryId = ParseHelper.int(dateCreatedData, key: "countryId", defaultValue: 0)
//                element.countryName = ParseHelper.string(dateCreatedData, key: "countryName", defaultValue: "")
//                element.languageCode = ParseHelper.string(dateCreatedData, key: "languageCode", defaultValue: "")
//                element.languageId = ParseHelper.string(dateCreatedData, key: "languageId", defaultValue: "")
//                element.languageName = ParseHelper.string(dateCreatedData, key: "languageName", defaultValue: "")
//                model.selectedLanguages.append(element)
//            }
        }
        return model
    }
}