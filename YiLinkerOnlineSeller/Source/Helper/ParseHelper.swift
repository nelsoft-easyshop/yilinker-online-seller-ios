//
//  ParseHelper.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 1/21/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ParseHelper: NSObject {

    // Use this when parsing string
    class func string(object: AnyObject, key: String, defaultValue: String) -> String {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? String {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing int
    class func int(object: AnyObject, key: String, defaultValue: Int) -> Int {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Int {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing bool
    class func bool(object: AnyObject, key: String, defaultValue: Bool) -> Bool {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Bool {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing array
    class func array(object: AnyObject, key: String, defaultValue: NSArray) -> NSArray {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? NSArray {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing dictionary
    class func dictionary(object: AnyObject, key: String, defaultValue: NSDictionary) -> NSDictionary {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? NSDictionary {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing string
    class func parseString(dictionary: NSDictionary, key: String, defaultValue: String) -> String {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? String {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing int
    class func parseInt(dictionary: NSDictionary, key: String, defaultValue: Int) -> Int {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Int {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing bool
    class func parseBool(dictionary: NSDictionary, key: String, defaultValue: Bool) -> Bool {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Bool {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing array
    class func parseArray(dictionary: NSDictionary, key: String, defaultValue: NSArray) -> NSArray {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? NSArray {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing dictionary
    class func parseDictionary(dictionary: NSDictionary, key: String, defaultValue: NSDictionary) -> NSDictionary {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? NSDictionary {
                return parsedValue
            }
        }
        
        return defaultValue
    }

}
