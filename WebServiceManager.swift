//
//  WebServiceManager.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/15/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject {
    
    // MARK: - OTHERS
    static private var postTask: NSURLSessionDataTask?
    
    // MARK: - KEYS
    // MARK: Login Dictionary Keys
    static let emailKey = "email"
    static let passwordKey = "password"
    static let clientIdKey = "client_id"
    static let clientSecretKey = "client_secret"
    static let grantTypeKey = "grant_type"
    static let registrationIdKey = "registrationId"
    static let accessTokenKey = "access_token"
    static let tokenKey = "token"
    
    // MARK: Refresh Token
    static let refreshTokenKey = "refresh_token"
    
    // MARK: Product Management Keys
    static let statusKey = "status"
    static let keywordKey = "keyword"
    static let productIdKey = "productId"
    
    // MARK: Customized Category Keys
    static let categoryIdKey = "categoryId"
    static let queryStringKey = "queryString"
    
    
    // MARK: Activity Logs Keys
    static let pageKey = "page"
    static let perPageKey = "perPage"
    
    //Unathenticated OTP
    static let areaCodeKey = "areaCode"
    static let typeKey = "type"
    static let storeTypeKey = "storeType"
    
    //Register
    static let verificationCodeKey = "verificationCode"
    static let contactNumberKey = "contactNumber"
    static let newPasswordKey = "newPassword"
    static let referralCodeKey = "referralCode"
    
    // MARK: - CALLS
    // MARK: - Post Request With Url
    // This function is for removing repeated codes in handler
    private static func firePostRequestWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task   : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    // MARK: - Get Request With Url
    // This function is for removing repeated codes in handler
    private static func fireGetRequestWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            manager.GET(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: -
    //MARK: - Post Request With Url * Session Data Task
    //This function is for removing repeated codes in handler
    private static func firePostRequestSessionDataTaskWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager = APIManager.sharedInstance
        var sessionDataTask: NSURLSessionDataTask = NSURLSessionDataTask()
        if Reachability.isConnectedToNetwork() {
            sessionDataTask = manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .Cancel)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                        }
                    }
            })!
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Get Request With Url * Session Data Task
    //This function is for removing repeated codes in handler
    private static func fireGetRequestSessionDataTaskWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager = APIManager.sharedInstance
        var sessionDataTask: NSURLSessionDataTask = NSURLSessionDataTask()
        if Reachability.isConnectedToNetwork() {
            sessionDataTask = manager.GET(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .Cancel)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                        }
                    }
            })!
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
        
        return sessionDataTask
    }
    
    //MARK: - Post Request With Image
    //This function is for removing repeated codes in handler
    private static func firePostRequestWithImage(url: String, parameters: AnyObject, image: UIImage, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            
            self.postTask = manager.POST(url, parameters: parameters,
                constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(image, 1.0), name: "image", fileName: "yilinker", mimeType: "image/JPEG")
                }, success: { (task, responseObject) -> Void in
                    actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
            
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: - Post Request With Image
    //This function is for removing repeated codes in handler
    private static func firePostRequestStoreInfoImages(url: String, parameters: AnyObject, datas: [NSData], imageProfile: UIImage?, imageCover: UIImage?, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            
            self.postTask = manager.POST(url, parameters: parameters,
                constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                    //Append images converted into data to multipart
                    for (index, data) in enumerate(datas) {
                        if imageProfile != nil && imageCover != nil {
                            if(index == 0){
                                formData.appendPartWithFileData(data, name: "profilePhoto", fileName: "\(0)", mimeType: "image/jpeg")
                            } else {
                                formData.appendPartWithFileData(data, name: "coverPhoto", fileName: "\(1)", mimeType: "image/jpeg")
                            }
                        } else if imageProfile != nil && imageCover == nil{
                            formData.appendPartWithFileData(data, name: "profilePhoto", fileName: "\(index)", mimeType: "image/jpeg")
                        } else if imageProfile == nil && imageCover != nil {
                            formData.appendPartWithFileData(data, name: "coverPhoto", fileName: "\(index)", mimeType: "image/jpeg")
                        }
                    }
                }, success: { (task, responseObject) -> Void in
                    actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
            
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: - Post Request With Multiple Image
    //This function is for removing repeated codes in handler
    private static func firePostRequestWithMultipleImage(url: String, parameters: AnyObject, data: [NSData], actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            
            self.postTask = manager.POST(url, parameters: parameters,
                constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                    
                    for (index, datum) in enumerate(data) {
                        formData.appendPartWithFileData(datum, name: "images[]", fileName: "\(index)", mimeType: "image/jpeg")
                    }
                    
                }, success: { (task, responseObject) -> Void in
                    actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
            
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: -
    //MARK: - Fire RefreshTokenWithUrl
    class func fireRefreshTokenWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.clientIdKey: Constants.Credentials.clientID, self.clientSecretKey: Constants.Credentials.clientSecret, self.grantTypeKey: Constants.Credentials.grantRefreshToken, self.refreshTokenKey: SessionManager.refreshToken()]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Fire Login Request With URL
    class func fireLoginRequestWithUrl(url: String, emailAddress: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.clientIdKey: Constants.Credentials.clientID, self.clientSecretKey: Constants.Credentials.clientSecret, self.grantTypeKey: Constants.Credentials.grantSeller]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Product Management Calls
    // MARK: - Fire Product List Request With URL
    class func fireProductListRequestWithUrl(url: String, status: String, keyword: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.statusKey: status, self.keywordKey: keyword, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Update Product Status Request With URL
    class func fireUpdateProductStatusRequestWithUrl(url: String, productId: String, status: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.productIdKey: productId, self.statusKey: status, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Get Product Details Request With URL
    class func fireGetProductDetailsRequestWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Customized Category Calls
    // MARK: - Fire Get Customized Categories Request With URL
    class func fireGetCustomizedCategoriesRequestWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: SessionManager.accessToken(), self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Delete Customized Categories Request With URL
    class func fireDeleteCustomizedCategoryRequestWithUrl(url: String, categoryId: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.categoryIdKey: categoryId, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Delete Customized Categories Request With URL
    class func fireGetCategoryDetailsRequestWithUrl(url: String, categoryId: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.categoryIdKey: categoryId, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Delete Customized Categories Request With URL
    class func fireAddCustomizedCategoryRequestWithUrl(url: String, parameter: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
//        let parameters: NSDictionary = [self.categoryIdKey: categoryId, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameter) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Delete Customized Categories Request With URL
    class func fireEditCustomizedCategoryRequestWithUrl(url: String, parameter: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
//        let parameters: NSDictionary = [self.categoryIdKey: categoryId, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameter) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Get Parent Categories Request With URL
    class func fireGetParentCategoryRequestWithUrl(url: String, key: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.queryStringKey: key, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Add New Item Request With URL
    class func fireAddNewItemRequestWithUrl(url: String, key: String, status: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.statusKey: status, self.keywordKey: key, self.accessTokenKey: SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: -
    // MARK: - Store Info
    // MARK: Fire Store Info Request With URL
    // MARK: Get Store Info, Generate QR Code, Set Mobile Number, Resend Verification Code
    class func fireStoreInfoRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: Fire Save Store Info Request With URL
    class func fireSaveStoreInfoRequestWithUrl(url: String, parameters: NSDictionary, datas: [NSData], imageProfile: UIImage?, imageCover: UIImage?, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestStoreInfoImages(url, parameters: parameters, datas: datas, imageProfile: imageProfile, imageCover: imageCover)  { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType) 
        }
    }

    // MARK: -
    // MARK: - Resolution Center
    // MARK: Resolution Center Request With URL
    class func fireResolutionCenterRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireGetResolutionCenterRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Sprint 1
    
    // MARK: - Withdrawal Requests
    class func fireGetBalanceRecordRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Authenticated OTP
    // used to get code for withdrawal
    class func fireOTPAuthenticatedRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Authenticated OTP
    // used to get code for withdrawal
    class func fireSubmitWithdrawalRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: -
    // MARK: - Product Upload
    // MARK: Resolution Center Request With URL
    class func fireProductUploadRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireGetProductUploadRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireProductUploadImageRequestWithUrl(url: String, parameters: NSDictionary, data: [NSData], actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithMultipleImage(url, parameters: parameters, data: data) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }

    // MARK: - Activity Logs
    // MARK: Get Activity Logs Request With URL
    class func fireGetActivityLogsRequestWithUrl(url: String, access_token: String, page: String, perPage: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let tempURL = "\(url)?access_token=\(SessionManager.accessToken())&perPage=\(perPage)&page=\(page)"
        self.fireGetRequestWithUrl(tempURL, parameters:[]) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: -
    // MARK: - Payout Request
    // MARK: Payout Request Request With URL
    class func fireGetPayoutRequestEarningsRequestWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Email Login Request With URL
    class func fireEmailLoginRequestWithUrl(url: String, emailAddress: String, password: String, grantType: String, isSeller: Bool, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.clientIdKey: Constants.Credentials.getClientId(isSeller), self.clientSecretKey: Constants.Credentials.getClientSecret(isSeller), self.grantTypeKey: grantType]
        
        let sessionDataTask: NSURLSessionDataTask = self.firePostRequestSessionDataTaskWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Fire Contact Number Login Request With URL
    class func fireContactNumberLoginRequestWithUrl(url: String, contactNo: String, password: String, grantType: String, isSeller: Bool, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        //self.emailKey is used for contact number because the API is not yet configured to accept the 'contactNo' parameter
        let parameters: NSDictionary = [self.emailKey: contactNo, self.passwordKey: password, self.clientIdKey: Constants.Credentials.getClientId(isSeller), self.clientSecretKey: Constants.Credentials.getClientSecret(isSeller), self.grantTypeKey: grantType]
        
        let sessionDataTask: NSURLSessionDataTask = self.firePostRequestSessionDataTaskWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Fire Forgot Password Request With URL
    class func fireForgotPasswordrRequestWithUrl(url: String, verficationCode: String, newPassword: String, storeType: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager(baseURL: NSURL(string: url))
        
        manager.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.Certificate)
        let certificatePath = NSBundle.mainBundle().pathForResource("yilinker_pinned_certificate", ofType: "cer")!
        let certificateData = NSData(contentsOfFile: certificatePath)!
        manager.securityPolicy.pinnedCertificates = [certificateData];
        manager.securityPolicy.validatesDomainName = true
        manager.securityPolicy.allowInvalidCertificates = true
        manager.responseSerializer = JSONResponseSerializer()
        
        let parameters: NSDictionary = [self.verificationCodeKey: verficationCode, self.newPasswordKey: newPassword, self.storeTypeKey: storeType]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: -
    //MARK: - Fire Register Request With URL v2
    class func fireRegisterRequestWithUrl(url: String, contactNumber: String, password: String, areaCode: String, referralCode: String,  verificationCode: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.contactNumberKey: contactNumber, self.passwordKey: password, self.areaCodeKey: areaCode, self.referralCodeKey: referralCode, self.verificationCodeKey: verificationCode]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    println(error)
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: -
    //MARK: - Fire Get Unauthenticated OTP (One Time Password) With URL
    //Parameters  "type":"register/forgot-password"
    class func fireUnauthenticatedOTPRequestWithUrl(url: String, contactNumber: String, areaCode: String, type: String, storeType: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager()
        
        let parameters: NSDictionary = [self.contactNumberKey: contactNumber, self.areaCodeKey: areaCode, self.typeKey: type, self.storeTypeKey: storeType]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
}
