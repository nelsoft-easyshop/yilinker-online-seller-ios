//
//  CountrySetupModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 5/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountrySetupModel: NSObject {
   
    var message: String = ""
    var isSuccessful: Bool = false
    
    var product: CSProductModel!
    var defaultUnit: CSDefaultUnitModel!
    var productWarehouses: [CSProductWarehousesModel] = []
    var logistics: [CSLogisticsModel] = []
    var primaryAddress: String = ""
    var secondaryAddress: String = ""
    
    init(message: String, isSuccessful: Bool, product: CSProductModel, defaultUnit: CSDefaultUnitModel, productWarehouses: [CSProductWarehousesModel], logistics: [CSLogisticsModel], primaryAddress: String, secondaryAddress: String) {
        
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.product = product
        self.defaultUnit = defaultUnit
        self.productWarehouses = productWarehouses
        self.logistics = logistics
        
        self.primaryAddress = primaryAddress
        self.secondaryAddress = secondaryAddress
    }
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CountrySetupModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var product: CSProductModel!
        var defaultUnit: CSDefaultUnitModel!
        var productWarehouses: [CSProductWarehousesModel] = []
        var logistics: [CSLogisticsModel] = []
        
        var primaryAddress: String = ""
        var secondaryAddress: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            message = ParseHelper.string(dictionary, key: "", defaultValue: "")
            isSuccessful = ParseHelper.bool(dictionary, key: "", defaultValue: false)
            
            if let data = dictionary["data"] as? NSDictionary {
                
                // Product
                if let productData: AnyObject = data["product"] {
                    product = CSProductModel.parseDataWithDictionary(productData as! NSDictionary)
                }
                
                // Default Unit
                if let defaultUnitData: AnyObject = data["defaultUnit"] {
                    defaultUnit = CSDefaultUnitModel.parseDataWithDictionary(defaultUnitData as! NSDictionary)
                }
                
                // Product Warehouses
                for warehouseData in data["productWarehouses"] as! NSArray {
                    let warehouse: CSProductWarehousesModel = CSProductWarehousesModel.parseDataWithDictionary(warehouseData as! NSDictionary)
                    if warehouse.priority == 1 {
                        primaryAddress = warehouse.user_warehouse.address
                    } else if warehouse.priority == 2 {
                        secondaryAddress = warehouse.user_warehouse.address
                    } else {
                        
                    }
                    productWarehouses.append(CSProductWarehousesModel.parseDataWithDictionary(warehouseData as! NSDictionary))
                }
                
                // Logistics
                for logisticData in data["logistics"] as! NSArray {
                    logistics.append(CSLogisticsModel.parseDataWithDictionary(logisticData as! NSDictionary))
                }
                
            } // data
        } // dictionary
        
        return CountrySetupModel(message: message, isSuccessful: isSuccessful, product: product, defaultUnit: defaultUnit, productWarehouses: productWarehouses, logistics: logistics, primaryAddress: primaryAddress, secondaryAddress: secondaryAddress)
    }
    
}

// MARK: - Product Model

typealias ImagesElement = (raw: String, imageLocation: String, isPrimary: Bool, isDeleted: Bool, thumbnail: String, small: String, medium: String, large: String, id: String)
typealias AttributesElement = ()
typealias DateCreatedElement = (date: String, timezone_type: Int, timezone: String)
typealias DateLastModifiedElement = (date: String, timezone_type: Int, timezone: String)

class CSProductModel {
    
    var id: String = "0"
    var title: String = ""
    var slug: String = ""
    var image: String = ""
    var status: Int = 0
    var raw: String = ""
    var thumbnail: String = ""
    var small: String = ""
    var medium: String = ""
    var large: String = ""
    var images = [ImagesElement]()
    var shortDescription: String = ""
    var fullDescription: String = ""
    var sellerId: Int = 0
    var brandId: Int = 0
    var productCategoryId: Int = 0
    var attributes = [AttributesElement]()
    var dateCreated: DateCreatedElement!
    var dateLastModified: DateLastModifiedElement!
    var productUnits: [CSDefaultUnitModel] = []
    var shippingCost: String = ""
    var hasCOD: Bool = false
//    var elastica = nil
    var store: String = ""
    var brand: String = ""
    var category: String = ""
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CSProductModel! {
        
        var model = CSProductModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            model.id = ParseHelper.string(dictionary, key: "id", defaultValue: "0")
            model.title = ParseHelper.string(dictionary, key: "title", defaultValue: "")
            model.slug = ParseHelper.string(dictionary, key: "slug", defaultValue: "")
            model.image = ParseHelper.string(dictionary, key: "image", defaultValue: "")
            model.status = ParseHelper.int(dictionary, key: "status", defaultValue: 0)
            model.raw = ParseHelper.string(dictionary, key: "raw", defaultValue: "")
            model.thumbnail = ParseHelper.string(dictionary, key: "thumbnail", defaultValue: "")
            model.small = ParseHelper.string(dictionary, key: "small", defaultValue: "")
            model.medium = ParseHelper.string(dictionary, key: "medium", defaultValue: "")
            model.large = ParseHelper.string(dictionary, key: "large", defaultValue: "")
            // images
            var imagesElement: ImagesElement
            for image in dictionary["images"] as! NSArray {
                imagesElement.raw = ParseHelper.string(image, key: "raw", defaultValue: "")
                imagesElement.imageLocation = ParseHelper.string(image, key: "imageLocation", defaultValue: "")
                imagesElement.isPrimary = ParseHelper.bool(image, key: "isPrimary", defaultValue: false)
                imagesElement.isDeleted = ParseHelper.bool(image, key: "isDeleted", defaultValue: false)
                imagesElement.thumbnail = ParseHelper.string(image, key: "thumbnail", defaultValue: "")
                imagesElement.small = ParseHelper.string(image, key: "small", defaultValue: "")
                imagesElement.medium = ParseHelper.string(image, key: "medium", defaultValue: "")
                imagesElement.large = ParseHelper.string(image, key: "large", defaultValue: "")
                imagesElement.id = ParseHelper.string(image, key: "id", defaultValue: "")
                model.images.append(imagesElement)
            }
            model.shortDescription = ParseHelper.string(dictionary, key: "shortDescription", defaultValue: "")
            model.fullDescription = ParseHelper.string(dictionary, key: "fullDescription", defaultValue: "")
            model.sellerId = ParseHelper.int(dictionary, key: "sellerId", defaultValue: 0)
            model.brandId = ParseHelper.int(dictionary, key: "brandId", defaultValue: 0)
            model.productCategoryId = ParseHelper.int(dictionary, key: "productCategoryId", defaultValue: 0)
            // attributes
            var attributesElement: AttributesElement
            for attribute in dictionary["attributes"] as! NSArray {
                model.attributes.append(attributesElement)
            }
            // dateCreated
            if let dateCreatedData: AnyObject = dictionary["dateCreated"] {
                var element: DateCreatedElement
                element.date = ParseHelper.string(dateCreatedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateCreatedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateCreatedData, key: "timezone", defaultValue: "")
                model.dateCreated = element
            }
            // dateLastModified
            if let dateLastModifiedData: AnyObject = dictionary["dateLastModified"] {
                var element: DateCreatedElement
                element.date = ParseHelper.string(dateLastModifiedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateLastModifiedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateLastModifiedData, key: "timezone", defaultValue: "")
                model.dateLastModified = element
            }
            // productUnits
            for productUnit in dictionary["productUnits"] as! NSArray {
                model.productUnits.append(CSDefaultUnitModel.parseDataWithDictionary(productUnit as! NSDictionary))
            }
            model.shippingCost = ParseHelper.string(dictionary, key: "shippingCost", defaultValue: "")
            model.hasCOD = ParseHelper.bool(dictionary, key: "hasCOD", defaultValue: false)
//            model.elastica = nil
            model.store = ParseHelper.string(dictionary, key: "store", defaultValue: "")
            model.brand = ParseHelper.string(dictionary, key: "brand", defaultValue: "")
            model.category = ParseHelper.string(dictionary, key: "category", defaultValue: "")
        }
        
        return model
    }
}

// MARK: - Default Unit Model

typealias ImagesIdsElement = ()
typealias PromoInstanceElement = ()
typealias PromoInstanceNotYetStartedElement = ()
typealias VariantCombinationElement = (name: String, value: String)

class CSDefaultUnitModel {
    
    var productId: String = ""
    var productUnitId: String = ""
    var quantity: Int = 0
    var sku: String = ""
    var slug: String = ""
    var price: String = ""
    var discountedPrice: String = ""
    var appliedBaseDiscountPrice: String = ""
    var appliedDiscountPrice: String = ""
//    var promoTypeId = nil
//    var promoTypeName = nil
    var discount: Int = 0
    var dateCreated: DateCreatedElement!
    var dateLastModified: DateLastModifiedElement!
    var status: Int = 0
    var imageIds: [ImagesIdsElement] = []
    var primaryImage: String = ""
    var primaryThumbnailImage: String = ""
    var primarySmallImage: String = ""
    var primaryMediumImage: String = ""
    var primaryLargeImage: String = ""
    var promoInstance: [PromoInstanceElement] = []
    var promoInstanceNotYetStarted: [PromoInstanceNotYetStartedElement] = []
    var variantCombination = [VariantCombinationElement]()
    var inWishlist: Bool = false
    var commission: String = ""
    var weight: String = ""
    var length: String = ""
    var height: String = ""
    var width: String = ""
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CSDefaultUnitModel! {
        
        var model = CSDefaultUnitModel()

        if dictionary.isKindOfClass(NSDictionary) {
            model.productId = ParseHelper.string(dictionary, key: "productId", defaultValue: "")
            model.productUnitId = ParseHelper.string(dictionary, key: "productUnitId", defaultValue: "")
            model.quantity = ParseHelper.int(dictionary, key: "quantity", defaultValue: 0)
            model.sku = ParseHelper.string(dictionary, key: "sku", defaultValue: "")
            model.slug = ParseHelper.string(dictionary, key: "slug", defaultValue: "")
            model.price = ParseHelper.string(dictionary, key: "price", defaultValue: "")
            model.discountedPrice = ParseHelper.string(dictionary, key: "discountedPrice", defaultValue: "")
            model.appliedBaseDiscountPrice = ParseHelper.string(dictionary, key: "appliedBaseDiscountPrice", defaultValue: "")
            model.appliedDiscountPrice = ParseHelper.string(dictionary, key: "appliedDiscountPrice", defaultValue: "")
//            model.promoTypeId = nil
//            model.promoTypeName = nil
            model.discount = ParseHelper.int(dictionary, key: "discount", defaultValue: 0)
            // dateCreated
            if let dateCreatedData: AnyObject = dictionary["dateCreated"] {
                var element: DateCreatedElement
                element.date = ParseHelper.string(dateCreatedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateCreatedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateCreatedData, key: "timezone", defaultValue: "")
                model.dateCreated = element
            }
            // dateLastModified
            if let dateLastModifiedData: AnyObject = dictionary["dateLastModified"] {
                var element: DateCreatedElement
                element.date = ParseHelper.string(dateLastModifiedData, key: "date", defaultValue: "")
                element.timezone_type = ParseHelper.int(dateLastModifiedData, key: "timezone_type", defaultValue: 0)
                element.timezone = ParseHelper.string(dateLastModifiedData, key: "timezone", defaultValue: "")
                model.dateLastModified = element
            }
            model.status = ParseHelper.int(dictionary, key: "status", defaultValue: 0)
            // Image Ids
            var imageIdElement: ImagesIdsElement
            for imageId in dictionary["imageIds"] as! NSArray {
                model.imageIds.append(imageIdElement)
            }
            model.primaryImage = ParseHelper.string(dictionary, key: "primaryImage", defaultValue: "")
            model.primaryThumbnailImage = ParseHelper.string(dictionary, key: "primaryThumbnailImage", defaultValue: "")
            model.primarySmallImage = ParseHelper.string(dictionary, key: "primarySmallImage", defaultValue: "")
            model.primaryMediumImage = ParseHelper.string(dictionary, key: "primaryMediumImage", defaultValue: "")
            model.primaryLargeImage = ParseHelper.string(dictionary, key: "primaryLargeImage", defaultValue: "")
            // Promo Instance
            var promoInstanceElement: PromoInstanceElement
            for promoInstanceData in dictionary["promoInstance"] as! NSArray {
                model.promoInstance.append(promoInstanceElement)
            }
            // Promo Instance Not Yet Started
            var promoInstanceNotYetStartedElement: PromoInstanceNotYetStartedElement
            for promoInstanceNotYetStartedData in dictionary["promoInstanceNotYetStarted"] as! NSArray {
                model.promoInstanceNotYetStarted.append(promoInstanceNotYetStartedElement)
            }
            // Variant Combinations
            var variantCombinationElement: VariantCombinationElement
//            for variantCombinationData in dictionary["variantCombination"] as! NSArray {
//                println("benga")
//                variantCombinationElement.name = ParseHelper.string(variantCombinationData, key: "name", defaultValue: "")
//                variantCombinationElement.value = ParseHelper.string(variantCombinationData, key: "value", defaultValue: "")
//                model.variantCombination.append(variantCombinationElement)
//            }
            for i in 0..<3 {
                variantCombinationElement.name = "Name"
                variantCombinationElement.value = "Value"
                model.variantCombination.append(variantCombinationElement)
            }
            
            model.inWishlist = ParseHelper.bool(dictionary, key: "inWishlist", defaultValue: false)
            model.commission = ParseHelper.string(dictionary, key: "commission", defaultValue: "")
            model.weight = ParseHelper.string(dictionary, key: "weight", defaultValue: "")
            model.length = ParseHelper.string(dictionary, key: "length", defaultValue: "")
            model.height = ParseHelper.string(dictionary, key: "height", defaultValue: "")
            model.width = ParseHelper.string(dictionary, key: "width", defaultValue: "")
        }
        
        return model
    }
}

// MARK: - User Warehouse Model

typealias UserWarehouseElement = (id: Int, name: String, address: String, isDelete: Bool, zipCode: String)
typealias LogisticElement = (id: Int, name: String)

class CSProductWarehousesModel {
    
    var id: String = ""
    var user_warehouse: UserWarehouseElement!
    var priority: Int = 0
    var logistic: LogisticElement!
    var is_cod: Bool = false
    var handlingFee: String = ""
    var is_local: Bool = false
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CSProductWarehousesModel! {
        
        var model = CSProductWarehousesModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            model.id = ParseHelper.string(dictionary, key: "id", defaultValue: "")
            // User Warehouse
            if let user_warehouseData: AnyObject = dictionary["user_warehouse"] {
                var element: UserWarehouseElement
                element.id = ParseHelper.int(user_warehouseData, key: "id", defaultValue: 0)
                element.name = ParseHelper.string(user_warehouseData, key: "name", defaultValue: "")
                element.address = ParseHelper.string(user_warehouseData, key: "address", defaultValue: "")
                element.isDelete = ParseHelper.bool(user_warehouseData, key: "isDelete", defaultValue: false)
                element.zipCode = ParseHelper.string(user_warehouseData, key: "zipCode", defaultValue: "")
                model.user_warehouse = element
            }
            model.priority = ParseHelper.int(dictionary, key: "priority", defaultValue: 0)
            // Logistic
            if let logisticData: AnyObject = dictionary["logistic"] {
                var element: LogisticElement
                element.id = ParseHelper.int(logisticData, key: "id", defaultValue: 0)
                element.name = ParseHelper.string(logisticData, key: "name", defaultValue: "")
                model.logistic = element
            }
            model.is_cod = ParseHelper.bool(dictionary, key: "is_cod", defaultValue: false)
            model.handlingFee = ParseHelper.string(dictionary, key: "handlingFee", defaultValue: "")
            model.is_local = ParseHelper.bool(dictionary, key: "is_local", defaultValue: false)
        }
        
        return model
        
    }
}

// MARK: - Logistics Model

class CSLogisticsModel {
    
    var id: Int = 0
    var name: String = ""
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CSLogisticsModel! {
        
        var model = CSLogisticsModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            model.id = ParseHelper.int(dictionary, key: "id", defaultValue: 0)
            model.name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        }
        
        return model
        
    }
    
}
