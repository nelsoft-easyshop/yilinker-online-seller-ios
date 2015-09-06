//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = true
    static var staging = false
    static var production = false
    
    static func baseUrl() -> String {
        if development {
            return "http://merchant.online.api.easydeal.ph/api/v1"
        } else if staging {
            return ""
        } else  {
            return ""
        }
    }
}

struct APIAtlas {
    
    static let loginUrl = "login"
    static let refreshTokenUrl = "login"
    static let registerUrl = "user/register"
    static let conditionUrl = "product/getProductConditions"
    static let categoryUrl = "product/getCategories"
    static let brandUrl = "product/getBrands"
    static let uploadUrl = "product/upload"
    static let sellerStoreInfo = "auth/merchant/getUserInfo"
    static let sellerBankAccountList = "auth/bank/account/getBankAccounts"
    static let sellerAddBankAccount = "auth/bank/account/addBankAccount"
    static let sellerDeleteBankAccount = "auth/bank/account/deleteBankAccount"
    static let sellerSetDefaultBankAccount = "auth/bank/account/setDefaultBankAccount"
    static let sellerStoreAddresses = "auth/address/getUserAddresses"
    static let sellerDeleteStoreAddress = "auth/address/deleteUserAddress"
    static let transactionList = "auth/getTransactionList"
    
    static let getCustomizedCategories = "category/getCustomCategories"
    static let getCategoryDetails = "auth/category/getCategoryDetails"
    static let editCustomizedCategory = "auth/category/updateCustomCategory"
    static let addCustomizedCategory = "auth/category/addCustomCategory"
    static let deleteCustomizedCategory = "auth/category/deleteCustomCategory"
    static let sortParentCategory = "auth/category/sortParentCategories"
    static let checkIfCategoryNameExists = "auth/category/checkIfCategoryExists"
    static let getAllCategoryProducts = "auth/category/getAllCategoryProducts"

    
    
    static let baseUrl = APIEnvironment.baseUrl()
}

class APIManager: AFHTTPSessionManager {
    
    class var sharedInstance: APIManager {
        struct Static {
            static var instance: APIManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let url: NSURL! = NSURL(string: APIAtlas.baseUrl)
            Static.instance = APIManager(baseURL: url)
            Static.instance?.securityPolicy.allowInvalidCertificates = true
            Static.instance?.responseSerializer = JSONResponseSerializer()
        }
        
        return Static.instance!
    }
}