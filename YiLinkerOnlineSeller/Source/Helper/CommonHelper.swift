//
//  CommonHelper.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct CommonHelper {
    static func firstCharacterUppercaseString(string: String) -> String {
        var str = string as NSString
        let firstUppercaseCharacter = str.substringToIndex(1).uppercaseString
        let firstUppercaseCharacterString = str.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstUppercaseCharacter)
        return firstUppercaseCharacterString
    }
}
