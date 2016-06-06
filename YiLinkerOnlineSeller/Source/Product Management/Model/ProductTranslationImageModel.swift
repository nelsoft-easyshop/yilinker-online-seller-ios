//
//  ProductTranslationImageModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductTranslationImageModel: NSObject {
    var raw: String = ""
    var imageLocation: String = ""
    var thumbnail: String = ""
    var small: String = ""
    var medium: String = ""
    var large: String = ""
    var isSelected: Bool = false
    var isPrimary: Bool = false
    var fullImageLocation: String = ""
    var isDeleted: Bool = false
    var defaultLocale: String = ""
    
    init(raw: String, imageLocation: String, thumbnail: String, small: String, medium: String, large: String, isSelected: Bool, isPrimary: Bool, fullImageLocation: String, isDeleted: Bool, defaultLocale: String) {
        self.raw = raw
        self.imageLocation = imageLocation
        self.thumbnail = thumbnail
        self.small = small
        self.medium = medium
        self.large = large
        self.isSelected = isSelected
        self.isPrimary = isPrimary
        self.fullImageLocation = fullImageLocation
        self.isDeleted = isDeleted
        self.defaultLocale = defaultLocale
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductTranslationImageModel {
        var raw: String = ""
        var imageLocation: String = ""
        var thumbnail: String = ""
        var small: String = ""
        var medium: String = ""
        var large: String = ""
        var isSelected: Bool = false
        var isPrimary: Bool = false
        var fullImageLocation: String = ""
        var isDeleted: Bool = false
        var defaultLocale: String = ""
        
        raw = ParseHelper.string(dictionary, key: "raw", defaultValue: "")
        imageLocation = ParseHelper.string(dictionary, key: "imageLocation", defaultValue: "")
        
        let tempSizes = ParseHelper.dictionary(dictionary, key: "sizes", defaultValue: NSDictionary())
        thumbnail = ParseHelper.parseString(tempSizes, key: "thumbnail", defaultValue: "")
        small = ParseHelper.parseString(tempSizes, key: "small", defaultValue: "")
        medium = ParseHelper.parseString(tempSizes, key: "medium", defaultValue: "")
        large = ParseHelper.parseString(tempSizes, key: "large", defaultValue: "")
        
        isSelected = ParseHelper.bool(dictionary, key: "isSelected", defaultValue: false)
        isPrimary = ParseHelper.bool(dictionary, key: "isPrimary", defaultValue: false)
        fullImageLocation = ParseHelper.string(dictionary, key: "fullImageLocation", defaultValue: "")
        isDeleted = ParseHelper.bool(dictionary, key: "isDeleted", defaultValue: false)
        defaultLocale = ParseHelper.string(dictionary, key: "defaultLocale", defaultValue: "")
        
        return ProductTranslationImageModel(raw: raw, imageLocation: imageLocation, thumbnail: thumbnail, small: small, medium: medium, large: large, isSelected: isSelected, isPrimary: isPrimary, fullImageLocation: fullImageLocation, isDeleted: isDeleted, defaultLocale: defaultLocale)
    }
    
    class func parseArrayDataWithDictionary(arr: NSArray) -> [ProductTranslationImageModel] {
        var images: [ProductTranslationImageModel] = []
        
        for subValue in arr {
            images.append(ProductTranslationImageModel.parseDataWithDictionary(subValue))
        }
        
        return images
    }
}
