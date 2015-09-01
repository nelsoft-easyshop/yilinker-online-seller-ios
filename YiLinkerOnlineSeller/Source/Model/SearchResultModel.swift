//
//  SearchResultModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchResultModel: NSObject {
   
    var id: String = ""
    var productName: String = ""
    var originalPrice: String = ""
    var newPrice: String = ""
    var imageUrl: String = ""
    var discount: Int = 0
    var slug: String = ""
    
    init(id: String, productName: String, originalPrice: String, newPrice: String, imageUrl: String,discount: Int, slug: String){
        self.id = id
        self.productName = productName
        self.originalPrice = originalPrice
        self.newPrice = newPrice
        self.imageUrl = imageUrl
        self.discount = discount
        self.slug = slug
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> SearchResultModel {
        var id: String = ""
        var productName: String = ""
        var originalPrice: String = ""
        var newPrice: String = ""
        var imageUrl: String = ""
        var discount: Int = 0
        var slug: String = ""
        
        if let value: AnyObject = dictionary["id"] {
            if value as! NSObject != NSNull() {
                id = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["productName"] {
            if value as! NSObject != NSNull() {
                productName = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["originalPrice"] {
            if value as! NSObject != NSNull() {
                originalPrice = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["newPrice"] {
            if value as! NSObject != NSNull() {
                newPrice = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["imageUrl"] {
            if value as! NSObject != NSNull() {
                imageUrl = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["discount"] {
            if value as! NSObject != NSNull() {
                discount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["slug"] {
            if value as! NSObject != NSNull() {
                slug = value as! String
            }
        }
        
        return SearchResultModel(id: id, productName: productName, originalPrice: originalPrice, newPrice: newPrice, imageUrl: imageUrl, discount: discount, slug: slug)
    }

}
