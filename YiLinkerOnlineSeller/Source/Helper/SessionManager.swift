//
//  SessionManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

class SessionManager {
    
    static let sharedInstance = SessionManager()

    var loginType: LoginType = LoginType.GoogleLogin
    
    class func setGcmToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "gcmToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setAccessToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setRefreshToken(refreshToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(refreshToken, forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setProfileImage(profileImageUrlString: String) {
        NSUserDefaults.standardUserDefaults().setObject(profileImageUrlString, forKey: "profileImageUrlString")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: -
    //MARK: - Set Selected Country Code
    class func setSelectedCountryCode(countryCode: String) {
        NSUserDefaults.standardUserDefaults().setObject(countryCode, forKey: "countryCode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: -
    //MARK: - Set Selected Language Code
    class func setSelectedLanguageCode(languageCode: String) {
        NSUserDefaults.standardUserDefaults().setObject(languageCode, forKey: "languageCode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: -
    //MARK: - Country Code
    class func selectedCountryCode() -> String {
        var result: String = "PH"
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("countryCode") as? String {
            result = val as! String
        }
        return result
    }
    
    //MARK: -
    //MARK: - Country Code
    class func selectedLanguageCode() -> String {
        var result: String = "en"
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("languageCode") as? String {
            result = val as! String
        }
        return result
    }
    
    class func profileImageStringUrl() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profileImageUrlString") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func gcmToken() -> String {
        var result : String = ""
        
        if let val : AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gcmToken") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func accessToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func refreshToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("refreshToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func logout() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "gcmToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isLoggedIn() -> Bool {

        if self.accessToken() != "" {
            return true
        } else {
            return false
        }
    }
    
    class func parseTokensFromResponseObject(dictionary: NSDictionary) {
        if dictionary.isKindOfClass(NSDictionary) {
            var accessToken: String = ""
            var refreshToken: String = ""
            
            if let data = dictionary["data"] as? NSDictionary {
                if let val: AnyObject = data["access_token"] {
                    if let tempAccessToken = data["access_token"] as? String {
                        accessToken = tempAccessToken
                    }
                }
                
                if let val: AnyObject = data["refresh_token"] {
                    if let tempRefreshAccessToken = data["refresh_token"] as? String {
                        refreshToken = tempRefreshAccessToken
                    }
                }
            } else {
                if let val: AnyObject = dictionary["access_token"] {
                    if let tempAccessToken = dictionary["access_token"] as? String {
                        accessToken = tempAccessToken
                    }
                }
                
                if let val: AnyObject = dictionary["refresh_token"] {
                    if let tempRefreshAccessToken = dictionary["refresh_token"] as? String {
                        refreshToken = tempRefreshAccessToken
                    }
                }
            }
            
            self.setAccessToken(accessToken)
            self.setRefreshToken(refreshToken)
            self.setProfileImage("http://besthqimages.mobi/wp-content/uploads/default-profile-picture-png-pictures-2.png")  
        }
    }
    
    class func getUnReadMessagesCount() -> Int{
        var messageCount: Int = 0
        
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("messageCount") as? String {
            let result = val as! String
            if result != "" {
                messageCount = result.toInt()!
            } else {
                messageCount = 0
            }
        } else {
            messageCount = 0
        }
        
        return messageCount
    }
    
    class func setUnReadMessagesCount(messageCount: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(messageCount)", forKey: "messageCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func unreadMessageCount() -> String {
        return "You have \(self.getUnReadMessagesCount()) unread messages"
    }
    
    class func setUserFullName(userFullName: String) {
        NSUserDefaults.standardUserDefaults().setObject(userFullName, forKey: "userFullName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setUserId(userId: String) {
        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setFullAddress(userAddress: String) {
        NSUserDefaults.standardUserDefaults().setObject(userAddress, forKey: "userAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setAddressId(addressId: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(addressId)", forKey: "addressId")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setIsSeller(isSeller: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(isSeller, forKey: "isSeller")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setIsReseller(isReseller: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(isReseller, forKey: "isReseller")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setIsEmailSubscribed(isEmailSubscribed: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(isEmailSubscribed, forKey: "isEmailSubscribed")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setIsSmsSubscribed(isSmsSubscribed: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(isSmsSubscribed, forKey: "isSmsSubscribed")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func addressId() -> Int {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("addressId") as? String {
            result = val as! String
        }
        return result.toInt()!
    }
    
    class func userFullName() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userFullName") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func userId() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func userFullAddress() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userAddress") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func isSeller() -> Bool {
        if let isSeller: Bool = NSUserDefaults.standardUserDefaults().objectForKey("isSeller") as? Bool {
            return isSeller
        } else {
            return false
        }
    }
    
    class func isReseller() -> Bool {
        if let isReseller: Bool = NSUserDefaults.standardUserDefaults().objectForKey("isReseller") as? Bool {
            return isReseller
        } else {
            return false
        }
    }
    
    class func isEmailSubscribed() -> Bool {
        if let isEmailSubscribed: Bool = NSUserDefaults.standardUserDefaults().objectForKey("isEmailSubscribed") as? Bool {
            return isEmailSubscribed
        } else {
            return false
        }
    }
    
    class func isSmsSubscribed() -> Bool {
        if let isSmsSubscribed: Bool = NSUserDefaults.standardUserDefaults().objectForKey("isSmsSubscribed") as? Bool {
            return isSmsSubscribed
        } else {
            return false
        }
    }
}
