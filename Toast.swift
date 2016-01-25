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
        view.makeToast(message, duration: duration, position: CSToastPositionCenter, style: CSToastManager.sharedStyle())
    }
    
    class func displayToastBottomWithMessage(message: String, duration: NSTimeInterval, view: UIView) {
        view.makeToast(message, duration: duration, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
    }
    
    class func displayToastWithMessage(message: String, view: UIView) {
        view.makeToast(message, duration: 1.5, position: CSToastPositionCenter, style: CSToastManager.sharedStyle())
    }
}
