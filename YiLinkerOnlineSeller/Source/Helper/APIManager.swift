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
    static let getProductDetails = "auth/product/getProductDetail"
    static let sellerStoreInfo = "auth/merchant/getUserInfo"
    static let sellerBankAccountList = "auth/bank/account/getBankAccounts"
    static let sellerAddBankAccount = "auth/bank/account/addBankAccount"
    static let sellerDeleteBankAccount = "auth/bank/account/deleteBankAccount"
    static let sellerSetDefaultBankAccount = "auth/bank/account/setDefaultBankAccount"
    static let sellerStoreAddresses = "auth/address/getUserAddresses"
    static let sellerSetDefaultStoreAddress = "auth/address/setDefaultAddress"
    static let sellerDeleteStoreAddress = "auth/address/deleteUserAddress"
    static let transactionList = "auth/getTransactionList"
    static let transactionDetails = "auth/getTransaction"
    static let orderProductDetails = "auth/getOrderProductDetail"
    static let transactionCancellation = "auth/cancellation/reasons"
    static let transactionConsignee = "auth/getTransactionConsignee"
    static let postTransactionCancellation = "auth/transaction/cancel"
    static let shipItem = "auth/transaction/pickup"
    static let sellerChangeMobileNumber = "auth/user/changeContactNumber"
    static let sellerResendVerification = "auth/sms/getCode?access_token="
    static let sellerMobileNumberVerification = "auth/sms/verify"
    static let sellerChangePassword = "auth/user/changePassword"
    static let sellerUpdateSellerInfo = "auth/merchant/updateUserInfo"
    static let getCustomizedCategories   = "category/getCustomCategories"           // Applied
    static let getCategoryDetails        = "category/getCategoryDetails"            // Applied
    static let editCustomizedCategory    = "auth/category/updateCustomCategory"
    static let addCustomizedCategory     = "auth/category/addCustomCategory"        // Applied
    static let deleteCustomizedCategory  = "auth/category/deleteCustomCategory"     // Applied
    static let sortParentCategory        = "auth/category/sortParentCategories"
    static let checkIfCategoryNameExists = "auth/category/checkIfCategoryExists"
    static let getAllCategoryProducts    = "auth/category/getAllCategoryProducts"
    
    static let managementGetProductList = "auth/product/getProductList"
    static let managementUpdateProductStatus = "auth/product/updateProductStatus"
    static let editAddress = "auth/address/editUserAddress"
    static let provinceUrl = "location/getAllProvinces"
    static let citiesUrl = "location/getChildCities"
    static let barangay = "location/getBarangaysByCity"
    static let addAddressUrl = "auth/address/addNewAddress"
    static let sellerBank = "auth/bank/getEnabledBanks"
    static let sellerEditBankAccount = "auth/bank/account/editBankAccount"
    
    //My Points
    static let getPointsTotal = "auth/user/getPoints"
    static let getPointsHistory = "auth/user/getPointHistory"
    
    static let getSalesReport = "auth/merchant/getSalesReport"
    static let getFollowers = "auth/merchant/getFollowers"
    
    static let getActivityLogs = "auth/user/activityLog"
    
    static let getDeliveryLogs = "auth/getTransactionDeliveryLogs"
    
    static let postEmailNotif = "auth/email/subscription"
    static let postSMSNotif = "auth/sms/subscription"
    static let deactivate = "auth/account/disable"
    
    //Search
    static let transaction = "auth/transaction/searchKeyword?access_token="
    static let searchNameSuggestion = "auth/product/name-suggestion?access_token="
    
    //Resolution Center
    static let getResolutionCenterCases = "auth/dispute/get-case"
    static let getResolutionCenterCaseDetails = "auth/dispute/get-case-detail"
    static let resolutionCenterProductListUrl = "auth/getTransactionList"
    static let resolutionCenterGetTransactionItems = "auth/getTransaction"
    static let resolutionCenterAddCaseUrl = "auth/dispute/add-case"

    //Reseller
    static let resellerUrl = "auth/reseller/products"
    static let resellerUploadUrl = "auth/reseller/upload"
    
    static let baseUrl = APIEnvironment.baseUrl()
    
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = "/message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "/message/getConversationHead"
    static let ACTION_GET_CONTACTS          = "/message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "/message/getConversationMessages"
    static let ACTION_SET_AS_READ           = "/message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "/message/imageAttach"
    static let ACTION_GCM_CREATE            = "/auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE            = "/auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE            = "/device/auth/updateRegistrationId"
    static let uploadFileType = "jpeg"
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