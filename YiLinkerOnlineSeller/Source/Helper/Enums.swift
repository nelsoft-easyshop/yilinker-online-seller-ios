//
//  Enums.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

enum LoginType {
    case FacebookLogin
    case GoogleLogin
    case DirectLogin
}

enum PaymentType {
    case COD
    case CreditCard
}

enum CustomizeShoppingType {
    case Categories
    case Seller
    case Promos
    case Others
}

enum ProductTextFieldType {
    case Brand
    case Category
    case Condition
    case ProductName
    case ProductShortDescription
    case ProductCompleteDescription
    case ProductSKU
    case ProductRetailPrice
    case ProductDiscountPrice
    case ProductLenght
    case ProductWidth
    case ProductWeight
    case ProductHeight
}

enum AddressRefreshType {
    case Edit
    case Delete
    case Create
    case SetDefault
    case Get
    case Province
    case City
    case Barangay
}

enum VerifyType {
    case Verify
    case Resend
}

enum SearchRefreshType {
    case All
    case ProductName
    case TransactionId
    case Rider
}

enum UserType {
    case Seller
    case Reseller
}

enum ResellerItemStatus {
    case Selected
    case Unselected
}

enum StoreInfoType {
    case GetStroreInfo
    case SaveStoreInfo
    case SetMobile
    case VerifyNumber
    case GenerateQR
}

enum DisputePickerType {
    case TransactionList
    case DisputeType
    case ReasonType
}

enum TransactionOrderItemStatus {
    case Selected
    case UnSelected
}

enum DisputeRefreshType {
    case Transaction
    case AddCase
    case OrderType
    case Reason
}

enum UploadType {
    case NewProduct
    case Draft
    case EditProduct
}

enum RequestErrorType {
    case NoInternetConnection
    case RequestTimeOut
    case PageNotFound
    case AccessTokenExpired
    case ResponseError
    case UnRecognizeError
    case NoError
    case Cancel
}