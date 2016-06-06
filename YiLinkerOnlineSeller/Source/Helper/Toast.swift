//
//  Toast.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/15/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class Toast: NSObject {
    class func displayToastWithMessage(message: String, duration: NSTimeInterval, view: UIView) {
        var tempMessage = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        
        if message.isNotEmpty() {
            tempMessage = message
        }
        
        view.makeToast(tempMessage, duration: duration, position: CSToastPositionCenter, style: CSToastManager.sharedStyle())
    }
    
    class func displayToastBottomWithMessage(message: String, duration: NSTimeInterval, view: UIView) {
        var tempMessage = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        
        if message.isNotEmpty() {
            tempMessage = message
        }
        
        view.makeToast(tempMessage, duration: duration, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
    }
    
    class func displayToastWithMessage(message: String, view: UIView) {
        var tempMessage = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        
        if message.isNotEmpty() {
            tempMessage = message
        }
        
        view.makeToast(tempMessage, duration: 1.5, position: CSToastPositionCenter, style: CSToastManager.sharedStyle())
    }
}
