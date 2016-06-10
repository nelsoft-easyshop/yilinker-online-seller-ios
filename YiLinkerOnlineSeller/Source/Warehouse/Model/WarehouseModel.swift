//
//  WarehouseModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 6/7/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import Foundation

class WarehouseModel: NSObject {
    
    var barangayLocationID: Int = 0
    var barangayLocation: String = ""
    var cityLocationID: Int = 0
    var cityLocation: String = ""
    var provinceLocationID: Int = 0
    var provinceLocation: String = ""
    var countryLocationID: Int = 0
    var countryLocation: String = ""
    var flag: String = ""
    var id: Int = 0
    var name: String = ""
    var fullAddress: String = ""
    var address: String = ""
    var isDelete: Bool = false
    var zipCode: String = ""
    
    init (barangayLocationID: Int, barangayLocation: String, cityLocationID: Int, cityLocation: String, provinceLocationID: Int, provinceLocation: String, countryLocationID: Int, countryLocation: String, flag: String, id: Int, name: String, fullAddress: String, address: String, isDelete: Bool, zipCode: String)
    {
        self.barangayLocationID = barangayLocationID
        self.barangayLocation = barangayLocation
        self.cityLocationID = cityLocationID
        self.cityLocation = cityLocation
        self.provinceLocationID = provinceLocationID
        self.provinceLocation = provinceLocation
        self.countryLocationID = countryLocationID
        self.countryLocation = countryLocation
        self.flag = flag
        self.id = id
        self.name = name
        self.fullAddress = fullAddress
        self.address = address
        self.isDelete = isDelete
        self.zipCode = zipCode
    }
    
    class func parseDataWithDictionary (data: AnyObject) -> WarehouseModel {
        
        var barangayLocationID: Int = 0
        var barangayLocation: String = ""
        var cityLocationID: Int = 0
        var cityLocation: String = ""
        var provinceLocationID: Int = 0
        var provinceLocation: String = ""
        var countryLocationID: Int = 0
        var countryLocation: String = ""
        var flag: String = ""
        var id: Int = 0
        var name: String = ""
        var fullAddress: String = ""
        var address: String = ""
        var isDelete: Bool = false
        var zipCode: String = ""
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["barangay"]  {
                barangayLocationID = ParseHelper.int(barangay, key:"locationId", defaultValue: 0)
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["barangay"]  {
                barangayLocation = ParseHelper.string(barangay, key: "location", defaultValue: "")
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["city"]  {
                cityLocationID = ParseHelper.int(barangay, key:"locationId", defaultValue: 0)
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["city"]  {
                cityLocation = ParseHelper.string(barangay, key: "location", defaultValue: "")
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["province"]  {
                provinceLocationID = ParseHelper.int(barangay, key:"locationId", defaultValue: 0)
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["province"]  {
                provinceLocation = ParseHelper.string(barangay, key: "location", defaultValue: "")
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["country"]  {
                countryLocationID = ParseHelper.int(barangay, key:"locationId", defaultValue: 0)
            }
        }
        
        if let location: AnyObject = data["location"] {
            if let barangay: AnyObject = location["country"]  {
                countryLocation = ParseHelper.string(barangay, key: "location", defaultValue: "")
            }
        }
        
        if let location: AnyObject = data["location"] {
            flag = ParseHelper.string(location, key: "flag", defaultValue: "")
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            id = ParseHelper.int(warehouse, key:"id", defaultValue: 0)
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            name = ParseHelper.string(warehouse, key:"name", defaultValue: "")
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            fullAddress = ParseHelper.string(warehouse, key:"fullAddress", defaultValue:"")
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            address = ParseHelper.string(warehouse, key:"address", defaultValue:"")
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            isDelete = ParseHelper.bool(warehouse, key: "isDelete", defaultValue: false)
        }
        
        if let warehouse: AnyObject = data["warehouse"] {
            zipCode = ParseHelper.string(warehouse, key: "zipCode", defaultValue:"")
        }

        return WarehouseModel(barangayLocationID: barangayLocationID, barangayLocation: barangayLocation, cityLocationID: cityLocationID, cityLocation: cityLocation, provinceLocationID: provinceLocationID, provinceLocation: provinceLocation, countryLocationID: countryLocationID, countryLocation: countryLocation, flag: flag, id: id, name: name, fullAddress: fullAddress, address:address, isDelete: isDelete, zipCode: zipCode)
    }
    
}
