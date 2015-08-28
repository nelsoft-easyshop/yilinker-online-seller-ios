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
