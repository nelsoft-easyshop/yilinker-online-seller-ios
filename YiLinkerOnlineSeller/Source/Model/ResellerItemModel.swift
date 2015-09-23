//
//  ResellerItemModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerItemModel: NSObject {
    var status: ResellerItemStatus = ResellerItemStatus.Unselected
    var productName: String = ""
    var manufacturer: String = ""
    var imageUrl: String = ""
    var uid: Int = 0
    
    override init() {
        super.init()
    }
    
    init(status: ResellerItemStatus, productName: String, manufacturer: String, imageUrl: String, uid: Int) {
        self.status = status
        self.productName = productName
        self.manufacturer = manufacturer
        self.imageUrl = imageUrl
        self.uid = uid
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> ResellerItemModel {
        let manufacturerKey: String = "manufacturer"
        let imageKey: String = "image"
        let productNameKey: String = "productName"
        let productIdKey: String = "id"
        
        
        var status: ResellerItemStatus = ResellerItemStatus.Unselected
        var productName: String = ""
        var manufacturer: String = ""
        var imageUrl: String = ""
        var uid: Int = 0
        
        if dictionary[manufacturerKey] != nil {
            if let tempVar = dictionary[manufacturerKey] as? String {
                manufacturer = tempVar
            }
        }
        
        if dictionary[productNameKey] != nil {
            if let tempVar = dictionary[productNameKey] as? String {
                productName = tempVar
            }
        }
        
        if dictionary[imageKey] != nil {
            if let tempVar = dictionary[imageKey] as? String {
                imageUrl = tempVar
            }
        }
        
        if dictionary[productIdKey] != nil {
            if let tempVar = dictionary[productIdKey] as? Int {
                uid = tempVar
            }
        }
        
        return ResellerItemModel(status: status, productName: productName, manufacturer: manufacturer, imageUrl: imageUrl, uid: uid)
    }
}
