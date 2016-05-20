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
    var mainImagesName: [String] = []
    
    var category: CategoryModel = CategoryModel()
    var brand: BrandModel = BrandModel(name: "", brandId:1)
    var condition: ConditionModel = ConditionModel(uid: 0, name: "")
    var shippingCategories: ConditionModel = ConditionModel(uid: 0, name: "")
    var productGroups: [ConditionModel] = []
    var productMainImagesModel: [ProductMainImagesModel] = []
    
    var quantity: Int = 1
    var uid: String = "0"
    
    var name: String = ""
    var shortDescription: String = ""
    var completeDescription: String = ""
    var sku: String = ""
    var retailPrice: String = "0"
    var discoutedPrice: String = "0"
    var width: String = ""
    var height: String = ""
    var length: String = ""
    var weigth: String = ""
    var isAvailable: Bool = false
    var isPrimaryPhoto: [Bool] = []
    
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
    
    init (isSuccessful: Bool, message: String, attributes: [AttributeModel], validCombinations: [CombinationModel], productMainImagesModel: [ProductMainImagesModel], images: [String], mainImagesName: [String], imageIds: [String], category: CategoryModel, brand: BrandModel, condition: ConditionModel, shippingCategories: ConditionModel, productGroups: [ConditionModel], name: String, shortDescription: String, completeDescription: String, productId: String,  quantity: Int, retailPrice: String, discountedPrice: String, weight: String, height: String, length: String, width: String, sku: String, productUnitId: String, isAvailable: Bool, isPrimaryPhoto: [Bool]) {
    
        self.isSuccessful = isSuccessful
        self.message = message
        self.attributes = attributes
        self.validCombinations = validCombinations
        self.imageUrls = images
        self.imageIds = imageIds
        self.category = category
        self.brand = brand
        self.condition = condition
        self.shippingCategories = shippingCategories
        self.productGroups = productGroups
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
        self.isAvailable = isAvailable
        self.isPrimaryPhoto = isPrimaryPhoto
        self.mainImagesName = mainImagesName
        self.productMainImagesModel = productMainImagesModel
    }
    
    init() {
        self.attributes = []
        self.validCombinations = []
        self.images = []
        self.productGroups = []
        self.mainImagesName = []
        self.productMainImagesModel = []
        
        self.category = CategoryModel()
        self.brand = BrandModel(name: "", brandId:1)
        self.condition = ConditionModel(uid: 0, name: "")
        self.shippingCategories = ConditionModel(uid: 0, name: "")
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
        self.isAvailable = true
        self.isPrimaryPhoto = []
        
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
        var productGroups: [ConditionModel] = []
        var productMainImagesModel: [ProductMainImagesModel] = []
        var images: [String] = []
        var imageIds: [String] = []
        
        var category: CategoryModel = CategoryModel()
        var brand: BrandModel = BrandModel(name: "", brandId:1)
        var condition: ConditionModel = ConditionModel(uid: 0, name: "")
        var shippingCategories: ConditionModel = ConditionModel(uid: 0, name: "")
        var name: String = ""
        var shortDescription: String = ""
        var completeDescription: String = ""
        var uid: String = "0"
        
        var sku: String = ""
        var retailPrice: String = "0"
        var discoutedPrice: String = "0"
        var width: String = ""
        var height: String = ""
        var length: String = ""
        var weigth: String = ""
        var productUnitId: String = ""
        var quantity: Int = 0
        var isAvailable: Bool = false
        var isPrimaryPhoto: [Bool] = []
        var mainImagesName: [String] = []
        
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
                
                if let unitId = value["productUnitId"] as? String {
                    productUnitId = unitId
                }
                
                if let name = value["categoryName"] as? String {
                    category = CategoryModel(uid: value["categoryId"] as! Int, name: name, hasChildren: "")
                }
                
                if let name = value["conditionName"] as? String {
                    condition = ConditionModel(uid: value["conditionId"] as! Int, name: name)
                }
                
                if let name = value["shippingCategoryName"] as? String {
                    shippingCategories = ConditionModel(uid: value["shippingCategoryId"] as! Int, name: name)
                }
                
                if let name = value["productGroupName"] as? String {
                    productGroups.append(ConditionModel(uid: value["userProductGroupId"] as! Int, name: name))
                }
                
                if let tempVar = value["title"] as? String {
                    name = tempVar
                }
                
                if let tempVar = value["productId"] as? String {
                    uid = tempVar
                }
                
                if let tempVar = value["shortDescription"] as? String {
                    shortDescription = tempVar
                }
                
                if let tempVar = value["description"] as? String {
                    completeDescription = tempVar
                }
                
                if !(value["productVariants"] is NSNull) {
                    for subValue in value["productVariants"] as! NSArray {
                        var attributeModel = AttributeModel()
                        attributeModel.definition = subValue["name"] as! String
                        attributeModel.values = subValue["values"] as! [String]
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
                    combination.isAvailable = false
                    combination.isPrimaryPhoto.append(false)
//                    validCombinations.append(combination)
                    
                    
                } else if properties.count > 0 {
                    if !(value["productVariants"] is NSNull) {
                        var productAttributes: [NSDictionary] = value["productVariants"] as! [NSDictionary]
                        if productAttributes.count == 0 {
                            for subValue in value["productProperties"] as! NSArray {
                                quantity = subValue["quantity"] as! Int
                                retailPrice = subValue["price"] as! String
                                discoutedPrice = subValue["discountedPrice"] as! String
                                sku = subValue["sku"] as! String
                                weigth = subValue["unitWeight"] as! String
                                height = subValue["unitHeight"] as! String
                                length = subValue["unitLength"] as! String
                                width = subValue["unitWidth"] as! String
                                productUnitId = subValue["productUnitId"] as! String
                            }
                        } else {
                            
                            // TODO: Parse isAvailable, isPrimaryPhoto
                            
                            for subValue in value["productProperties"] as! NSArray {
                                var combination = CombinationModel()
                                combination.combinationID = subValue["id"] as! String
                                combination.attributes = subValue["attributes"] as! [NSMutableDictionary]
                                combination.retailPrice = subValue["price"] as! String
                                combination.discountedPrice = subValue["discountedPrice"] as! String
                                combination.quantity = String(subValue["quantity"] as! Int)
                                combination.sku = subValue["sku"] as! String
                                
                                let imagesCount: NSArray = subValue["images"] as! NSArray
                                if imagesCount.count == 0 {
                                    combination.imagesUrl.append("")
                                    combination.imagesId.append("")
                                } else {
                                    for subimages in subValue["images"] as! NSArray {
                                        var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (subimages["path"] as! String)
                                        println(">> \(url)")
                                        url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                                        combination.imagesUrl.append(url)
                                        combination.imagesId.append(subimages["id"] as! String)
                                        //images.append(url)
                                        //imageIds.append(subimages["id"] as! String)
                                    }
                                }

                                combination.productUnitId = subValue["productUnitId"] as! String
                                
                                combination.weight = subValue["unitWeight"] as! String
                                combination.height = subValue["unitHeight"] as! String
                                combination.length = subValue["unitLength"] as! String
                                combination.width = subValue["unitWidth"] as! String
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
                        var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (subValue["path"] as! String)
                        url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                        images.append(url)
                        imageIds.append(subValue["id"] as! String)
                    }
                } else if let imagesValue: AnyObject = value["images"] {
                    //let image1: AnyObject = imagesValue["1"] as! NSDictionary
                    var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (imagesValue["path"] as! String)
                    url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                    images.append(url)
                    imageIds.append(imagesValue["id"] as! String)
                }
                
                
                
//                    for subValue in value["productProperties"] as! NSArray {
//                        var attributeModel = AttributeModel()
//                        for attribute in subValue["attributes"] as! NSArray {
//                            attributeModel.definition = attribute["name"] as! String
//                            attributeModel.values.append(attribute["value"] as! String)
//                            attributes.append(attributeModel)
//                        }
//                        //                        attributes = subValue["attributes"] as! NSArray as! [AttributeModel]
//                        quantity = subValue["quantity"] as! Int
//                        retailPrice = subValue["price"] as! String
//                        discoutedPrice = subValue["discountedPrice"] as! String
//                        sku = subValue["sku"] as! String
//                        weigth = subValue["unitWeight"] as! String
//                        height = subValue["unitHeight"] as! String
//                        length = subValue["unitLength"] as! String
//                        width = subValue["unitWidth"] as! String
//                        productUnitId = subValue["productUnitId"] as! String
//                    }

//                else if properties.count == 1 {
//                    for subValue in value["productProperties"] as! NSArray {
//                        var attributeModel = AttributeModel()
//                        for attribute in subValue["attributes"] as! NSArray {
//                            attributeModel.definition = attribute["name"] as! String
//                            attributeModel.values.append(attribute["value"] as! String)
//                            attributes.append(attributeModel)
//                        }
////                        attributes = subValue["attributes"] as! NSArray as! [AttributeModel]
//                        quantity = subValue["quantity"] as! Int
//                        retailPrice = subValue["price"] as! String
//                        discoutedPrice = subValue["discountedPrice"] as! String
//                        sku = subValue["sku"] as! String
//                        weigth = subValue["unitWeight"] as! String
//                        height = subValue["unitHeight"] as! String
//                        length = subValue["unitLength"] as! String
//                        width = subValue["unitWidth"] as! String
//                        productUnitId = subValue["productUnitId"] as! String
//                    }
//                } else if properties.count > 1 {
//                    for subValue in value["productProperties"] as! NSArray {
//                        var combination = CombinationModel()
//                        combination.combinationID = subValue["id"] as! String
//                        var attributeModel = AttributeModel()
//                        for attribute in subValue["attributes"] as! NSArray {
//                            attributeModel.definition = attribute["name"] as! String
//                            attributeModel.values.append(attribute["value"] as! String)
//                            attributes.append(attributeModel)
//                        }
////                        combination.attributes = subValue["attributes"] as! NSArray as! [NSMutableDictionary]
//                        combination.attributes = attributes as NSArray as! [NSMutableDictionary]
//                        combination.retailPrice = subValue["price"] as! String
//                        combination.discountedPrice = subValue["discountedPrice"] as! String
//                        combination.quantity = String(subValue["quantity"] as! Int)
//                        combination.sku = subValue["sku"] as! String
//                        combination.images = subValue["images"] as! NSArray as! [UIImage]
//
//                        combination.weight = subValue["unitWeight"] as! String
//                        combination.height = subValue["unitHeight"] as! String
//                        combination.length = subValue["unitLength"] as! String
//                        combination.width = subValue["unitWidth"] as! String
//                        validCombinations.append(combination)
//                    }
//                    sku = validCombinations[0].sku
//                }
                
            } // data
        } // dictionary
        
        return ProductModel(isSuccessful: isSuccessful, message: message, attributes: attributes, validCombinations: validCombinations, productMainImagesModel: productMainImagesModel, images: images, mainImagesName: mainImagesName, imageIds: imageIds, category: category, brand: brand, condition: condition, shippingCategories: shippingCategories, productGroups: productGroups, name: name, shortDescription: shortDescription, completeDescription: completeDescription, productId: uid, quantity: quantity, retailPrice: retailPrice, discountedPrice: discoutedPrice, weight: weigth, height: height, length: length, width: width, sku: sku, productUnitId: productUnitId, isAvailable: isAvailable, isPrimaryPhoto: isPrimaryPhoto)
        
    } // parseDataWithDictionary
}
