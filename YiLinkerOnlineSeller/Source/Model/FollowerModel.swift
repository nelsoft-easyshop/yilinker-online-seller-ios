//
//  FollowerModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FollowerModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var imageUrl: String = ""
    
    init(id: Int, name: String, email: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = imageUrl
    }
}
