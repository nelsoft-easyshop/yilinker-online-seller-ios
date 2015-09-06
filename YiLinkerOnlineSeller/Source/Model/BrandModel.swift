//
//  BrandModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class BrandModel: NSObject {
    var name: String = ""
    var brandId: Int = 0
    
    init(name: String, brandId: Int) {
        self.name = name
        self.brandId = brandId
    }
}
