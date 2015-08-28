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
    var attributeCombinations: [CombinationModel] = []
    
    init (attributes: [AttributeModel], attributeCombinations: [CombinationModel]) {
        self.attributes = attributes
        self.attributeCombinations = attributeCombinations
    }
    
    init() {
        
    }
    
    func copy() -> ProductModel {
        return ProductModel(attributes: self.attributes, attributeCombinations: self.attributeCombinations)
    }
}
