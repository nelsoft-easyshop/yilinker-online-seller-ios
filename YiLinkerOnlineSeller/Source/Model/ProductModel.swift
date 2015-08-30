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
    var brand: BrandModel = BrandModel(name: "", brandId:0)
    var condition: ConditionModel = ConditionModel(uid: 0, name: "")
    var quantity: Int = 0
    
    var name: String = ""
    var shortDescription: String = ""
    var completeDescription: String = ""
    var sku: String = ""
    var retailPrice: String = ""
    var discoutedPrice: String = ""
    var width = ""
    var height = ""
    var length = ""
    var weigth = ""
    
    init (attributes: [AttributeModel], validCombinations: [CombinationModel]) {
        self.attributes = attributes
        self.validCombinations = validCombinations
    }
    
    init() {
        
    }
    
    func copy() -> ProductModel {
        return ProductModel(attributes: self.attributes, validCombinations: self.validCombinations)
    }
}
