//
//  TransactionsFilterModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionsFilterItemModel: NSObject {
   
    var title: String = ""
    var isChecked: Bool = false
    
    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }
}
