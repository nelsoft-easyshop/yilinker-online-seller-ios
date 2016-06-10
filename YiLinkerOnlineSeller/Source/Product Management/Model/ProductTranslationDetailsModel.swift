//
//  ProductTranslationDetailsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductTranslationDetailsModel: NSObject {
   
    var productId: String = ""
    var name: String = ""
    var shortDescription: String = ""
    var productDescription: String = ""
    var youtubeVideoUrl: String = ""
    var productConditionId: Int = 0
    var productConditionName: String = ""
    var productCategoryId: Int = 0
    var productCategoryName: String = ""
    var shippingCategoryId: Int = 0
    var shippingCategoryName: String = ""
    var brandId: Int = 0
    var status: Int = 0
    var hasCombination: Bool = false
    var brandName: String = ""
    var productGroups: [String] = []
    var productImages: [ProductTranslationImageModel] = []
    var productUnits: [ProductTranslationUnitModel] = []
    var productVariants: [ProductTranslationVariantModel] = []
    
    init(productId: String, name: String, shortDescription: String, productDescription: String, youtubeVideoUrl: String, productConditionId: Int, productConditionName: String, productCategoryId: Int, productCategoryName: String, shippingCategoryId: Int, shippingCategoryName: String, brandId: Int, status: Int, hasCombination: Bool, brandName: String, productGroups: [String], productImages: [ProductTranslationImageModel], productUnits: [ProductTranslationUnitModel], productVariants: [ProductTranslationVariantModel]) {
        
        self.productId = productId
        self.name = name
        self.shortDescription = shortDescription
        self.productDescription = productDescription
        self.youtubeVideoUrl = youtubeVideoUrl
        self.productConditionId = productConditionId
        self.productConditionName = productConditionName
        self.productCategoryId = productCategoryId
        self.productCategoryName = productCategoryName
        self.shippingCategoryId = shippingCategoryId
        self.shippingCategoryName = shippingCategoryName
        self.brandId = brandId
        self.status = status
        self.hasCombination = hasCombination
        self.brandName = brandName
        self.productGroups = productGroups
        self.productImages = productImages
        self.productUnits = productUnits
        self.productVariants = productVariants
        
    }
    
    init(productId: String) {
        self.productId = productId
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductTranslationDetailsModel {
        var productId: String = ""
        var name: String = ""
        var shortDescription: String = ""
        var productDescription: String = ""
        var youtubeVideoUrl: String = ""
        var productConditionId: Int = 0
        var productConditionName: String = ""
        var productCategoryId: Int = 0
        var productCategoryName: String = ""
        var shippingCategoryId: Int = 0
        var shippingCategoryName: String = ""
        var brandId: Int = 0
        var status: Int = 0
        var hasCombination: Bool = false
        var brandName: String = ""
        var productGroups: [String] = []
        var productImages: [ProductTranslationImageModel] = []
        var productUnits: [ProductTranslationUnitModel] = []
        var productVariants: [ProductTranslationVariantModel] = []
        
        productId = ParseHelper.string(dictionary, key: "productId", defaultValue: "")
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        shortDescription = ParseHelper.string(dictionary, key: "shortDescription", defaultValue: "")
        productDescription = ParseHelper.string(dictionary, key: "description", defaultValue: "")
        youtubeVideoUrl = ParseHelper.string(dictionary, key: "youtubeVideoUrl", defaultValue: "")
        productConditionId = ParseHelper.int(dictionary, key: "productConditionId", defaultValue: 0)
        productConditionName = ParseHelper.string(dictionary, key: "productConditionName", defaultValue: "")
        productCategoryId = ParseHelper.int(dictionary, key: "productCategoryId", defaultValue: 0)
        productCategoryName = ParseHelper.string(dictionary, key: "productCategoryName", defaultValue: "")
        shippingCategoryId = ParseHelper.int(dictionary, key: "shippingCategoryId", defaultValue: 0)
        shippingCategoryName = ParseHelper.string(dictionary, key: "shippingCategoryName", defaultValue: "")
        brandId = ParseHelper.int(dictionary, key: "brandId", defaultValue: 0)
        status = ParseHelper.int(dictionary, key: "status", defaultValue: 0)
        hasCombination = ParseHelper.bool(dictionary, key: "hasCombination", defaultValue: false)
        brandName = ParseHelper.string(dictionary, key: "brandName", defaultValue: "")
        
        if let temp = ParseHelper.array(dictionary, key: "productGroups", defaultValue: []) as? [String] {
            productGroups = temp
        }
        
        productImages = ProductTranslationImageModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "productImages", defaultValue: []))
        productUnits = ProductTranslationUnitModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "productUnits", defaultValue: []))
        productVariants = ProductTranslationVariantModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "productVariants", defaultValue: []))
        
        
        return ProductTranslationDetailsModel(productId: productId,
            name: name,
            shortDescription: shortDescription,
            productDescription: productDescription,
            youtubeVideoUrl: youtubeVideoUrl,
            productConditionId: productConditionId,
            productConditionName: productConditionName,
            productCategoryId: productCategoryId,
            productCategoryName: productCategoryName,
            shippingCategoryId: shippingCategoryId,
            shippingCategoryName: shippingCategoryName,
            brandId: brandId,
            status: status,
            hasCombination: hasCombination,
            brandName: brandName,
            productGroups: productGroups,
            productImages: productImages,
            productUnits: productUnits,
            productVariants: productVariants)
        
    }
    
}
