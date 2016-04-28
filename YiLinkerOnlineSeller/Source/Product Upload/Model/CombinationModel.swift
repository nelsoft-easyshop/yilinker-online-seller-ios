//
//  CombinationModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CombinationModel {
    var combinationID: String = ""
    var attributes: [NSMutableDictionary] = []
    var retailPrice: String = ""
    var discountedPrice: String = ""
    var quantity: String = ""
    var sku: String = ""
    var images: [UIImage] = []
    var editedImages: [ServerUIImage] = []
    var imagesUrl: [String] = []
    var imagesId: [String] = []
    
    var weight: String = ""
    var height: String = ""
    var length: String = ""
    var width: String = ""
    var productUnitId: String = ""
    var isAvailable: Bool = false
    var isPrimaryPhoto: [Bool] = []
}
