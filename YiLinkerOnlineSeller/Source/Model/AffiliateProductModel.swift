//
//  AffiliateProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AffiliateProductModel: NSObject {
    var dateAdded: String = ""
    
    var name: String = ""
    var storeName: String = ""
    
    var category: String = ""
    var brand: String = ""
    
    var condition: String = ""
    var commission: String = ""
    
    var originalPrice: String = ""
    var discountedPrice: String = ""
    var discount: String = ""
    
    var earning: String = ""
    
    var isSelected: Bool = false
    
    var images: [String] = []
    
    var isLoading: Bool = false
    
    var manufacturerProductId: Int = 0
    
    init(dateAdded: String, name: String, storeName: String, category: String, brand: String, condition: String, commission: String, originalPrice: String, discountedPrice: String, discount: String, earning: String, isSelected: Bool, images: [String], manufacturerProductId: Int) {
        self.dateAdded = dateAdded
        self.name = name
        self.storeName = storeName
        
        self.category = category
        self.brand = brand
        
        self.condition = condition
        self.commission = commission
        
        self.originalPrice = originalPrice
        self.discount = discount
        
        self.earning = earning
        
        self.isSelected = isSelected
        
        self.images = images
        
        self.discountedPrice = discountedPrice
        
        self.manufacturerProductId = manufacturerProductId
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> AffiliateProductModel {
        var dateAdded: String = ""
        var name: String = ""
        var storeName: String = ""
        
        var category: String = ""
        var brand: String = ""
        
        var condition: String = ""
        var commission: String = ""
        
        var originalPrice: String = ""
        var discount: String = ""
        
        var earning: String = ""
        
        var isSelected: Bool = false
        
        var images: [String] = []
        
        var discountedPrice: String = ""
        
        var manufacturerProductId: Int = 0
        
        dateAdded = ParseHelper.string(dictionary, key: "dateAdded", defaultValue: "")
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        storeName = ParseHelper.string(dictionary, key: "storeName", defaultValue: "")
        category = ParseHelper.string(dictionary, key: "category", defaultValue: "")
        brand = ParseHelper.string(dictionary, key: "brand", defaultValue: "")
        condition = ParseHelper.string(dictionary, key: "condition", defaultValue: "")
        originalPrice = ParseHelper.string(dictionary, key: "originalPrice", defaultValue: "")
        discountedPrice = ParseHelper.string(dictionary, key: "discountedPrice", defaultValue: "")
        commission = ParseHelper.string(dictionary, key: "commission", defaultValue: "")
        discount = ParseHelper.string(dictionary, key: "discount", defaultValue: "")
        
        if let arrayOfImages = dictionary["images"] as? NSArray {
            for image in arrayOfImages {
                images.append(image as! String)
            }
        }
        
        manufacturerProductId = ParseHelper.int(dictionary, key: "manufacturerProductId", defaultValue: 0)
        
        isSelected = ParseHelper.bool(dictionary, key: "isSelected", defaultValue: false)
        
        return AffiliateProductModel(dateAdded: dateAdded, name: name, storeName: storeName, category: category, brand: brand, condition: condition, commission: commission, originalPrice: originalPrice, discountedPrice: discountedPrice, discount: discount, earning: earning, isSelected: isSelected, images: images, manufacturerProductId: manufacturerProductId)
    }
}
