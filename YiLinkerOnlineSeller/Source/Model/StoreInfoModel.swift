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
    var is_allowed: Bool = false
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
    
    init(name : String, email : String, gender : String, nickname : String, contact_number : String, specialty : String, birthdate : String, store_name : String, store_description : String, avatar : NSURL, cover_photo : NSURL, is_allowed : Bool, unit_number: String, bldg_name: String, street_number: String, street_name: String, subdivision: String, zip_code: String, full_address: String, account_title: String, bank_account: String) {
        self.name = name
        self.email = email
        self.gender = gender
        self.nickname = nickname
        self.contact_number = contact_number
        self.specialty = specialty
        self.birthdate = birthdate
        self.store_name = store_name
        self.store_description = store_description
        self.avatar = avatar
        self.coverPhoto = cover_photo
        self.is_allowed = is_allowed
        self.unitNumber = unit_number
        self.bldgName = bldg_name
        self.streetName = street_name
        self.subdivision = subdivision
        self.zipCode = zip_code
        self.store_address = full_address
        self.bankAccount = bank_account
        self.accountTitle = account_title
    }

    class func parseSellerDataFromDictionary(dictionary: NSDictionary) -> StoreInfoModel {
        
        var name: String = ""
        var email: String = ""
        var gender: String = ""
        var nickname: String = ""
        var contact_number: String = ""
        var specialty: String = ""
        var birthdate: String = ""
        var store_name: String = ""
        var store_description: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var cover_photo: NSURL = NSURL(string: "")!
        var is_followed: Bool = false
        var store_address: String = ""
        var unit_number: String = ""
        var bldg_name: String = ""
        var street_number: String = ""
        var street_name: String = ""
        var subdivision: String = ""
        var zip_code: String = ""
        var account_name: String = ""
        var account_number: Int = 0
        var bank_name: String = ""
        var bank_account: String = ""
        var account_title: String = ""
        
        println(dictionary["data"])
        if let value: AnyObject = dictionary["data"] {
            
            if let sellerName = value["fullName"] as? String {
                name = sellerName
            } else {
                name = ""
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
            
            if let val: AnyObject = value["bankAccount"] {
                if let temBankName = val["bankName"] as? String {
                    bank_name = temBankName
                }
                
                if let temAccountTitle = val["accountTitle"] as? String {
                    account_title = temAccountTitle
                }
                
                if let temAccountNumber = val["accountNumber"] as? Int {
                    account_number = temAccountNumber
                }
                
                if let temAccountName = val["accountName"] as? String {
                    account_name = temAccountName
                }
                
                bank_account = "\(account_number)" + "\n" + account_name + "\n" + bank_name
                
            }
            
            if let val: AnyObject = value["userAddress"] {
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
                
                store_address = unit_number + " " + bldg_name + ", " + street_number + " " + street_name + ", " + subdivision + ", " + zip_code
                
                println("\(store_address)")
                
            }
            
        }
        
        let storeInfo: StoreInfoModel = StoreInfoModel(name: name, email: email, gender: gender, nickname: nickname, contact_number: contact_number, specialty: contact_number, birthdate: birthdate, store_name: store_name, store_description: store_description, avatar: avatar, cover_photo: cover_photo, is_allowed: is_followed, unit_number: unit_number, bldg_name: bldg_name, street_number: street_number, street_name: street_name, subdivision: subdivision, zip_code: zip_code, full_address: store_address, account_title: account_title, bank_account: bank_account)
        println("\(store_address)")
        return storeInfo
    }
    
}