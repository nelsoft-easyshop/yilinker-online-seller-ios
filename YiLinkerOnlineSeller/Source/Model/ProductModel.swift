//
//  ProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductModel {
    var attributes: [AttributeModel] = []
    var validCombinations: [CombinationModel] = []
    var images: [UIImage] = []
    
    var category: CategoryModel = CategoryModel(uid: 0, name: "", hasChildren: "")
    var brand: BrandModel = BrandModel(name: "", brandId:1)
    var condition: ConditionModel = ConditionModel(uid: 0, name: "")
    var quantity: Int = 0
    
    var name: String = ""
    var shortDescription: String = ""
    var completeDescription: String = ""
    var sku: String = ""
    var retailPrice: String = "0"
    var discoutedPrice: String = "0"
    var width = ""
    var height = ""
    var length = ""
    var weigth = ""
    
    var message: String = ""
    var isSuccessful: Bool = false
    var imageUrls: [String] = []
    
    init (attributes: [AttributeModel], validCombinations: [CombinationModel]) {
        self.attributes = attributes
        self.validCombinations = validCombinations
    }
    
    init (isSuccessful: Bool, message: String, attributes: [AttributeModel], validCombinations: [CombinationModel], images: [String], category: CategoryModel, brand: BrandModel, condition: ConditionModel, name: String, shortDescription: String, completeDescription: String) {
    
        self.isSuccessful = isSuccessful
        self.message = message
        self.attributes = attributes
        self.validCombinations = validCombinations
        self.imageUrls = images
        self.category = category
        self.brand = brand
        self.condition = condition
        self.name = name
        self.shortDescription = shortDescription
        self.completeDescription = completeDescription
    }
    
    init() {
        
    }
    
    func copy() -> ProductModel {
        return ProductModel(attributes: self.attributes, validCombinations: self.validCombinations)
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var attributes: [AttributeModel] = []
        var validCombinations: [CombinationModel] = []
        var images: [String] = []
        
        var category: CategoryModel = CategoryModel(uid: 0, name: "", hasChildren: "")
        var brand: BrandModel = BrandModel(name: "", brandId:1)
        var condition: ConditionModel = ConditionModel(uid: 0, name: "")
        
        var name: String = ""
        var shortDescription: String = ""
        var completeDescription: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {

                if let name = value["brandName"] as? String {
                    brand = BrandModel(name: name, brandId: value["brandId"] as! Int)
                }
                
                if let name = value["categoryName"] as? String {
                    category = CategoryModel(uid: value["categoryId"] as! Int, name: name, hasChildren: "")
                }
                
                if let name = value["conditionName"] as? String {
                    condition = ConditionModel(uid: value["conditionId"] as! Int, name: name)
                }
                
                if let tempVar = value["title"] as? String {
                    name = tempVar
                }
                
                if let tempVar = value["shortDescription"] as? String {
                    shortDescription = tempVar
                }
                
                if let tempVar = value["description"] as? String {
                    completeDescription = tempVar
                }
                
                images = ["", ""]
//                images = value["images"] as! [String]
                
                var attributeModel = AttributeModel()
                for subValue in value["productVariants"] as! NSArray {
                    attributeModel.definition = subValue["name"] as! String
                    attributeModel.values = subValue["values"] as! [String]
                    attributes.append(attributeModel)
                }
                
                var combination = CombinationModel()
                for subValue in value["productProperties"] as! NSArray {
                    combination.combinationID = subValue["id"] as! String
                    combination.attributes = subValue["attributes"] as! NSArray as! [NSMutableDictionary]
                    combination.retailPrice = subValue["price"] as! String
                    combination.discountedPrice = subValue["discountedPrice"] as! String
                    combination.quantity = String(subValue["quantity"] as! Int)
                    combination.sku = subValue["sku"] as! String
                    combination.images = subValue["images"] as! NSArray as! [UIImage]
                    
                    combination.weight = subValue["unitWeight"] as! String
                    combination.height = subValue["unitHeight"] as! String
                    combination.length = subValue["unitLength"] as! String
                    combination.width = subValue["unitWidth"] as! String
                    
                    validCombinations.append(combination)
                }
                
            } // data
        } // dictionary
        
        return ProductModel(isSuccessful: isSuccessful, message: message, attributes: attributes, validCombinations: validCombinations, images: images, category: category, brand: brand, condition: condition, name: name, shortDescription: shortDescription, completeDescription: completeDescription)
        
    } // parseDataWithDictionary
}
