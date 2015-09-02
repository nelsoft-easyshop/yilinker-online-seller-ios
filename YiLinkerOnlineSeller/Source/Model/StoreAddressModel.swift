//
//  StoreAddressModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreAddressModel: NSObject {
    
    var user_address_id: [Int] = []
    var location_id: [Int] = []
    var title: [String] = []
    var unit_number: [String] = []
    var building_name: [String] = []
    var street_number: [String] = []
    var street_name: [String] = []
    var subdivision: [String] = []
    var zip_code: [String] = []
    var street_address: [String] = []
    var country: [String] = []
    var island: [String] = []
    var region: [String] = []
    var province: [String] = []
    var city: [String] = []
    var municipality: [String] = []
    var barangay: [String] = []
    var longitude: [Double] = []
    var latitude: [Double] = []
    var landline: [String] = []
    var is_default: [Bool] = []
    
    init(user_address_id: NSArray, location_id: NSArray, title: NSArray, unit_number: NSArray, building_name: NSArray, street_number: NSArray, street_name: NSArray, subdivision: NSArray, zip_code: NSArray, street_address: NSArray, country: NSArray, island: NSArray, region: NSArray, province: NSArray, city: NSArray, municipality: NSArray, barangay: NSArray, longitude: NSArray, latitude: NSArray, landline: NSArray, is_default: NSArray){
    
        self.user_address_id = user_address_id as! [Int]
        self.location_id = location_id  as! [Int]
        self.title = title as! [String]
        self.unit_number = unit_number as! [String]
        self.building_name = building_name as! [String]
        self.street_number = street_number as! [String]
        self.country = country as! [String]
        self.island = island as! [String]
        self.region = region as! [String]
        self.province = province as! [String]
        self.city = city as! [String]
        self.municipality = municipality as! [String]
        self.barangay = barangay as! [String]
        self.longitude = longitude as! [Double]
        self.latitude = latitude as! [Double]
        self.landline = landline as! [String]
        self.is_default = is_default as! [Bool]
    
    }
    
    class func parseStoreAddressDataFromDictionary(dictionary: AnyObject) -> StoreAddressModel {
        var user_address_id: [Int] = []
        var location_id: [Int] = []
        var title: [String] = []
        var unit_number: [String] = []
        var building_name: [String] = []
        var street_number: [String] = []
        var street_name: [String] = []
        var subdivision: [String] = []
        var zip_code: [String] = []
        var street_address: [String] = []
        var country: [String] = []
        var island: [String] = []
        var region: [String] = []
        var province: [String] = []
        var city: [String] = []
        var municipality: [String] = []
        var barangay: [String] = []
        var longitude: [Double] = []
        var latitude: [Double] = []
        var landline: [String] = []
        var is_default: [Bool] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let addresses: AnyObject = dictionary["data"] {
   
                for address in addresses as! NSArray {
                    if let tempUserAddressId = address["userAddressId"] as? Int {
                        user_address_id.append(tempUserAddressId)
                    }
                    
                    if let tempLocationId = address["locationId"] as? Int {
                        location_id.append(tempLocationId)
                    }
                    
                    if let tempTitle = address["title"] as? String {
                        title.append(tempTitle)
                    }
                    
                    if let tempUnitNumber = address["unitNumber"] as? String {
                        unit_number.append(tempUnitNumber)
                    }
                    
                    if let tempBuildingName = address["buildingName"] as? String {
                        building_name.append(tempBuildingName)
                    }
                    
                    if let tempStreetNumber = address["streetNumber"] as? String {
                        street_number.append(tempStreetNumber)
                    }
                    
                    if let tempStreetName = address["streetName"] as? String {
                        street_name.append(tempStreetName)
                    }
                    
                    if let tempSubdivision = address["subdivision"] as? String {
                        subdivision.append(tempSubdivision)
                    }
                    
                    if let tempZipCode = address["zipCode"] as? String {
                        zip_code.append(tempZipCode)
                    }
                    
                    if let tempStreetAdress = address["streetAddress"] as? String {
                        street_address.append(tempStreetAdress)
                    }
                    
                    if let tempCountry = address["country"] as? String {
                        country.append(tempCountry)
                    }
                    
                    if let tempIsland = address["island"] as? String {
                        island.append(tempIsland)
                    }
                    
                    if let tempRegion = address["region"] as? String {
                        region.append(tempRegion)
                    }

                    if let tempProvince = address["province"] as? String {
                        province.append(tempProvince)
                    }
                    
                    if let tempCity = address["city"] as? String {
                        city.append(tempCity)
                    }
                    
                    if let tempMunicipality = address["municipality"] as? String {
                        municipality.append(tempMunicipality)
                    }
                    
                    if let tempBarangay = address["barangay"] as? String {
                        barangay.append(tempBarangay)
                    }
             
                    if let tempLongitude = address["longitude"] as? Double {
                        longitude.append(tempLongitude)
                    }
                    
                    if let tempLatitude = address["latitude"] as? Double {
                        latitude.append(tempLatitude)
                    }
                    
                    if let tempLandline = address["landline"] as? String {
                        landline.append(tempLandline)
                    }
                    
                    if let tempIsDefault = address["isDefault"] as? Bool {
                        is_default.append(tempIsDefault)
                    }
                }
            }
        }
        var storeAddressModel = StoreAddressModel(user_address_id: user_address_id, location_id: location_id, title: title, unit_number: unit_number, building_name: building_name, street_number: street_number, street_name: street_name, subdivision: subdivision, zip_code: zip_code, street_address: street_address, country: country, island: island, region: region, province: province, city: city, municipality: municipality, barangay: barangay, longitude: longitude, latitude: latitude, landline: landline, is_default: is_default)
        
        return storeAddressModel
    }
}
