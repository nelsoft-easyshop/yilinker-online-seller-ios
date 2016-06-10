//
//  ProductTranslationUnitModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/30/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductTranslationUnitModel: NSObject {
   
    var productUnitId: String = ""
    var quantity: Int = 0
    var sku: String = ""
    var price: String = ""
    var discountedPrice: String = ""
    var discount: Int = 0
    var length: String = ""
    var width: String = ""
    var height: String = ""
    var weight: String = ""
    var attributes: [ProductUnitAttributeModel] = []
    var images: [ProductTranslationImageModel] = []
    
    init(productUnitId: String, quantity: Int, sku: String, price: String, discountedPrice: String, discount: Int, length: String, width: String, height: String, weight: String, attributes: [ProductUnitAttributeModel], images: [ProductTranslationImageModel]) {
        self.productUnitId = productUnitId
        self.quantity = quantity
        self.sku = sku
        self.price = price
        self.discountedPrice = discountedPrice
        self.discount = discount
        self.length = length
        self.width = width
        self.height = height
        self.weight = weight
        self.attributes = attributes
        self.images = images
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductTranslationUnitModel {
        var productUnitId: String = ""
        var quantity: Int = 0
        var sku: String = ""
        var price: String = ""
        var discountedPrice: String = ""
        var discount: Int = 0
        var length: String = ""
        var width: String = ""
        var height: String = ""
        var weight: String = ""
        var attributes: [ProductUnitAttributeModel] = []
        var images: [ProductTranslationImageModel] = []
        
        productUnitId = ParseHelper.string(dictionary, key: "productUnitId", defaultValue: "")
        quantity = ParseHelper.int(dictionary, key: "quantity", defaultValue: 0)
        sku = ParseHelper.string(dictionary, key: "sku", defaultValue: "")
        price = ParseHelper.string(dictionary, key: "price", defaultValue: "")
        discountedPrice = ParseHelper.string(dictionary, key: "discountedPrice", defaultValue: "")
        discount = ParseHelper.int(dictionary, key: "discount", defaultValue: 0)
        length = ParseHelper.string(dictionary, key: "length", defaultValue: "")
        width = ParseHelper.string(dictionary, key: "width", defaultValue: "")
        height = ParseHelper.string(dictionary, key: "height", defaultValue: "")
        weight = ParseHelper.string(dictionary, key: "weight", defaultValue: "")
        attributes = ProductUnitAttributeModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "attributes", defaultValue: []))
        images = ProductTranslationImageModel.parseArrayDataWithDictionary(ParseHelper.array(dictionary, key: "images", defaultValue: []))
        
        return ProductTranslationUnitModel(productUnitId: productUnitId, quantity: quantity, sku: sku, price: price, discountedPrice: discountedPrice, discount: discount, length: length, width: width, height: height, weight: weight, attributes: attributes, images: images)
    }
    
    class func parseArrayDataWithDictionary(arr: NSArray) -> [ProductTranslationUnitModel] {
        var units: [ProductTranslationUnitModel] = []
        
        for subValue in arr {
            units.append(ProductTranslationUnitModel.parseDataWithDictionary(subValue))
        }
        
        return units
    }
}
