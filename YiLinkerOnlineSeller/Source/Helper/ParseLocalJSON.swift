//
//  ParseLocalJSON.swift
//  EasyDeal
//
//  Created by Alvin on 4/30/15.
//  Copyright (c) 2015 EasyDeal. All rights reserved.
//

import Foundation

struct ParseLocalJSON {
    
    static func fileName(fileName : String) -> NSDictionary {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        
        let dictionary = text.parseJSONString as! NSDictionary
        return dictionary
    }
    
    static func fileNameWithArray(fileName : String) -> NSArray {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        
        let dictionary = text.parseJSONString as! NSArray
        return dictionary
    }
}


extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}