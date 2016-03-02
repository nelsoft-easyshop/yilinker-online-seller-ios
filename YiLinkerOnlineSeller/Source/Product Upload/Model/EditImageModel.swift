//
//  EditImageModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 10/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class EditImageModel: NSObject {
    var uid: String = ""
    var isNew: Bool = false
    var isRemoved: Bool = false
    
    override init() {
        
    }
    
    init(uid: String, isNew: Bool, isRemoved: Bool) {
        self.uid = uid
        self.isNew = isNew
        self.isRemoved = isRemoved
    }
}
