//
//  DeliveryLogsSectionModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/22/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DeliveryLogsSectionModel: NSObject {
    var date: String = ""
    var deliveryLogs: [DeliveryLogsItemModel] = []
    
    init(date: String, deliveryLogs: [DeliveryLogsItemModel]) {
        self.date = date
        self.deliveryLogs = deliveryLogs
    }
}
