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