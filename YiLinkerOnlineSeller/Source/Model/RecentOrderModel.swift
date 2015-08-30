//
//  RecentOrderModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class RecentOrderModel: NSObject {
    var imageURL: String = ""
    var productName: String = ""
    var modeOfPayment: String = ""
    var price: String = ""
    var status: String = ""
    
    init(imageURL: String, productName: String, modeOfPayment: String, price: String, status: String) {
        self.imageURL = imageURL
        self.productName = productName
        self.modeOfPayment = modeOfPayment
        self.price = price
        self.status = status
    }
}
