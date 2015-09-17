//
//  JSONResponseSerializer.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class JSONResponseSerializer: AFJSONResponseSerializer {
    override func responseObjectForResponse(response: NSURLResponse?, data: NSData?) throws -> AnyObject {
        var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        
        var json: NSMutableDictionary = NSMutableDictionary()
        
        do {
            json = try super.responseObjectForResponse(response, data: data) as! NSMutableDictionary
            
            let errorValue = error!
            let userInfo: NSDictionary = errorValue.userInfo
            let copy: NSMutableDictionary = userInfo.mutableCopy() as! NSMutableDictionary
            copy["data"] = json
            
            error = NSError(domain: errorValue.domain, code: errorValue.code, userInfo: json as! [NSObject : AnyObject])
            
        } catch _ {
            
        }
        
        return json
    }
}