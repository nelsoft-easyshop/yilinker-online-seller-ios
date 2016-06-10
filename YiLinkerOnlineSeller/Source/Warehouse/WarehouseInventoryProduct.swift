//
//  WarehouseInventoryProduct.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 6/8/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseInventoryProduct: NSObject {
   
    var productUnitId: String = ""
    var name: String = ""
    var sku: String = ""
    var quantity: Int = 0
    
    init(productUnitId: String, name: String, sku: String, quantity: Int) {
        self.productUnitId = productUnitId
        self.name = name
        self.sku = sku
        self.quantity = quantity
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> WarehouseInventoryProduct {
        var productUnitId: String = ""
        var name: String = ""
        var sku: String = ""
        var quantity: Int = 0
        
        productUnitId = ParseHelper.string(dictionary, key: "productUnitId", defaultValue: "")
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        sku = ParseHelper.string(dictionary, key: "sku", defaultValue: "")
        quantity = ParseHelper.int(dictionary, key: "quantity", defaultValue: 0)
        
        return WarehouseInventoryProduct(productUnitId: productUnitId, name: name, sku: sku, quantity: quantity)
    }
    
    class func parseArrayWithDictionary(dictionary: AnyObject) -> [WarehouseInventoryProduct] {
        var inventoryProducts: [WarehouseInventoryProduct] = []
        
        let data = ParseHelper.dictionary(dictionary, key: "data", defaultValue: NSDictionary())
        
        for product in ParseHelper.array(data, key: "inventoryProducts", defaultValue: []) {
            inventoryProducts.append(WarehouseInventoryProduct.parseDataWithDictionary(product))
        }
        
        return inventoryProducts
    }
    
    class func getTotalPage(dictionary: AnyObject) -> Int {
        let data = ParseHelper.dictionary(dictionary, key: "data", defaultValue: NSDictionary())
        return ParseHelper.int(data, key: "totalpage", defaultValue: 1)
    }
}
