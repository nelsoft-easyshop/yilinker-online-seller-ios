//
//  TransactionsFilterModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionsFilterModel: NSObject {
    var headerText: String = ""
    var items: [TransactionsFilterItemModel] = []
    
    init(headerText: String, items: [TransactionsFilterItemModel]) {
        self.headerText = headerText
        self.items = items
    }
}
