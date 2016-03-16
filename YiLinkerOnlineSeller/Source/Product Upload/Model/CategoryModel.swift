//
//  CategoryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    var uid: Int = 0
    var name: String = ""
    var hasChildren: String = ""
    var isSuccessful: Bool = false
    var isSelected: Bool = false
    
    init(uid: Int, name: String, hasChildren: String) {
        self.uid = uid
        self.name = name
        self.hasChildren = hasChildren
    }
    
    override init() {
        
    }
    
    //MARK: - 
    //MARK: - Parse Data From Dictionary
    class func parseDataFromDictionary(dictionary: NSDictionary) -> CategoryModel {
        var uid: Int = 0
        var name: String = ""
        var hasChildren: String = ""
        
        uid = ParseHelper.int(dictionary, key: "id", defaultValue: 0)
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        if ParseHelper.bool(dictionary, key: "hasChildren", defaultValue: false) == true {
            hasChildren = "1"
        } else {
            hasChildren = "0"
        }
        
        return CategoryModel(uid: uid, name: name, hasChildren: hasChildren)
    }
}
