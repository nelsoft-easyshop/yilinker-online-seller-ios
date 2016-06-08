//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = true
    static var sprint = false
    static var staging = false
    static var production = false
    
    static func baseUrl() -> String {
        if development {
            return "http://dev.seller.online.api.easydeal.ph/api/"
        } else if staging {
            return "http://seller.online.api.easydeal.ph/api/"
        } else if sprint {
            return "http://sprint.seller.online.api.easydeal.ph/api/"
        } else  {
            return "https://seller.yilinker.com/api/"
        }
    }
}

struct APIAtlas {
    
    static let V3 = "v3"
    
    static let loginUrl = APIAtlas.generateV3URL("login")
    static let refreshTokenUrl = APIAtlas.generateV3URL("login")
    static let registerUrl = APIAtlas.generateV3URL("user/register")
    static let categoryUrl = APIAtlas.generateV3URL("product/getCategories")
    static let brandUrl = APIAtlas.generateV3URL("product/getBrands")
    static let uploadUrl = APIAtlas.generateV3URL("product/upload")
    static let getProductDetails = APIAtlas.generateV3URL("auth/product/get-upload-details")
    static let sellerStoreInfo = APIAtlas.generateV3URL("auth/merchant/getUserInfo")
    static let sellerBankAccountList = APIAtlas.generateV3URL("auth/bank/account/getBankAccounts")
    static let sellerAddBankAccount = APIAtlas.generateV3URL("auth/bank/account/addBankAccount")
    static let sellerDeleteBankAccount = APIAtlas.generateV3URL("auth/bank/account/deleteBankAccount")
    static let sellerSetDefaultBankAccount = APIAtlas.generateV3URL("auth/bank/account/setDefaultBankAccount")
    static let sellerStoreAddresses = APIAtlas.generateV3URL("auth/address/getUserAddresses")
    static let sellerSetDefaultStoreAddress = APIAtlas.generateV3URL("auth/address/setDefaultAddress")
    static let sellerDeleteStoreAddress = APIAtlas.generateV3URL("auth/address/deleteUserAddress")
    static let transactionList = APIAtlas.generateV3URL("auth/getTransactionList")
    static let transactionDetails = APIAtlas.generateV3URL("auth/getTransaction")
    static let orderProductDetails = APIAtlas.generateV3URL("auth/getOrderProductDetail")
    static let transactionCancellation = APIAtlas.generateV3URL("auth/cancellation/reasons")
    static let transactionConsignee = APIAtlas.generateV3URL("auth/getTransactionConsignee")
    static let postTransactionCancellation = APIAtlas.generateV3URL("auth/transaction/cancel")
    static let shipItem = APIAtlas.generateV3URL("auth/transaction/pickup")
    static let sellerChangeMobileNumber = APIAtlas.generateV3URL("auth/user/changeContactNumber")
    static let sellerResendVerification = APIAtlas.generateV3URL("auth/sms/getCode?access_token=")
    static let sellerMobileNumberVerification = APIAtlas.generateV3URL("auth/sms/verify")
    static let sellerChangePassword = APIAtlas.generateV3URL("auth/user/changePassword")
    static let sellerUpdateSellerInfo = APIAtlas.generateV3URL("auth/merchant/updateUserInfo")
    static let sellerGenerateQrCode = APIAtlas.generateV3URL("auth/merchant/getQrCode")
    static let getCustomizedCategories   = APIAtlas.generateV3URL("category/getCustomCategories")           // Applied
    static let getCategoryDetails        = APIAtlas.generateV3URL("category/getCategoryDetails")            // Applied
    static let editCustomizedCategory    = APIAtlas.generateV3URL("auth/category/updateCustomCategory")
    static let addCustomizedCategory     = APIAtlas.generateV3URL("auth/category/addCustomCategory")        // Applied
    static let deleteCustomizedCategory  = APIAtlas.generateV3URL("auth/category/deleteCustomCategory")     // Applied
    static let sortParentCategory        = APIAtlas.generateV3URL("auth/category/sortParentCategories")
    static let checkIfCategoryNameExists = APIAtlas.generateV3URL("auth/category/checkIfCategoryExists")
    static let getAllCategoryProducts    = APIAtlas.generateV3URL("auth/category/getAllCategoryProducts")
    
    static let conditionUrl = APIAtlas.generateV3URL("product/get-product-conditions")
    static let shippingCategoriesUrl = APIAtlas.generateV3URL("product/get-shipping-categories")
    static let productGroupsUrl = APIAtlas.generateV3URL("auth/product/get-product-groups")
    static let productBrandsUrl = APIAtlas.generateV3URL("product/get-brands")
    static let uploadImagesUrl = APIAtlas.generateV3URL("auth/image/upload")
    static let uploadProductUrl = APIAtlas.generateV3URL("auth/product/create")
    static let uploadProductEditUrl = APIAtlas.generateV3URL("auth/product/edit")
    
    static let managementGetProductList = APIAtlas.generateV3URL("auth/product/getProductList")
    static let managementUpdateProductStatus = APIAtlas.generateV3URL("auth/product/updateProductStatus")
    static let editAddress = APIAtlas.generateV3URL("auth/address/editUserAddress")
    static let provinceUrl = APIAtlas.generateV3URL("location/getAllProvinces")
    static let citiesUrl = APIAtlas.generateV3URL("location/getChildCities")
    static let barangay = APIAtlas.generateV3URL("location/getBarangaysByCity")
    static let addAddressUrl = APIAtlas.generateV3URL("auth/address/addNewAddress")
    static let sellerBank = APIAtlas.generateV3URL("auth/bank/getEnabledBanks")
    static let sellerEditBankAccount = APIAtlas.generateV3URL("auth/bank/account/editBankAccount")
    
    
    //My Points
    static let getPointsTotal = APIAtlas.generateV3URL("auth/user/getPoints")
    static let getPointsHistory =  APIAtlas.generateV3URL("auth/user/getPointHistory")
    
    static let getSalesReport = APIAtlas.generateV3URL("auth/merchant/getSalesReport")
    static let getFollowers = APIAtlas.generateV3URL("auth/merchant/getFollowers")
    
    static let getActivityLogs = APIAtlas.generateV3URL("auth/user/activityLog")
    
    static let getDeliveryLogs = APIAtlas.generateV3URL("auth/getTransactionDeliveryLogs")
    
    static let postEmailNotif = APIAtlas.generateV3URL("auth/email/subscription")
    static let postSMSNotif = APIAtlas.generateV3URL("auth/sms/subscription")
    static let deactivate = APIAtlas.generateV3URL("auth/account/disable")
    
    //Search
    static let transaction = APIAtlas.generateV3URL("auth/transaction/searchKeyword?access_token=")
    static let searchNameSuggestion = APIAtlas.generateV3URL("auth/product/name-suggestion?access_token=")
    static let searchRiderSuggestion = APIAtlas.generateV3URL("auth/suggestPackageHandler?access_token=")
    static let transactionLogs = APIAtlas.generateV3URL("auth/getTransactionList?access_token=")
    
    //Resolution Center
    static let getResolutionCenterCases = APIAtlas.generateV3URL("auth/dispute/get-case")
    static let getResolutionCenterCaseDetails = APIAtlas.generateV3URL("auth/dispute/get-case-detail")
    static let resolutionCenterProductListUrl = APIAtlas.generateV3URL("auth/getTransactionList")
    static let resolutionCenterGetTransactionItems = APIAtlas.generateV3URL("auth/getTransaction")
    static let resolutionCenterAddCaseUrl = APIAtlas.generateV3URL("auth/dispute/add-case")
    static let resolutionCenterReasons = APIAtlas.generateV3URL("auth/dispute/get-seller-reasons?access_token=")
    //Reseller
    static let resellerUrl = APIAtlas.generateV3URL("auth/reseller/products")
    static let resellerUploadUrl = APIAtlas.generateV3URL("auth/reseller/upload")
    
    static let baseUrl = APIEnvironment.baseUrl()
    
    static let uploadDraftUrl = APIAtlas.generateV3URL("product/upload/draft")
    static let uploadEditUrl = APIAtlas.generateV3URL("product/edit")
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = APIAtlas.generateV3URL("message/sendMessage")
    static let ACTION_GET_CONVERSATION_HEAD = APIAtlas.generateV3URL("message/getConversationHead")
    static let ACTION_GET_CONTACTS          = APIAtlas.generateV3URL("message/getContacts")
    static let ACTION_GET_CONVERSATION_MESSAGES = APIAtlas.generateV3URL("message/getConversationMessages")
    static let ACTION_SET_AS_READ           = APIAtlas.generateV3URL("message/setConversationAsRead")
    static let ACTION_IMAGE_ATTACH          = APIAtlas.generateV3URL("message/imageAttach")
    static let ACTION_GCM_CREATE            = APIAtlas.generateV3URL("auth/device/addRegistrationId")
    static let ACTION_GCM_DELETE            = APIAtlas.generateV3URL("auth/device/deleteRegistrationId")
    static let ACTION_GCM_UPDATE            = APIAtlas.generateV3URL("device/auth/updateRegistrationId")
    static let uploadFileType = "jpeg"
    
    // Sprint1
    static let getBalanceRecordDetails = APIAtlas.generateV3URL("auth/bank/balanceRecordDetails")
    static let OTPAuth = APIAtlas.generateV3URL("auth/sms/send")
    static let submitWithdrawalRequest = APIAtlas.generateV3URL("auth/withdrawal-request")
    
    // Payout
    static let payoutRequestList = APIAtlas.generateV3URL("auth/withdraw-list?access_token=")
    static let payoutEarningsGroup = APIAtlas.generateV3URL("auth/earning-groups?access_token=")
    static let payoutEarningsList = APIAtlas.generateV3URL("auth/earning-list?access_token=")
    
    //MARK: - V2 APIs
    
    //Login
    static let loginUrlV2 = APIAtlas.generateV3URL("login")
    //OTP
    static let unauthenticateOTP = APIAtlas.generateV3URL("sms/send")
    
    //Register
    static let registerV2 = APIAtlas.generateV3URL("user/register")
    
    //Fogot Password
    static let forgotPasswordV2 = APIAtlas.generateV3URL("user/resetPassword")
    
    //Edit Profile
    static let sendEmailVerificationAffiliate = APIAtlas.generateV3URL("auth/affiliate/verify-email")
    static let saveEditProfileAffiliate = APIAtlas.generateV3URL("auth/affiliate/update-user-info")
    
    //Uploade Image
    static let uploadImage = APIAtlas.generateV3URL("auth/image/upload")

    //Upload Image
    static let uploadImageUrl = APIAtlas.generateV3URL("auth/image/upload")
    
    //Affiliate Store Setup
    static let affiliateStoreSetupUrl = APIAtlas.generateV3URL("auth/store/setup")
    
    static let affiliateGetProduct = APIAtlas.generateV3URL("auth/product/getAffiliateProducts")
    
    static let affiliateSaveOrRemoveProductUrl = APIAtlas.generateV3URL("auth/product/saveAffiliateProducts")
    
    static let affiliateGetCategories = APIAtlas.generateV3URL("auth/product/getCategories")
    
    static func mobileFeedBack() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV3URL("auth/mobile-feedback/add")
        } else {
            return APIAtlas.generateV3URL("mobile-feedback/add")
        }
    }
    
    //Product Language Translation
    static let productLanguages = APIAtlas.generateV3URL("auth/product/get-languages")
    static let productTranslation = "auth/product/get-translation"
    static let translateProduct = "auth/product/translate"
    
    static func generateV3URL(url: String) -> String {
        return "\(APIAtlas.V3)/\(SessionManager.selectedCountryCode())/\(SessionManager.selectedLanguageCode())/\(url)"
    }
    
    
    // V3
    
    // Coutry Store
    
    static let getCountryList = APIAtlas.generateV3URL("auth/country-setup/country-store?access_token=")
    static let getCountrySetupDetails = APIAtlas.generateV3URL("auth/country-setup?access_token=")
    static let setWarehouse = APIAtlas.generateV3URL("auth/country-setup/setwarehouse?access_token=")
    static let saveCombinations = APIAtlas.generateV3URL("auth/country-setup/save-combinations?access_token=")
    
    //Warehouse
    static let warehouseInventory = APIAtlas.generateV3URL("auth/warehouse/inventory")
    static let getWarehouseList = APIAtlas.generateV3URL("auth/warehouse/list?access_token=")
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