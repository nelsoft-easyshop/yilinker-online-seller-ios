//
//  ProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ProductCroppedImages {
    static var imagesCropped: [UIImage] = []
}

class ProductModel {
    var attributes: [AttributeModel] = []
    var validCombinations: [CombinationModel] = []
    var images: [UIImage] = []
    var imagesCropped: [UIImage] = []
    
    var category: CategoryModel = CategoryModel(uid: 0, name: "", hasChildren: "")
    var brand: BrandModel = BrandModel(name: "", brandId:1)
    var condition: ConditionModel = ConditionModel(uid: 0, name: "")
    var quantity: Int = 1
    var uid: String = "0"
    
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
    var imageIds: [String] = []
    var productUnitId: String = ""
    var editedImage: [ServerUIImage] = []
    var oldEditedCombinationImages: [ServerUIImage] = []
    
    init (attributes: [AttributeModel], validCombinations: [CombinationModel]) {
        self.attributes = attributes
        self.validCombinations = validCombinations
    }
    
    init (isSuccessful: Bool, message: String, attributes: [AttributeModel], validCombinations: [CombinationModel], images: [String], imageIds: [String], category: CategoryModel, brand: BrandModel, condition: ConditionModel, name: String, shortDescription: String, completeDescription: String, productId: String,  quantity: Int, retailPrice: String, discountedPrice: String, weight: String, height: String, length: String, width: String, sku: String, productUnitId: String) {
    
        self.isSuccessful = isSuccessful
        self.message = message
        self.attributes = attributes
        self.validCombinations = validCombinations
        self.imageUrls = images
        self.imageIds = imageIds
        self.category = category
        self.brand = brand
        self.condition = condition
        self.name = name
        self.shortDescription = shortDescription
        self.completeDescription = completeDescription
        self.uid = productId
        self.quantity = quantity
        self.attributes = attributes
        self.retailPrice = retailPrice
        self.discoutedPrice = discountedPrice
        self.width = width
        self.weigth = weight
        self.length = length
        self.height = height
        self.sku = sku
        self.productUnitId = productUnitId
    }
    
    init() {
        self.attributes = []
        self.validCombinations = []
        self.images = []
        
        self.category = CategoryModel(uid: 0, name: "", hasChildren: "")
        self.brand = BrandModel(name: "", brandId:1)
        self.condition = ConditionModel(uid: 0, name: "")
        self.quantity = 1
        self.uid = "0"
        
        self.name = ""
        self.shortDescription = ""
        self.completeDescription = ""
        self.sku = ""
        self.retailPrice = "0"
        self.discoutedPrice = "0"
        self.width = ""
        self.height = ""
        self.length = ""
        self.weigth = ""
        
        self.message = ""
        self.isSuccessful = false
        self.imageUrls = []
        self.imageIds = []
        self.productUnitId = ""
        self.editedImage = []
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
        var imageIds: [String] = []
        
        var category: CategoryModel = CategoryModel(uid: 0, name: "", hasChildren: "")
        var brand: BrandModel = BrandModel(name: "", brandId: 1)
        var condition: ConditionModel = ConditionModel(uid: 0, name: "")
        
        var name: String = ""
        var shortDescription: String = ""
        var completeDescription: String = ""
        var uid: String = "0"
        
        var sku: String = ""
        var retailPrice: String = "0"
        var discoutedPrice: String = "0"
        var width = ""
        var height = ""
        var length = ""
        var weigth = ""
        var productUnitId = ""
        var quantity = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            message = ParseHelper.string(dictionary, key: "message", defaultValue: "")
            isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            
//            if let tempVar = dictionary["message"] as? String {
//                message = tempVar
//            }
//            
//            if let tempVar = dictionary["isSuccessful"] as? Bool {
//                isSuccessful = tempVar
//            }
            
            if let value: AnyObject = dictionary["data"] {


                if let name = value["brandName"] as? String {
                    brand = BrandModel(name: name, brandId: value["brandId"] as! Int)
                }

                // brand
                productUnitId = ParseHelper.string(value, key: "productUnitId", defaultValue: "")
                // category
                // condition
                name = ParseHelper.string(value, key: "title", defaultValue: "")
                uid = ParseHelper.string(value, key: "productId", defaultValue: "")
                shortDescription = ParseHelper.string(value, key: "shortDescription", defaultValue: "")
                completeDescription = ParseHelper.string(value, key: "description", defaultValue: "")
                
                
//                if let unitId = value["productUnitId"] as? String {
//                    productUnitId = unitId
//                }
                
                if let name = value["categoryName"] as? String {
                    category = CategoryModel(uid: ParseHelper.int(value, key: "categoryId", defaultValue: 0), name: name, hasChildren: "")
                }
                
                if let name = value["conditionName"] as? String {
                    condition = ConditionModel(uid: ParseHelper.int(value, key: "conditionId", defaultValue: 0), name: name)
                }
                
//                if let tempVar = value["title"] as? String {
//                    name = tempVar
//                }
//                
//                if let tempVar = value["productId"] as? String {
//                    uid = tempVar
//                }
//                
//                if let tempVar = value["shortDescription"] as? String {
//                    shortDescription = tempVar
//                }
//                
//                if let tempVar = value["description"] as? String {
//                    completeDescription = tempVar
//                }
                
                if !(value["productVariants"] is NSNull) {
                    for subValue in value["productVariants"] as! NSArray {
                        var attributeModel = AttributeModel()
                        attributeModel.definition = ParseHelper.string(subValue, key: "name", defaultValue: "")
                        attributeModel.values = ParseHelper.array(subValue, key: "values", defaultValue: []) as! [String]
//                        attributeModel.definition = subValue["name"] as! String
//                        attributeModel.values = subValue["values"] as! [String]
                        attributes.append(attributeModel)
                    }
                }
                
                let properties: NSArray = value["productProperties"] as! NSArray
                if properties.count == 0 {
                    var combination = CombinationModel()
                    combination.combinationID = ""
                    combination.attributes = []
                    combination.retailPrice = "0.0"
                    combination.discountedPrice = "0.0"
                    combination.quantity = "0"
                    combination.sku = ""
                    combination.productUnitId = ""
                    combination.images = []
                    
                    combination.weight = "0.0"
                    combination.height = "0.0"
                    combination.length = "0.0"
                    combination.width = "0.0"
                } else if properties.count > 0 {
                    if !(value["productVariants"] is NSNull) {
                        var productAttributes: [NSDictionary] = value["productVariants"] as! [NSDictionary]
                        if productAttributes.count == 0 {
                            for subValue in value["productProperties"] as! NSArray {
                                quantity = ParseHelper.int(subValue, key: "quantity", defaultValue: 0)
                                retailPrice = ParseHelper.string(subValue, key: "price", defaultValue: "")
                                discoutedPrice = ParseHelper.string(subValue, key: "discountedPrice", defaultValue: "")
                                sku = ParseHelper.string(subValue, key: "sku", defaultValue: "")
                                weigth = ParseHelper.string(subValue, key: "unitWeight", defaultValue: "")
                                height = ParseHelper.string(subValue, key: "unitHeight", defaultValue: "")
                                length = ParseHelper.string(subValue, key: "unitLength", defaultValue: "")
                                width = ParseHelper.string(subValue, key: "unitWidth", defaultValue: "")
                                productUnitId = ParseHelper.string(subValue, key: "productUnitId", defaultValue: "")
                                
//                                quantity = subValue["quantity"] as! Int
//                                retailPrice = subValue["price"] as! String
//                                discoutedPrice = subValue["discountedPrice"] as! String
//                                sku = subValue["sku"] as! String
//                                weigth = subValue["unitWeight"] as! String
//                                height = subValue["unitHeight"] as! String
//                                length = subValue["unitLength"] as! String
//                                width = subValue["unitWidth"] as! String
//                                productUnitId = subValue["productUnitId"] as! String
                            }
                        } else {
                            for subValue in value["productProperties"] as! NSArray {
                                var combination = CombinationModel()
                                
                                combination.combinationID = ParseHelper.string(subValue, key: "id", defaultValue: "")
                                combination.attributes = ParseHelper.array(subValue, key: "attributes", defaultValue: []) as! [NSMutableDictionary]
                                combination.retailPrice = ParseHelper.string(subValue, key: "price", defaultValue: "")
                                combination.discountedPrice = ParseHelper.string(subValue, key: "discountedPrice", defaultValue: "")
                                combination.quantity = String(ParseHelper.int(subValue, key: "quantity", defaultValue: 0))
                                combination.sku = ParseHelper.string(subValue, key: "sku", defaultValue: "")
                                
//                                combination.combinationID = subValue["id"] as! String
//                                combination.attributes = subValue["attributes"] as! [NSMutableDictionary]
//                                combination.retailPrice = subValue["price"] as! String
//                                combination.discountedPrice = subValue["discountedPrice"] as! String
//                                combination.quantity = String(subValue["quantity"] as! Int)
//                                combination.sku = subValue["sku"] as! String
                                
                                let imagesCount: NSArray = subValue["images"] as! NSArray
                                if imagesCount.count == 0 {
                                    combination.imagesUrl.append("")
                                    combination.imagesId.append("")
                                } else {
                                    for subimages in subValue["images"] as! NSArray {
//                                        var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (subimages["path"] as! String)
                                        var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (ParseHelper.string(subimages, key: "path", defaultValue: ""))
                                        url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                                        combination.imagesUrl.append(url)
                                        combination.imagesId.append(subimages["id"] as! String)
                                    }
                                }

//                                combination.productUnitId = subValue["productUnitId"] as! String
                                combination.productUnitId = ParseHelper.string(subValue, key: "productUnitId", defaultValue: "")
                                
                                combination.weight = ParseHelper.string(subValue, key: "unitWeight", defaultValue: "")
                                combination.height = ParseHelper.string(subValue, key: "unitHeight", defaultValue: "")
                                combination.length = ParseHelper.string(subValue, key: "unitLength", defaultValue: "")
                                combination.width = ParseHelper.string(subValue, key: "unitWidth", defaultValue: "")
                                
//                                combination.weight = subValue["unitWeight"] as! String
//                                combination.height = subValue["unitHeight"] as! String
//                                combination.length = subValue["unitLength"] as! String
//                                combination.width = subValue["unitWidth"] as! String
                                validCombinations.append(combination)
                            }
                            sku = validCombinations[0].sku
                            productUnitId = validCombinations[0].productUnitId
                        }
                    } else {
                        
                    }
                }
                
                if let imagesValue = value["images"] as? NSArray {
                    for subValue in value["images"] as! NSArray {
                        var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (ParseHelper.string(subValue, key: "path", defaultValue: ""))
                        url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                        images.append(url)
                        imageIds.append(subValue["id"] as! String)
                    }
                } else if let imagesValue: AnyObject = value["images"] {
                    //let image1: AnyObject = imagesValue["1"] as! NSDictionary
                    var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (ParseHelper.string(imagesValue, key: "path", defaultValue: ""))
                    url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                    images.append(url)
                    imageIds.append(imagesValue["id"] as! String)
                }
                
                
            } // data
        } // dictionary
        
        return ProductModel(isSuccessful: isSuccessful, message: message, attributes: attributes, validCombinations: validCombinations, images: images, imageIds: imageIds, category: category, brand: brand, condition: condition, name: name, shortDescription: shortDescription, completeDescription: completeDescription, productId: uid, quantity: quantity, retailPrice: retailPrice, discountedPrice: discoutedPrice, weight: weigth, height: height, length: length, width: width, sku: sku, productUnitId: productUnitId)
        
    } // parseDataWithDictionary
}
