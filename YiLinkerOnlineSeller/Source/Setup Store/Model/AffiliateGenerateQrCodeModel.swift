//
//  AffiliateGenerateQrCodeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/23/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AffiliateGenerateQrCodeModel: NSObject {
    var isSuccessful: Bool = false
    var qrcodeUrl: String = ""
    
    init(isSuccessful: Bool, qrcodeUrl: String) {
        self.isSuccessful = isSuccessful
        self.qrcodeUrl = qrcodeUrl
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> AffiliateGenerateQrCodeModel {
        
        var isSuccessful: Bool = false
        var qrcodeUrl: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            
            if let dataDictionary = dictionary["data"] as? NSDictionary {
                qrcodeUrl = ParseHelper.string(dataDictionary, key: "qrcodeUrl", defaultValue: "")
            }
        }
        
        return AffiliateGenerateQrCodeModel(isSuccessful: isSuccessful, qrcodeUrl: qrcodeUrl)
    }
}
