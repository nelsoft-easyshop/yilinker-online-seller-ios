//
//  Constansts.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

struct Constants {
    
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

        static let uploadViewColor: UIColor = HexaColor.colorWithHexa(0x54B6A7)
    }
    
    struct Credentials {
        static let clientID = "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
        static let clientSecret = "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
        static let grantRefresh = "refresh_token"
        static let grantSeller = "http://yilinker-online.com/grant/seller"
    }
}
