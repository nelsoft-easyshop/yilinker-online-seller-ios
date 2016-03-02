//
//  AffiliateGetProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/24/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AffiliateGetProductModel: NSObject {
    var isSuccessful: Bool = false
    var totalResults: Int = 0
    var totalPage: Int = 0
    var selectedProductCount: Int = 0
    var selectedManufacturerProductIds: [Int] = []
    var storeSpace: Int = 0
    var products: [AffiliateProductModel] = []
    
    override init() {}
    
    init(isSuccessful: Bool, totalResults: Int, totalPage: Int, selectedProductCount: Int, selectedManufacturerProductIds: [Int], storeSpace: Int, products: [AffiliateProductModel]) {
        self.isSuccessful = isSuccessful
        self.totalResults = totalResults
        self.totalPage = totalPage
        self.selectedManufacturerProductIds = selectedManufacturerProductIds
        self.selectedProductCount = selectedProductCount
        self.storeSpace = storeSpace
        self.products = products
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> AffiliateGetProductModel {
        var isSuccessful: Bool = false
        var totalResults: Int = 0
        var totalPage: Int = 0
        var selectedProductCount: Int = 0
        var selectedManufacturerProductIds: [Int] = []
        var storeSpace: Int = 0
        
        var products: [AffiliateProductModel] = []
        
        
        if let arrayOfSelectedIds = dictionary["selectedManufacturerProductIds"] as? [Int] {
            for uid in arrayOfSelectedIds {
                selectedManufacturerProductIds.append(uid)
            }
        }
        
        if let tempDictionary = dictionary["data"] as? NSDictionary {
            
            isSuccessful = ParseHelper.bool(tempDictionary, key: "isSuccessful", defaultValue: false)
            totalResults = ParseHelper.int(tempDictionary, key: "totalResults", defaultValue: 0)
            totalPage = ParseHelper.int(tempDictionary, key: "totalPage", defaultValue: 0)
            selectedProductCount = ParseHelper.int(tempDictionary, key: "selectedProductCount", defaultValue: 0)
            storeSpace = ParseHelper.int(tempDictionary, key: "storeSpace", defaultValue: 0)
            
            if let affiliateProducts = tempDictionary["products"] as? [NSDictionary] {
                for product in affiliateProducts {
                    products.append(AffiliateProductModel.parseDataFromDictionary(product))
                }
            }
        }
        
        return AffiliateGetProductModel(isSuccessful: isSuccessful, totalResults: totalResults, totalPage: totalPage, selectedProductCount: selectedProductCount, selectedManufacturerProductIds: selectedManufacturerProductIds, storeSpace: storeSpace, products: products)
    }
}
