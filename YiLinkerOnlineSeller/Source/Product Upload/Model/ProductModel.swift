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
    var youtubeVideoUrl: String = ""
    
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
    
    init (isSuccessful: Bool, message: String, attributes: [AttributeModel], validCombinations: [CombinationModel], productMainImagesModel: [ProductMainImagesModel], images: [String], mainImagesName: [String], imageIds: [String], category: CategoryModel, brand: BrandModel, condition: ConditionModel, shippingCategories: ConditionModel, productGroups: [ConditionModel], name: String, shortDescription: String, completeDescription: String, productId: String,  quantity: Int, retailPrice: String, discountedPrice: String, weight: String, height: String, length: String, width: String, sku: String, productUnitId: String, isAvailable: Bool, isPrimaryPhoto: [Bool], youtubeVideoUrl: String) {
    
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
        self.youtubeVideoUrl = youtubeVideoUrl
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
        self.youtubeVideoUrl = ""
        
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
        var youtubeVideoUrl: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: NSDictionary = dictionary["data"] as? NSDictionary{
                if let tempVar = value["brandName"] as? String {
                    if !(value["brandId"] is NSNull) {
                        brand = BrandModel(name: tempVar, brandId: value["brandId"] as! Int)
                    }
                }
                
                if let tempVar = value["productCategoryName"] as? String {
                    category = CategoryModel(uid: value["productCategoryId"] as! Int, name: tempVar, hasChildren: false)
                }
                
                if let tempVar = value["productConditionName"] as? String {
                    condition = ConditionModel(uid: value["productConditionId"] as! Int, name: tempVar)
                }
                
                if let tempVar = value["shippingCategoryName"] as? String {
                    shippingCategories = ConditionModel(uid: value["shippingCategoryId"] as! Int, name: tempVar)
                }
                
                if let tempVar = value["productGroups"] as? NSArray {
                    for (index, group) in enumerate(tempVar) {
                        productGroups.append(ConditionModel(uid: 0, name: group as! String))
                    }
                }
                
                if let tempVar = value["name"] as? String {
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
                
                if let tempVar = value["youtubeVideoUrl"] as? String {
                    youtubeVideoUrl = tempVar
                }
                
                if !(value["productVariants"] is NSNull) {
                    for subValue in value["productVariants"] as! NSArray {
                        var attributeModel = AttributeModel()
                        if let tempVar =  subValue["name"] as? String {
                            attributeModel.definition = tempVar
                        }
                        
                        if let tempVar =  subValue["id"] as? String {
                            attributeModel.id = tempVar
                        }
                        
                        for tempVar in subValue["values"] as! NSArray {
                            if let tempValue = tempVar["value"] as? String {
                                attributeModel.values.append(tempValue)
                            }
                        }
                        
                        attributes.append(attributeModel)
                    }
                } // product variants
                
                if let properties: NSArray = value["productUnits"] as? NSArray {
                    /*if properties.count == 0 {
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
                        validCombinations.append(combination)
                        
                    } else */if properties.count > 0 {
                        for subValue in value["productUnits"] as! NSArray {
                            var combination = CombinationModel()
                            if let tempVar = subValue["quantity"] as? String {
                                combination.quantity = tempVar
                            }
                            
                            if let tempVar = subValue["quantity"] as? Int {
                                combination.quantity = String(tempVar)
                            }
                            
                            if let tempVar = subValue["price"] as? String {
                                combination.retailPrice = tempVar
                            }
                            
                            if let tempVar = subValue["discountedPrice"] as? String {
                                combination.discountedPrice = tempVar
                            }
                            
                            if let tempVar = subValue["sku"] as? String {
                                combination.sku = tempVar
                            }
                            
                            if let tempVar = subValue["weight"] as? String {
                                combination.weight = tempVar
                            }
                            
                            if let tempVar = subValue["height"] as? String {
                                combination.height = tempVar
                            }
                            
                            if let tempVar = subValue["length"] as? String {
                                combination.length = tempVar
                            }
                            
                            if let tempVar = subValue["width"] as? String {
                                combination.width = tempVar
                            }
                            
                            if let tempVar = subValue["productUnitId"] as? String {
                                combination.productUnitId = tempVar
                            }
                            
                            if let attributes = subValue["attributes"] as? NSArray {
                                
                                if let tempVar = subValue["attributes"] as? [NSMutableDictionary] {
                                    combination.attributes = tempVar
                                }
                                
                                for subAttribute in subValue["attributes"] as! NSArray {
                                    if let tempVar = subValue["id"] as? String {
                                        combination.combinationID = tempVar
                                    }
                                    
                                    if let tempVar = subValue["attributes"] as? [NSMutableDictionary] {
                                        combination.attributes = tempVar
                                    }
                                    
                                    if let tempVar = subValue["discountedPrice"] as? String {
                                        combination.discountedPrice = tempVar
                                    }
                                    
                                    if let tempVar = subValue["quantity"] as? Int {
                                        combination.quantity = String(tempVar)
                                    }
                                    
                                    if let tempVar = subValue["sku"] as? String {
                                        combination.sku = tempVar
                                    }
                                }
                            } // attributes
                            
                            if let images = subValue["images"] as? NSArray {
                                for combiImages in subValue["images"] as! NSArray {
                                    if combiImages.count == 0 {
                                        combination.imagesUrl.append("")
                                        combination.imagesId.append("")
                                    } else {
                                        if let sizes = combiImages["sizes"] as? NSDictionary {
                                            if let thumbnail = sizes["thumbnail"] as? String {
                                                combination.imagesUrl.append(thumbnail)
                                            }
                                        }
                                        
                                        if let imageId = combiImages["raw"] as? String {
                                            combination.combiImagesName.append(imageId)
                                            combination.imagesId.append(imageId)
                                        }
                                    }
                                }
                            } // images
                            validCombinations.append(combination)
                        }
                        sku = validCombinations[0].sku
                        productUnitId = validCombinations[0].productUnitId
                    }
                } // product units
                
                if let imagesValue = value["productImages"] as? NSArray {
                    for subValue in value["productImages"] as! NSArray {
                        
                        if let thumbnail = subValue["sizes"] as? NSDictionary {
                            if let image = thumbnail["thumbnail"] as? String {
                                images.append(image)
                            }
                        }
                        
                        imageIds.append(subValue["raw"] as! String)
                        mainImagesName.append(subValue["raw"] as! String)
                        isPrimaryPhoto.append(subValue["isPrimary"] as! Bool)
                    }
                } else if let imagesValue: AnyObject = value["images"] {
                    var url: String = APIEnvironment.baseUrl() + "/assets/images/uploads/products/" + (imagesValue["path"] as! String)
                    url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
                    images.append(url)
                    imageIds.append(imagesValue["id"] as! String)
                } // main images
            } // data
        } // dictionary
        
        return ProductModel(isSuccessful: isSuccessful, message: message, attributes: attributes, validCombinations: validCombinations, productMainImagesModel: productMainImagesModel, images: images, mainImagesName: mainImagesName, imageIds: imageIds, category: category, brand: brand, condition: condition, shippingCategories: shippingCategories, productGroups: productGroups, name: name, shortDescription: shortDescription, completeDescription: completeDescription, productId: uid, quantity: quantity, retailPrice: retailPrice, discountedPrice: discoutedPrice, weight: weigth, height: height, length: length, width: width, sku: sku, productUnitId: productUnitId, isAvailable: isAvailable, isPrimaryPhoto: isPrimaryPhoto, youtubeVideoUrl: youtubeVideoUrl)
        
    } // parseDataWithDictionary
}
