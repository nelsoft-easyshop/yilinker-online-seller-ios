//
//  FollowerModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FollowerModel: NSObject {
    
    var userId: Int = 0
    var fullName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var slug: String = ""
    var email: String = ""
    var contactNumber: String = ""
    var profileImageUrl: String = ""
    
    
    init(userId: Int, fullName: String, firstName: String, lastName: String, slug: String, email: String, contactNumber: String, profileImageUrl: String) {
        self.userId = userId
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.slug = slug
        self.email = email
        self.contactNumber = contactNumber
        self.profileImageUrl = profileImageUrl
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> FollowerModel {
        
        var userId: Int = 0
        var fullName: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var slug: String = ""
        var email: String = ""
        var contactNumber: String = ""
        var profileImageUrl: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["userId"] != nil {
                if let tempVar = dictionary["userId"] as? Int {
                    userId = tempVar
                }
            }
            
            if dictionary["fullName"] != nil {
                if let tempVar = dictionary["fullName"] as? String {
                    fullName = tempVar
                }
            }
            
            if dictionary["firstName"] != nil {
                if let tempVar = dictionary["firstName"] as? String {
                    firstName = tempVar
                }
            }
            
            if dictionary["lastName"] != nil {
                if let tempVar = dictionary["lastName"] as? String {
                    lastName = tempVar
                }
            }
            
            if dictionary["slug"] != nil {
                if let tempVar = dictionary["slug"] as? String {
                    slug = tempVar
                }
            }
            
            if dictionary["email"] != nil {
                if let tempVar = dictionary["email"] as? String {
                    email = tempVar
                }
            }
            
            if dictionary["contactNumber"] != nil {
                if let tempVar = dictionary["contactNumber"] as? String {
                    contactNumber = tempVar
                }
            }
            
            if dictionary["profileImageUrl"] != nil {
                if let tempVar = dictionary["profileImageUrl"] as? String {
                    profileImageUrl = tempVar
                }
            }
            
        }
        
        return FollowerModel(userId: userId, fullName: fullName, firstName: firstName, lastName: lastName, slug: slug, email: email, contactNumber: contactNumber, profileImageUrl: profileImageUrl)
    }
    
}
