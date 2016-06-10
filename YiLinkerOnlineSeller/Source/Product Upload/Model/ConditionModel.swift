//
//  ConditionModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ConditionModel: NSObject {
    var uid: Int = 0
    var name: String = ""
    
    init (uid: Int, name: String) {
        self.uid = uid
        self.name = name
    }
}
