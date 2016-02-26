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
            return "http://sprint.seller.online.api.easydeal.ph/api/"
        } else if staging {
            return "http://seller.online.api.easydeal.ph/api/"
        } else  {
            return "https://seller.yilinker.com/api/"
        }
    }
}

struct APIAtlas {
    
    static let loginUrl = "v1/login"
    static let refreshTokenUrl = "v1/login"
    static let registerUrl = "v1/user/register"
    static let conditionUrl = "v1/product/getProductConditions"
    static let categoryUrl = "v1/product/getCategories"
    static let brandUrl = "v1/product/getBrands"
    static let uploadUrl = "v1/product/upload"
    static let getProductDetails = "v1/product/upload-details"
    static let sellerStoreInfo = "v1/auth/merchant/getUserInfo"
    static let sellerBankAccountList = "v1/auth/bank/account/getBankAccounts"
    static let sellerAddBankAccount = "v1/auth/bank/account/addBankAccount"
    static let sellerDeleteBankAccount = "v1/auth/bank/account/deleteBankAccount"
    static let sellerSetDefaultBankAccount = "v1/auth/bank/account/setDefaultBankAccount"
    static let sellerStoreAddresses = "v1/auth/address/getUserAddresses"
    static let sellerSetDefaultStoreAddress = "v1/auth/address/setDefaultAddress"
    static let sellerDeleteStoreAddress = "v1/auth/address/deleteUserAddress"
    static let transactionList = "v1/auth/getTransactionList"
    static let transactionDetails = "v1/auth/getTransaction"
    static let orderProductDetails = "v1/auth/getOrderProductDetail"
    static let transactionCancellation = "v1/auth/cancellation/reasons"
    static let transactionConsignee = "v1/auth/getTransactionConsignee"
    static let postTransactionCancellation = "v1/auth/transaction/cancel"
    static let shipItem = "v1/auth/transaction/pickup"
    static let sellerChangeMobileNumber = "v1/auth/user/changeContactNumber"
    static let sellerResendVerification = "v1/auth/sms/getCode?access_token="
    static let sellerMobileNumberVerification = "v1/auth/sms/verify"
    static let sellerChangePassword = "v1/auth/user/changePassword"
    static let sellerUpdateSellerInfo = "v1/auth/merchant/updateUserInfo"
    static let sellerGenerateQrCode = "v1/auth/merchant/getQrCode"
    static let getCustomizedCategories   = "v1/category/getCustomCategories"           // Applied
    static let getCategoryDetails        = "v1/category/getCategoryDetails"            // Applied
    static let editCustomizedCategory    = "v1/auth/category/updateCustomCategory"
    static let addCustomizedCategory     = "v1/auth/category/addCustomCategory"        // Applied
    static let deleteCustomizedCategory  = "v1/auth/category/deleteCustomCategory"     // Applied
    static let sortParentCategory        = "v1/auth/category/sortParentCategories"
    static let checkIfCategoryNameExists = "v1/auth/category/checkIfCategoryExists"
    static let getAllCategoryProducts    = "v1/auth/category/getAllCategoryProducts"
    
    static let managementGetProductList = "v1/auth/product/getProductList"
    static let managementUpdateProductStatus = "v1/auth/product/updateProductStatus"
    static let editAddress = "v1/auth/address/editUserAddress"
    static let provinceUrl = "v1/location/getAllProvinces"
    static let citiesUrl = "v1/location/getChildCities"
    static let barangay = "v1/location/getBarangaysByCity"
    static let addAddressUrl = "v1/auth/address/addNewAddress"
    static let sellerBank = "v1/auth/bank/getEnabledBanks"
    static let sellerEditBankAccount = "v1/auth/bank/account/editBankAccount"
    
    //My Points
    static let getPointsTotal = "v1/auth/user/getPoints"
    static let getPointsHistory = "v1/auth/user/getPointHistory"
    
    static let getSalesReport = "v1/auth/merchant/getSalesReport"
    static let getFollowers = "v1/auth/merchant/getFollowers"
    
    static let getActivityLogs = "v1/auth/user/activityLog"
    
    static let getDeliveryLogs = "v1/auth/getTransactionDeliveryLogs"
    
    static let postEmailNotif = "v1/auth/email/subscription"
    static let postSMSNotif = "v1/auth/sms/subscription"
    static let deactivate = "v1/auth/account/disable"
    
    //Search
    static let transaction = "v1/auth/transaction/searchKeyword?access_token="
    static let searchNameSuggestion = "v1/auth/product/name-suggestion?access_token="
    static let searchRiderSuggestion = "v1/auth/suggestPackageHandler?access_token="
    static let transactionLogs = "v1/auth/getTransactionList?access_token="
    
    //Resolution Center
    static let getResolutionCenterCases = "v1/auth/dispute/get-case"
    static let getResolutionCenterCaseDetails = "v1/auth/dispute/get-case-detail"
    static let resolutionCenterProductListUrl = "v1/auth/getTransactionList"
    static let resolutionCenterGetTransactionItems = "v1/auth/getTransaction"
    static let resolutionCenterAddCaseUrl = "v1/auth/dispute/add-case"
    static let resolutionCenterReasons = "v1/auth/dispute/get-seller-reasons?access_token="
    //Reseller
    static let resellerUrl = "v1/auth/reseller/products"
    static let resellerUploadUrl = "v1/auth/reseller/upload"
    
    static let baseUrl = APIEnvironment.baseUrl()
    
    static let uploadDraftUrl = "v1/product/upload/draft"
    static let uploadEditUrl = "v1/product/edit"
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = "v1/message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "v1/message/getConversationHead"
    static let ACTION_GET_CONTACTS          = "v1/message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "v1/message/getConversationMessages"
    static let ACTION_SET_AS_READ           = "v1/message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "v1/message/imageAttach"
    static let ACTION_GCM_CREATE            = "v1/auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE            = "v1/auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE            = "v1/device/auth/updateRegistrationId"
    static let uploadFileType = "jpeg"
    
    // Sprint1
    static let getBalanceRecordDetails = "v1/auth/bank/balanceRecordDetails"
    static let OTPAuth = "v2/auth/sms/send"
    static let submitWithdrawalRequest = "v1/auth/withdrawal-request"
    
    // Payout
    static let payoutRequestList = "v1/auth/withdraw-list?access_token="
    static let payoutEarningsGroup = "v1/auth/earning-groups?access_token="
    static let payoutEarningsList = "v1/auth/earning-list?access_token="
    
    //MARK: - V2 APIs
    
    //Login
    static let loginUrlV2 = "v2/login"
    //OTP
    static let unauthenticateOTP = "v2/sms/send"
    
    //Register
    static let registerV2 = "v2/user/register"
    
    //Fogot Password
    static let forgotPasswordV2 = "v2/user/resetPassword"
    
    //Edit Profile
    static let sendEmailVerificationAffiliate = "v2/auth/affiliate/verify-email"
    static let saveEditProfileAffiliate = "v2/auth/affiliate/update-user-info"
    
    //Uploade Image
    static let uploadImage = "v2/auth/image/upload"
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
            
            Static.instance?.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.Certificate)
            let certificatePath = NSBundle.mainBundle().pathForResource("yilinker_pinned_certificate", ofType: "cer")!
            let certificateData = NSData(contentsOfFile: certificatePath)!
            Static.instance?.securityPolicy.pinnedCertificates = [certificateData];
            Static.instance?.securityPolicy.validatesDomainName = true
            Static.instance?.securityPolicy.allowInvalidCertificates = true
            
            Static.instance?.responseSerializer = JSONResponseSerializer()
        }
        
        return Static.instance!
    }
}