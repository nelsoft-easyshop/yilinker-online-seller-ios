//
//  StoreInfoModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoModel: NSObject {
    
    var name: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var avatar: NSURL = NSURL(string: "")!
    var specialty: String = ""
    var target: String = ""
    var address: String = ""
    var coverPhoto: NSURL = NSURL(string: "")!
    var email: String = ""
    var gender: String = ""
    var nickname: String = ""
    var contact_number: String = ""
    var birthdate: String = ""
    var store_name: String = ""
    var store_description = ""
    var storeSlug: String = ""
    var is_allowed: Bool = false
    var title: String = ""
    var store_address: String = ""
    var unitNumber: String = ""
    var bldgName: String = ""
    var streetNumber: String = ""
    var streetName: String = ""
    var subdivision: String = ""
    var zipCode: String = ""
    /*var streetAddress: String = ""
    var province: String = ""
    var city: String = ""
    var municipality: String = ""
    var barangay: String = ""*/
    var accountName: String = ""
    var accountNumber: String = ""
    var bankName: String = ""
    var bankAccount: String = ""
    var accountTitle: String = ""
    var bankId: Int = 0
    
    var productCount: Int = 0
    var transactionCount: Int = 0
    var totalSales: String = ""
    var isReseller: Bool = false
    var isEmailVerified: Bool = false
    var isEmailSubscribed: Bool = false
    var isSmsSubscribed: Bool = false
    var tin: String = ""
    var messageCount: Int = 0
    
    var productId: [String] = []
    var productCategoryName: [String] = []
    var isSelected: [Bool] = []
    
    var referralCode: String = ""
    var referrerCode: String = ""
    var referrerName: String = ""
    
    var validId: String = ""
    var isBankEditable: Bool = false
    var isBusinessEditable: Bool = false
    var isLegalDocsEditable: Bool = false
    var validIdMessage: String = ""

    init(name : String, firstName: String, lastName: String, email : String, gender : String, nickname : String, contact_number : String, specialty : String, birthdate : String, store_name : String, store_description : String, storeSlug: String,  avatar : NSURL, cover_photo : NSURL, is_allowed : Bool, title: String, unit_number: String, bldg_name: String, street_number: String, street_name: String, subdivision: String, zip_code: String, full_address: String, account_title: String, account_number: String, bank_account: String, bank_id: Int, productCount: Int, transactionCount: Int, totalSales: String, isReseller: Bool, isEmailVerified: Bool, isEmailSubscribed: Bool, isSmsSubscribed: Bool, productId: NSArray, productCategoryName: NSArray, isSelected: NSArray, tin: String, messageCount: Int, referralCode: String = "", referrerCode: String = "", referrerName: String = "", accountName: String, bankName: String, validId: String, isBankEditable: Bool, isBusinessEditable: Bool, isLegalDocsEditable: Bool, validIdMessage: String) {

        self.lastName = lastName
        self.firstName = firstName
        self.name = name
        self.email = email
        self.gender = gender
        self.nickname = nickname
        self.contact_number = contact_number
        self.specialty = specialty
        self.birthdate = birthdate
        self.store_name = store_name
        self.store_description = store_description
        self.storeSlug = storeSlug
        self.avatar = avatar
        self.coverPhoto = cover_photo
        self.is_allowed = is_allowed
        self.title = title
        self.unitNumber = unit_number
        self.bldgName = bldg_name
        self.streetName = street_name
        self.subdivision = subdivision
        self.zipCode = zip_code
        self.store_address = full_address
        self.bankAccount = bank_account
        self.accountTitle = account_title
        self.bankName = bankName
        self.accountName = accountName
        self.accountNumber = account_number
        self.bankId = bank_id
        self.productCount = productCount
        self.transactionCount = transactionCount
        self.totalSales = totalSales
        self.isReseller = isReseller
        self.isEmailVerified = isEmailVerified
        self.isEmailSubscribed = isEmailSubscribed
        self.isSmsSubscribed = isSmsSubscribed
        self.productId = productId as! [String]
        self.productCategoryName = productCategoryName as! [String]
        self.isSelected = isSelected as! [Bool]
        self.tin = tin
        self.messageCount = messageCount
        self.referralCode = referralCode
        self.referrerCode = referrerCode
        self.referrerName = referrerName
        self.validId = validId
        self.isBankEditable = isBankEditable
        self.isBusinessEditable = isBusinessEditable
        self.isLegalDocsEditable = isLegalDocsEditable
        self.validIdMessage = validIdMessage
    }

    class func parseSellerDataFromDictionary(dictionary: NSDictionary) -> StoreInfoModel {
        
        var name: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var email: String = ""
        var gender: String = ""
        var nickname: String = ""
        var contact_number: String = ""
        var specialty: String = ""
        var birthdate: String = ""
        var store_name: String = ""
        var store_description: String = ""
        var storeSlug: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var cover_photo: NSURL = NSURL(string: "")!
        var is_followed: Bool = false
        var title: String = ""
        var store_address: String = ""
        var unit_number: String = ""
        var bldg_name: String = ""
        var street_number: String = ""
        var street_name: String = ""
        var subdivision: String = ""
        var zip_code: String = ""
        var account_name: String = ""
        var account_number: String = ""
        var bank_name: String = ""
        var bank_account: String = ""
        var bank_id: Int = 0
        var account_title: String = ""
        var productCount: Int = 0
        var transactionCount: Int = 0
        var totalSales: String = ""
        var isReseller: Bool = false
        var isEmailVerified: Bool = false
        var isEmailSubscribed: Bool = false
        var isSmsSubscribed: Bool = false
        var tin: String = ""
        var messageCount: Int = 0
        
        var productId: [String] = []
        var productCategoryName: [String] = []
        var isSelected: [Bool] = []
        
        var referralCode: String = ""
        var referrerCode: String = ""
        var referrerName: String = ""
        
        var validId: String = ""
        var isBankEditable: Bool = false
        var isBusinessEditable: Bool = false
        var isLegalDocsEditable: Bool = false
        var validIdMessage: String = ""
        
        if let value: AnyObject = dictionary["data"] {
            
            if let sellerName = value["fullName"] as? String {
                name = sellerName
            } else {
                name = ""
            }
            
            if let val = value["firstName"] as? String {
                firstName = val
            } else {
                firstName = ""
            }
            
            if let val = value["lastName"] as? String {
                lastName = val
            } else {
                lastName = ""
            }
            
            if let sellerEmail = value["email"] as? String {
                email = sellerEmail
            } else {
                email = ""
            }
            
            if let sellerGender = value["gender"] as? String {
                gender = sellerGender
            } else {
                gender = ""
            }
            
            if let sellerNickname = value["nickname"] as? String {
                nickname = sellerNickname
            } else {
                nickname = ""
            }
            
            if let sellerContactNumber = value["contactNumber"] as? String {
                contact_number = sellerContactNumber
            } else {
                contact_number = ""
            }
            
            if let sellerSpecialty = value["specialty"] as? String {
                specialty = sellerSpecialty
            } else {
                specialty = ""
            }
            
            if let sellerBirthdate = value["birthdate"] as? String {
                birthdate = sellerBirthdate
            } else {
                birthdate = ""
            }
            
            if let sellerStoreName = value["storeName"] as? String {
                store_name = sellerStoreName
            } else {
                store_name = ""
            }
            
            if let sellerStoreDescription = value["storeDescription"] as? String {
                store_description = sellerStoreDescription
            } else {
                store_description = ""
            }
            
            if let val = value["storeSlug"] as? String {
                storeSlug = val
            } else {
                storeSlug = ""
            }
            
            if let sellerProfilePhoto = value["profilePhoto"] as? String {
                avatar = NSURL(string: sellerProfilePhoto)!
            } else {
                avatar = NSURL(string: "")!
            }
            
            if let sellerCoverPhoto = value["coverPhoto"] as? String {
                cover_photo = NSURL(string: sellerCoverPhoto)!
            } else {
                cover_photo = NSURL(string: "")!
            }
            
            if let sellerIsFollowed = value["isFollowed"] as? Bool {
                is_followed = sellerIsFollowed
            } else {
                is_followed = false
            }
            
            if let tempVar = value["productCount"] as? Int {
                productCount = tempVar
            } else {
                productCount = 0
            }
            
            if let tempVar = value["transactionCount"] as? Int {
                transactionCount = tempVar
            } else {
                transactionCount = 0
            }
            
            if let tempVar = value["totalSales"] as? String {
                totalSales = tempVar
            } else {
                totalSales = ""
            }
            
            if let tempVar = value["isReseller"] as? Bool {
                isReseller = tempVar
            } else {
                isReseller = false
            }
            
            if let tempVar = value["isEmailVerified"] as? Bool {
                isEmailVerified = tempVar
            } else {
                isEmailVerified = false
            }
            
            if let tempVar = value["isEmailSubscribed"] as? Bool {
                isEmailSubscribed = tempVar
            } else {
                isEmailSubscribed = false
            }
            
            if let tempVar = value["isSmsSubscribed"] as? Bool {
                isSmsSubscribed = tempVar
            } else {
                isSmsSubscribed = false
            }
            
            if let sellerTin = value["tin"] as? String {
                tin = sellerTin
            } else {
                tin = ""
            }
            
            if let tempVar = value["messageCount"] as? Int {
                messageCount = tempVar
            } else {
                messageCount = 0
            }

            if let tempReferralCode = value["referralCode"] as? String {
                referralCode = tempReferralCode
            }
            
            if let value = value["referrerCode"] as? String {
                referrerCode = value
            }
            
            if let value = value["referrerName"] as? String {
                referrerName = value
            }

            if let val = value["validId"] as? String {
                validId = val
            } else {
                validId = ""
            }
            
            if let val = value["isBankEditable"] as? Bool {
                isBankEditable = val
            } else {
                isBankEditable = false
            }
            
            if let val = value["isBusinessEditable"] as? Bool {
                isBusinessEditable = val
            } else {
                isBusinessEditable = false
            }
            
            if let val = value["isLegalDocsEditable"] as? Bool {
                isLegalDocsEditable = val
            } else {
                isLegalDocsEditable = false
            }
            
            if let val = value["validIdMessage"] as? String {
                validIdMessage = val
            } else {
                validIdMessage = ""
            }
            
            SessionManager.setIsReseller(isReseller)
            SessionManager.setIsSeller(!isReseller)
            SessionManager.setIsEmailSubscribed(isEmailSubscribed)
            SessionManager.setIsSmsSubscribed(isSmsSubscribed)
            SessionManager.setUnReadMessagesCount(messageCount)
            
            if let val: AnyObject = value["bankAccount"] {
                
                if let temBankId = val["bankId"] as? Int {
                    bank_id = temBankId
                }

                
                if let temBankName = val["bankName"] as? String {
                    bank_name = temBankName
                }
                
                if let temAccountTitle = val["accountTitle"] as? String {
                    account_title = temAccountTitle
                }
                
                if let temAccountNumber = val["accountNumber"] as? String {
                    account_number = temAccountNumber
                }
                
                if let temAccountName = val["accountName"] as? String {
                    account_name = temAccountName
                }
                
                bank_account = account_number + "\n" + account_name + "\n" + bank_name
                
            }
            
            /*
            "storeCategory": {
            "categories": [
            {
            "productCategoryId": 2,
            "name": "Clothing  & Accessories",
            "isSelected": false
            },
            */
            
            if let val: AnyObject = value["storeCategory"] {
                if let categories: AnyObject = val["categories"] {
                    for category in categories as! NSArray {
                        if let tempVal = category["productCategoryId"] as? Int {
                            productId.append("\(tempVal)")
                        }
                        
                        if let tempVal = category["name"] as? String {
                            productCategoryName.append(tempVal)
                        }
                        
                        if let tempVal = category["isSelected"] as? Bool {
                            isSelected.append(tempVal)
                        }
                    }
                }
            }
            
            if let val: AnyObject = value["userAddress"] {
                
                if let temTitle = val["title"] as? String {
                    title = temTitle
                }
                
                if let temUnitNo = val["unitNumber"] as? String {
                    unit_number = temUnitNo
                }
                
                if let temBldgNo = val["buildingName"] as? String {
                    bldg_name = temBldgNo
                }
                
                if let temStreetNo = val["streetNumber"] as? String {
                    street_number = temStreetNo
                }
                
                if let temStreetName = val["streetName"] as? String {
                    street_name = temStreetName
                }
                
                if let temSubdivision = val["subdivision"] as? String {
                    subdivision = temSubdivision
                }
                
                if let temZipCode = val["zipCode"] as? String {
                    zip_code = temZipCode
                }
                
                if let tempVar = val["fullLocation"] as? String {
                    store_address = tempVar
                }
                
            }
            
        }

        let storeInfo: StoreInfoModel = StoreInfoModel(name: name, firstName: firstName, lastName: lastName, email: email, gender: gender, nickname: nickname, contact_number: contact_number, specialty: contact_number, birthdate: birthdate, store_name: store_name, store_description: store_description, storeSlug: storeSlug, avatar: avatar, cover_photo: cover_photo, is_allowed: is_followed, title: title, unit_number: unit_number, bldg_name: bldg_name, street_number: street_number, street_name: street_name, subdivision: subdivision, zip_code: zip_code, full_address: store_address, account_title: account_title, account_number: account_number,bank_account: bank_account, bank_id: bank_id, productCount: productCount, transactionCount: transactionCount, totalSales: totalSales, isReseller: isReseller, isEmailVerified: isEmailVerified, isEmailSubscribed: isEmailSubscribed, isSmsSubscribed: isSmsSubscribed, productId: productId, productCategoryName: productCategoryName, isSelected: isSelected, tin: tin, messageCount: messageCount, referralCode: referralCode, referrerCode: referrerCode, referrerName: referrerName, accountName: account_name, bankName: bank_name, validId: validId, isBankEditable: isBankEditable, isBusinessEditable: isBusinessEditable, isLegalDocsEditable: isLegalDocsEditable, validIdMessage: validIdMessage)
        
        return storeInfo
    }
}