//
//  StoreInfoModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class StoreInfoModel: NSObject {
    /*
    "{
    ""isSuccessful"": true,
    ""message"": ""Store info."",
    ""data"": {
    ""userId"": 1,
    ""fullName"": ""Kevin Baisas"",
    ""firstName"": ""Kevin"",
    ""lastName"": ""Baisas"",
    ""email"": ""kevin.baisas@easyshop.ph"",
    ""gender"": ""M"",
    ""nickname"": null,
    ""contactNumber"": ""6378523"",
    ""specialty"": ""PARENT"",
    ""birthdate"": ""Nov 06, 2015"",
    ""storeName"": ""Test Store"",
    ""storeDescription"": ""Lorem ipsum dolor sit amet"",
    ""profilePhoto"": ""http://yilinker-online.dev/assets/images/uploads/users/1/seller-img-1.jpg?"",
    ""coverPhoto"": """",
    ""isFollowed"": false,
    ""storeAddress"": {
    ""userAddressId"": 4,
    ""locationId"": 1106,
    ""unitNumber"": null,
    ""buildingName"": null,
    ""streetNumber"": null,
    ""streetName"": null,
    ""subdivision"": null,
    ""zipCode"": null,
    ""streetAddress"": null,
    ""province"": null,
    ""city"": ""City"",
    ""municipality"": ""Municipality"",
    ""barangay"": null,
    ""longitude"": null,
    ""latitude"": null,
    ""landline"": null
    }
    }
    }"

    */
    
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
    
    init(name : String, email : String, gender : String, nickname : String, contact_number : String, specialty : String, birthdate : String, store_name : String, store_description : String, avatar : NSURL, cover_photo : NSURL, is_allowed : Bool, unit_number: String, bldg_name: String, street_number: String, street_name: String, subdivision: String, zip_code: String) {
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
        var unitNumber: String = ""
        var bldgName: String = ""
        var streetNumber: String = ""
        var streetName: String = ""
        var subdivision: String = ""
        var zipCode: String = ""
        
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
            
            if let val: AnyObject = value["storeAddress"] {
                if let temUnitNo = val["unitNumber"] as? String {
                    unitNumber = temUnitNo
                }
                
                if let temBldgNo = val["buildingName"] as? String {
                    bldgName = temBldgNo
                }
                
                if let temStreetNo = val["streetNumber"] as? String {
                    streetNumber = temStreetNo
                }
                
                if let temSubdivision = val["subdivision"] as? String {
                    subdivision = temSubdivision
                }
                
                if let temZipCode = val["zipCode"] as? String {
                    zipCode = temZipCode
                }
                /*
                store_address = unitNumber + " " + bldgName + ", " + streetName + ", " + subdivision + ", " + zipCode
                */
            }
            
        }
        
        let sellerModel: StoreInfoModel = StoreInfoModel(name: name, email: email, gender: gender, nickname: nickname, contact_number: contact_number, specialty: contact_number, birthdate: birthdate, store_name: store_name, store_description: store_description, avatar: avatar, cover_photo: cover_photo, is_allowed: is_followed, unit_number: unitNumber, bldg_name: bldgName, street_number: streetNumber, street_name: streetName, subdivision: subdivision, zip_code: zipCode)
        
        return sellerModel
    }
    
}