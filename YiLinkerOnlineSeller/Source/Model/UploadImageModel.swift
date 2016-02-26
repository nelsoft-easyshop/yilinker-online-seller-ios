//
//  UploadImageModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/22/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class UploadImageModel: NSObject {
    var isSuccessful: Bool = false
    var fileName: String = ""
    
    init(isSuccessful: Bool, fileName: String) {
        self.isSuccessful = isSuccessful
        self.fileName = fileName
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> UploadImageModel {
        
        var isSuccessful: Bool = false
        var fileName: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            
            if let dataDictionary = dictionary["data"] as? NSDictionary {
                fileName = ParseHelper.string(dataDictionary, key: "fileName", defaultValue: "")
            }
        }
        
        return UploadImageModel(isSuccessful: isSuccessful, fileName: fileName)
    }
}
