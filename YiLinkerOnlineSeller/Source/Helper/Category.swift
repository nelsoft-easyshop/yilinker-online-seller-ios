//
//  Category.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

extension UITextField {
    func addToolBarWithTarget(target: AnyObject, next: Selector, previous: Selector, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let previousItem = UIBarButtonItem(image: UIImage(named: "previous"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: previous)
        
        let nextItem = UIBarButtonItem(image: UIImage(named: "next"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: next)
        
        var toolbarButtons = [previousItem, nextItem,flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar

    }
    
    func addToolBarWithTargetSearch(target: AnyObject, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            
        var toolbarButtons = [flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar
        
    }
    
    func addToolBarWithDoneTarget(target: AnyObject, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        var toolbarButtons = [flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar
        
    }
    
    func trim() -> String{
        return self.text.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func isValidPassword() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^(?=.*\\d)(?=.*[a-zA-Z])[^ ]{0,}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.text)
    }
    
//    func isValidEmail() -> Bool {
//        // println("validate calendar: \(testStr)")
//        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
//        
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluateWithObject(self.text)
//    }
//    
//    func isAlphaNumeric() -> Bool {
//        let passwordRegEx = "[A-Za-z0-9_]*"
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
//    
//        return passwordTest.evaluateWithObject(self.text)
//    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        return nameTest.evaluateWithObject(self.text)
    }
    
    func isGreaterThanEightCharacters() -> Bool {
        var result: Bool = false
        if count(self.text) >= 8 {
            result = true
        }
        
        return result
    }
    
    func isNotEmpty() -> Bool {
        var result: Bool = false
        if count(self.text) != 0 {
            result = true
        }
        return result
    }
    
    func isAphaOnly() -> Bool {
        let passwordRegEx = "[A-Za-z]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluateWithObject(self.text)
    }
    
    func isNumericOnly() -> Bool {
        let passwordRegEx = "[0-9]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluateWithObject(self.text)
    }
    
    func isGreaterThanOrEqualEightCharacters() -> Bool {
        var result: Bool = true
        if count(self.text) < 11 {
            result = false
        }
        return true
    }

    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
    }
}

extension UITextView {
    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
    }
}

extension UITextView {
    func addToolBarWithDoneTarget(target: AnyObject, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        var toolbarButtons = [flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar
        
    }
}

extension UILabel {
    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
    }
}


extension UITextView {
    
    func addToolBarWithTarget(target: AnyObject, next: Selector, previous: Selector, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let previousItem = UIBarButtonItem(image: UIImage(named: "previous"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: previous)
        
        let nextItem = UIBarButtonItem(image: UIImage(named: "next"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: next)
        
        var toolbarButtons = [previousItem, nextItem,flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar
        
    }
}


extension UIAlertController {
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String) {
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayNoInternetConnectionError(target: AnyObject) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displaySomethingWentWrongError(target: AnyObject) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayAlertRedirectionToLogin(target: AnyObject, actionHandler: (sucess: Bool) -> Void) {
        let alertController: UIAlertController = UIAlertController(title: Constants.Localized.error, message: "Cannot verify your account please login.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let login: UIAlertAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            actionHandler(sucess: true)
        })
        
        alertController.addAction(login)
        target.presentViewController(alertController, animated: true, completion: nil)
    }
    
}


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}


extension CAGradientLayer {
    func gradient() -> CAGradientLayer {
        let topColor = UIColor.clearColor()
        let bottomColor = UIColor.blackColor()
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd : Int) -> NSDate {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        return dateWithHoursAdded
    }
    
    func startOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: self)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        
        return calendar.dateByAddingComponents(months, toDate: self, options: nil)
    }
    
    func endOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        if let plusOneMonthDate = dateByAddingMonths(1) {
            let plusOneMonthDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: plusOneMonthDate)
            
            let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
            
            return endOfMonth
        }
        
        return nil
    }
}

extension String {
   
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    func trim() -> String{
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    //^(?:.*\d)(?:.*[a-z])(?:.*[A-Z])(?:.*[\W\_])[a-zA-Z0-9\W\_]{8,15}*$
    
    func isValidPassword() -> Bool {
        let emailRegEx = "^(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self) 
    }
    
    func isAlphaNumeric() -> Bool {
        let passwordRegEx = "[A-Za-z0-9_]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluateWithObject(self)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        return nameTest.evaluateWithObject(self)
    }
    
    func isNoSpecialCharacters() -> Bool {
        let regex = NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: nil, error: nil)!
        if regex.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil {
            println("could not handle special characters")
            return false
        }
        
        return true
    }
    
    func isGreaterThanEightCharacters() -> Bool {
        var result: Bool = false
        if count(self) >= 8 {
            result = true
        }
        
        return result
    }
    
    func isNotEmpty() -> Bool {
        var result: Bool = false
        if count(self) != 0 {
            result = true
        }
        return result
    }
    
    func isGreaterThanOrEqualEightCharacters() -> Bool {
        var result: Bool = true
        if count(self) < 11 {
            result = false
        }
        return true
    }
    
    func contains(find: String) -> Bool {
        return self.rangeOfString(find) != nil
    }
    
    func formatToTwoDecimal() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .DecimalStyle
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func formatToTwoDecimalNoTrailling() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func formatToNoTrailling() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func formatToPeso() -> String {
        return "₱\(self)"
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
    // capitalized first character
    func capitalizeFirst() -> String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result
    }
}


extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIDevice {
    public var deviceCode: String {
        var sysInfo: [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
        
        let code = sysInfo.withUnsafeMutableBufferPointer {
            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> String in
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
            return String.fromCString(machinePtr)!
        }
        
        return code
    }
    
    public var deviceModel: String {
        
        var model : String
        let deviceCode = UIDevice().deviceCode
        switch deviceCode {
            
        case "iPod1,1":                                 model = "iPod Touch 1G"
        case "iPod2,1":                                 model = "iPod Touch 2G"
        case "iPod3,1":                                 model = "iPod Touch 3G"
        case "iPod4,1":                                 model = "iPod Touch 4G"
        case "iPod5,1":                                 model = "iPod Touch 5G"
            
        case "iPhone1,1":                               model = "iPhone 2G"
        case "iPhone1,2":                               model = "iPhone 3G"
        case "iPhone2,1":                               model = "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     model = "iPhone 4"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     model = "iPhone 4"
        case "iPhone4,1":                               model = "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":                  model = "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  model = "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":                  model = "iPhone 5S"
        case "iPhone7,2":                               model = "iPhone 6"
        case "iPhone7,1":                               model = "iPhone 6 Plus"
        case "iPhone8,1":                               model = "iPhone 6S"
        case "iPhone8,2":                               model = "iPhone 6S Plus"
            
            
        case "iPad1,1":                                 model = "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":model = "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           model = "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           model = "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           model = "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":           model = "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           model = "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           model = "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           model = "iPad Mini 3"
            
        case "i386", "x86_64":                          model = "Simulator"
        default:                                        model = deviceCode //If unkhnown
        }
        
        return model
    }
}