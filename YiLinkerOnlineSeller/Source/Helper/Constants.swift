//
//  Constansts.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

struct Constants {
    
    struct WebServiceStatusCode {
        static let pageNotFound: Int = 404
        static let expiredAccessToken: Int = 401
        static let requestTimeOut: Int = 408
    }
    
    struct Localized {
        static let ok: String = StringHelper.localizedStringWithKey("OK_BUTTON_LOCALIZE_KEY")
        static let someThingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        static let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        static let failed: String = StringHelper.localizedStringWithKey("FAILED_LOCALIZE_KEY")
        static let done: String = StringHelper.localizedStringWithKey("TOOLBAR_DONE_LOCALIZE_KEY")
        static let success: String = StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TITLE_LOCALIZE_KEY")
        static let serverError: String = StringHelper.localizedStringWithKey("SERVER_ERROR_LOCALIZE_KEY")
        static let next: String = StringHelper.localizedStringWithKey("NEXT_LOCALIZE_KEY")
        static let previous: String = StringHelper.localizedStringWithKey("PREVIOUS_LOCALIZE_KEY")
        static let no: String = StringHelper.localizedStringWithKey("NO_LOCALIZE_KEY")
        static let yes: String = StringHelper.localizedStringWithKey("YES_LOCALIZE_KEY")
        static let invalid: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_INVALID_LOCALIZE_KEY")
        static let noInternet: String = StringHelper.localizedStringWithKey("NO_INTERNET_LOCALIZE_KEY")
        static let noInternetErrorMessage: String = StringHelper.localizedStringWithKey("CONNECTION_ERROR_MESSAGE_LOCALIZE_KEY")
        static let targetNotAvailable: String = StringHelper.localizedStringWithKey("TARGET_NOT_AVAILABLE")
        static let pageNotFound: String = StringHelper.localizedStringWithKey("PAGE_NOT_FOUND_LOCALIZE_KEY")
    }

    struct Colors {
        static let appTheme: UIColor = HexaColor.colorWithHexa(0x5A1F75)
        static let productDetails: UIColor = HexaColor.colorWithHexa(0xd52371)
        static let productPrice: UIColor = HexaColor.colorWithHexa(0x75348a)
        static let productReviewGreen: UIColor = HexaColor.colorWithHexa(0xb3b233)
        static let grayLine: UIColor = HexaColor.colorWithHexa(0x606060)
        static let backgroundGray: UIColor = HexaColor.colorWithHexa(0xEBEBF2)
        static let grayText: UIColor = HexaColor.colorWithHexa(0x666666)
        static let selectedGreenColor: UIColor = HexaColor.colorWithHexa(0x44A491)
        static let selectedCellColor: UIColor = HexaColor.colorWithHexa(0xE1E1E1)
        static let lightBackgroundColor: UIColor = HexaColor.colorWithHexa(0xE7E7E7)
        
        // Product Management
        static let pmActiveGreenColor: UIColor = HexaColor.colorWithHexa(0x01aa01)
        static let pmInactiveRedColor: UIColor = HexaColor.colorWithHexa(0xff3b30)
        static let pmCellTitleColor: UIColor = HexaColor.colorWithHexa(0x666666)
        static let pmCellSubTitleColor: UIColor = HexaColor.colorWithHexa(0x999999)
        static let pmPurpleButtonColor: UIColor = HexaColor.colorWithHexa(0x75348a)
        static let pmCheckRedColor: UIColor = HexaColor.colorWithHexa(0x380016)
        static let pmCheckGreenColor: UIColor = HexaColor.colorWithHexa(0x32c000)
        static let pmDeleteRedColor: UIColor = HexaColor.colorWithHexa(0xff3b30)

        static let pmYesGreenColor: UIColor = HexaColor.colorWithHexa(0x54b6a7)
        static let pmNoBrownColor: UIColor = HexaColor.colorWithHexa(0x666666)
        
        static let hex666666: UIColor = HexaColor.colorWithHexa(0x666666)

        static let uploadViewColor: UIColor = HexaColor.colorWithHexa(0x54B6A7)
        
        //Transactions
        static let transactionGreen: UIColor = HexaColor.colorWithHexa(0x6ec850)
        static let transactionGrey: UIColor = HexaColor.colorWithHexa(0xB6B6B6)
        static let transactionNew: UIColor = HexaColor.colorWithHexa(0xF6B300)
        static let transactionOngoing: UIColor = HexaColor.colorWithHexa(0xEC6A00)
        static let transactionCompleted: UIColor = HexaColor.colorWithHexa(0x48B400)
        static let transactionCancelled: UIColor = HexaColor.colorWithHexa(0xB6B6B6)
        
        static let soldColor: UIColor = HexaColor.colorWithHexa(0x409185)
        static let soldLineColor: UIColor = HexaColor.colorWithHexa(0x409185)
        static let cancelledColor: UIColor = HexaColor.colorWithHexa(0xF1B54D)
        static let cancelledLineColor: UIColor = HexaColor.colorWithHexa(0xF1B54D)
        
        //Payout
        static let completedColor: UIColor = HexaColor.colorWithHexa(0x4DB5A6)
        static let tentativeColor: UIColor = HexaColor.colorWithHexa(0x5181D4)
        static let inProgressColor: UIColor = HexaColor.colorWithHexa(0x717171)
    }
    
    struct Credentials {
        //development
        static let clientID = "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
        static let clientSecret = "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
//        static let clientID = "3_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
//        static let clientSecret = "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
//        //production
//        static let clientID = "1_9t2337riou0wsws84ckw8gkck8os8skw8cokoooc04gc0kssc"
//        static let clientSecret = "1vmep15il4cgw8gc0g8gokokk0wwkko0cg0go0s4c484kwswo4"
//
        static let grantRefreshToken = "refresh_token"
        static let grantSeller = "http://yilinker-online.com/grant/seller"
        
        //development
        static func getClientId(isSeller: Bool) -> String {
            if isSeller {
                if APIEnvironment.development {
                    return "3_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
                } else if APIEnvironment.staging {
                    return "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
                } else {
                    return "1_9t2337riou0wsws84ckw8gkck8os8skw8cokoooc04gc0kssc"
                }
            } else {
                if APIEnvironment.development {
                    return "3_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
                } else if APIEnvironment.staging {
                    return "3_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
                } else {
                    return "4_5scc2qrbwwkc0w0k0s0488o404kswgw8s0884k8kkw4w8ks488"
                }
            }
        }
        
        static func getClientSecret(isSeller: Bool) -> String {
            if isSeller {
                if APIEnvironment.development {
                    return "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
                } else if APIEnvironment.staging {
                    return "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
                } else {
                    return "1vmep15il4cgw8gc0g8gokokk0wwkko0cg0go0s4c484kwswo4"
                }
            } else {
                if APIEnvironment.development {
                    return "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
                } else if APIEnvironment.staging {
                    return "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
                } else {
                    return "5jztr6if1u04kok4w0gkwkco400csgg8gc4gcoogooogscc8s0"
                }
            }
        }
        
        //production
//        func getClientId(isSeller: Bool) -> String {
//            if isSeller {
//                return "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
//            } else {
//                return "3_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
//            }
//        }
//
//        func getClientSecret(isSeller: Bool) -> String {
//            if isSeller {
//                return "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
//            } else {
//                return "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
//            }
//        }
    }
    
    struct Checkout {
        static let changeAddressCollectionViewCellNibNameAndIdentifier = "ChangeAddressCollectionViewCell"
        static let changeAddressFooterCollectionViewCellNibNameAndIdentifier = "ChangeAddressFooterCollectionViewCell"
        
        static let newAddressTableViewCellNibNameAndIdentifier = "NewAddressTableViewCell"
        
    }
    
    // MARK: - View Controllers Title String
    struct ViewControllersTitleString {
        static let atttributeList: String = StringHelper.localizedStringWithKey("ATTRIBUTE_LIST_LOCALIZE_KEY")
        static let addCombination: String = StringHelper.localizedStringWithKey("ADD_COMBINATION_LOCALIZE_KEY")
        static let productUpload: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_LOCALIZE_KEY")
        static let productEdit: String = StringHelper.localizedStringWithKey("PRODUCT_EDIT_LOCALIZE_KEY")
        static let addBrand: String = StringHelper.localizedStringWithKey("ADD_BRAND_DETAILS_LOCALIZE_KEY")
        static let attributeCombination = StringHelper.localizedStringWithKey("ATTRIBUTE_COMBINATION_LOCALIZE_KEY")
    }
}

struct AlertStrings {
    static let alertWishlist = StringHelper.localizedStringWithKey("ALERT_ADDED_TO_WISHLIST_LOCALIZE_KEY")
    static let alertCart = StringHelper.localizedStringWithKey("ALERT_ADDED_TO_CART_LOCALIZE_KEY")
    static let alertLogin = StringHelper.localizedStringWithKey("ALERT_PLEASE_LOGIN_LOCALIZE_KEY")
    static let alertComplete = StringHelper.localizedStringWithKey("ALERT_PLEASE_COMPLETE_LOCALIZE_KEY")
    static let wentWrong = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    static let ok = StringHelper.localizedStringWithKey("OK_BUTTON_LOCALIZE_KEY")
    static let cancel = StringHelper.localizedStringWithKey("CANCEL_BUTTON_LOCALIZE_KEY")
    static let error = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    static let failed = StringHelper.localizedStringWithKey("FAILED_LOCALIZE_KEY")
    static let checkInternet = StringHelper.localizedStringWithKey("PLEASE_CHECK_INTERNET_LOCALIZE_KEY")
}