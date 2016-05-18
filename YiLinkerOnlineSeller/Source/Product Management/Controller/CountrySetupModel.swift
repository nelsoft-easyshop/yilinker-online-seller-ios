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
    
    init(message: String, isSuccessful: Bool, product: CSProductModel, defaultUnit: CSDefaultUnitModel, productWarehouses: [CSProductWarehousesModel], logistics: [CSLogisticsModel]) {
        
        self.message = message
        self.isSuccessful = isSuccessful
        self.product = product
        self.defaultUnit = defaultUnit
        self.productWarehouses = productWarehouses
        self.logistics = logistics
    }
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CountrySetupModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var product: CSProductModel!
        var defaultUnit: CSDefaultUnitModel!
        var productWarehouses: [CSProductWarehousesModel] = []
        var logistics: [CSLogisticsModel] = []
        
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
                    productWarehouses.append(CSProductWarehousesModel.parseDataWithDictionary(warehouseData as! NSDictionary))
                }
                
                // Logistics
                for logisticData in data["logistics"] as! NSArray {
                    logistics.append(CSLogisticsModel.parseDataWithDictionary(logisticData as! NSDictionary))
                }
                
            } // data
        } // dictionary
        
        return CountrySetupModel(message: message, isSuccessful: isSuccessful, product: product, defaultUnit: defaultUnit, productWarehouses: productWarehouses, logistics: logistics)
        
    }
    
}

// MARK: - Product Model

typealias ImagesElement = (raw: String, imageLocation: String, isPrimary: Bool, isDeleted: Bool, thumbnail: String, small: String, medium: String, large: String, id: String)
typealias AttributesElement = ()
typealias DateCreatedElement = (date: String, timezone_type: Int, timezone: String)
typealias DateLastModifiedElement = (date: String, timezone_type: Int, timezone: String)

class CSProductModel {
    
    var id: Int = 0
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
            
            model.id = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            model.title = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.slug = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.image = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.status = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            model.raw = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.thumbnail = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.small = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.medium = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.large = ParseHelper.string(dictionary, key: "", defaultValue: "")
            // images
            var imagesElement: ImagesElement
            for image in dictionary["images"] as! NSArray {
                imagesElement.raw = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.imageLocation = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.isPrimary = ParseHelper.bool(image, key: "", defaultValue: false)
                imagesElement.isDeleted = ParseHelper.bool(image, key: "", defaultValue: false)
                imagesElement.thumbnail = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.small = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.medium = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.large = ParseHelper.string(image, key: "", defaultValue: "")
                imagesElement.id = ParseHelper.string(image, key: "", defaultValue: "")
                model.images.append(imagesElement)
            }
            model.shortDescription = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.fullDescription = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.sellerId = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            model.brandId = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            model.productCategoryId = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            // attributes
            var attributesElement: AttributesElement
            for attribute in dictionary["attributes"] as! NSArray {
                model.attributes.append(attributesElement)
            }
            // dateCreated
            if let dateCreatedData: AnyObject = dictionary["dateCreated"] {
                model.dateCreated.date = ParseHelper.string(dateCreatedData, key: "", defaultValue: "")
                model.dateCreated.timezone_type = ParseHelper.int(dateCreatedData, key: "", defaultValue: 0)
                model.dateCreated.timezone = ParseHelper.string(dateCreatedData, key: "", defaultValue: "")
            }
            // dateLastModified
            if let dateLastModifiedData: AnyObject = dictionary["dateLastModified"] {
                model.dateLastModified.date = ParseHelper.string(dateLastModifiedData, key: "", defaultValue: "")
                model.dateLastModified.timezone_type = ParseHelper.int(dateLastModifiedData, key: "", defaultValue: 0)
                model.dateLastModified.timezone = ParseHelper.string(dateLastModifiedData, key: "", defaultValue: "")
            }
            // productUnits
            for productUnit in dictionary["productUnits"] as! NSArray {
                model.productUnits.append(CSDefaultUnitModel.parseDataWithDictionary(productUnit as! NSDictionary))
            }
            model.shippingCost = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.hasCOD = ParseHelper.bool(dictionary, key: "", defaultValue: false)
//            model.elastica = nil
            model.store = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.brand = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.category = ParseHelper.string(dictionary, key: "", defaultValue: "")
        }
        
        return model
    }
}

// MARK: - Default Unit Model

typealias ImagesIdsElement = ()
typealias PromoInstanceElement = ()
typealias PromoInstanceNotYetStartedElement = ()

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
    var inWishlist: Bool = false
    var commission: String = ""
    var weight: String = ""
    var length: String = ""
    var height: String = ""
    var width: String = ""
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> CSDefaultUnitModel! {
        
        var model = CSDefaultUnitModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            model.productId = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.productUnitId = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.quantity = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            model.sku = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.slug = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.price = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.discountedPrice = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.appliedBaseDiscountPrice = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.appliedDiscountPrice = ParseHelper.string(dictionary, key: "", defaultValue: "")
//            model.promoTypeId = nil
//            model.promoTypeName = nil
            model.discount = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            // dateCreated
            if let dateCreatedData: AnyObject = dictionary["dateCreated"] {
                model.dateCreated.date = ParseHelper.string(dateCreatedData, key: "", defaultValue: "")
                model.dateCreated.timezone_type = ParseHelper.int(dateCreatedData, key: "", defaultValue: 0)
                model.dateCreated.timezone = ParseHelper.string(dateCreatedData, key: "", defaultValue: "")
            }
            // dateLastModified
            if let dateLastModifiedData: AnyObject = dictionary["dateLastModified"] {
                model.dateLastModified.date = ParseHelper.string(dateLastModifiedData, key: "", defaultValue: "")
                model.dateLastModified.timezone_type = ParseHelper.int(dateLastModifiedData, key: "", defaultValue: 0)
                model.dateLastModified.timezone = ParseHelper.string(dateLastModifiedData, key: "", defaultValue: "")
            }
            model.status = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            // Image Ids
            var imageIdElement: ImagesIdsElement
            for imageId in dictionary["imageIds"] as! NSArray {
                model.imageIds.append(imageIdElement)
            }
            model.primaryImage = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.primaryThumbnailImage = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.primarySmallImage = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.primaryMediumImage = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.primaryLargeImage = ParseHelper.string(dictionary, key: "", defaultValue: "")
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
            model.inWishlist = ParseHelper.bool(dictionary, key: "", defaultValue: false)
            model.commission = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.weight = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.length = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.height = ParseHelper.string(dictionary, key: "", defaultValue: "")
            model.width = ParseHelper.string(dictionary, key: "", defaultValue: "")
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
            model.id = ParseHelper.string(dictionary, key: "", defaultValue: "")
            // User Warehouse
            if let user_warehouseData: AnyObject = dictionary["user_warehouse"] {
                model.user_warehouse.id = ParseHelper.int(user_warehouseData, key: "id", defaultValue: 0)
                model.user_warehouse.name = ParseHelper.string(user_warehouseData, key: "name", defaultValue: "")
                model.user_warehouse.address = ParseHelper.string(user_warehouseData, key: "address", defaultValue: "")
                model.user_warehouse.isDelete = ParseHelper.bool(user_warehouseData, key: "isDelete", defaultValue: false)
                model.user_warehouse.zipCode = ParseHelper.string(user_warehouseData, key: "zipCode", defaultValue: "")
            }
            model.priority = ParseHelper.int(dictionary, key: "", defaultValue: 0)
            // Logistic
            if let logisticData: AnyObject = dictionary["logistic"] {
                model.logistic.id = ParseHelper.int(logisticData, key: "id", defaultValue: 0)
                model.logistic.name = ParseHelper.string(logisticData, key: "name", defaultValue: "")
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
