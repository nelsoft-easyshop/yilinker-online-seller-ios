//
//  StoreInfoPreferredCategoriesModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/22/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoPreferredCategoriesModel: NSObject {
    var title: String = ""
    var isChecked: Bool = false
    
    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }
}
