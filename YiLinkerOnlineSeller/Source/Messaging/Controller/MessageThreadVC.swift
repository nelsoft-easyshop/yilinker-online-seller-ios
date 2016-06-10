//
//  MessageThreadVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/3/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import AVFoundation

class MessageThreadVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var threadTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var threadTableView: UITableView!
    
    @IBOutlet weak var composeViewBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var composeTextView: TextViewAutoHeight!
    @IBOutlet weak var composeTVConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    let composeViewHeight : CGFloat = 50.0
    
    var tabBarHidden : Bool = false
    
    var sender : W_Contact?
    var recipient : W_Contact?
    
    var senderImage : UIImageView?
    var recipientImage : UIImageView?
    
    var screenWidth : CGFloat?
    var screenHeight: CGFloat?
    var tabBarHeight: CGFloat = 49.0
    
    var profileImageView: UIImageView!
    var onlineView: RoundedView!
    var profileNameLabel: UILabel!
    var onlineLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    var isBlank : Bool = false
    var imagePlaced : Bool = false
    var prevIsSame : Bool = false
    var keyboardIsShown : Bool = false
    var minimumYComposeView : CGFloat = 0.0
    var maximumXComposeTextView : CGFloat = 0.0
    var messages = [W_Messages]()
    
    var offlineColor = UIColor(red: 218/255, green: 32/255, blue: 43/255, alpha: 1.0)
    var onlineColor = UIColor(red: 84/255, green: 182/255, blue: 167/255, alpha: 1.0)
    
    let receiverIdentifier = "MessageBubbleReceiver"
    let senderIdentifier = "MessageBubbleSender"
    
    let receiverImageIndentifier = "MessageBubbleImageReceiver"
    let senderImageIndentifier = "MessageBubbleImageSender"
    
    let uploadImageSegueIdentifier = "upload_image"
    
    var hud: MBProgressHUD?
    
    var hasUnreadMessage : String = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == uploadImageSegueIdentifier){
            var imageVC = segue.destinationViewController as! ImageVC
            
            imageVC.sender = self.sender
            imageVC.recipient = self.recipient
            imageVC.imageVCDelegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = W_Messages()
        //messages = ref.testData()
        var r_temp = recipient?.userId ?? ""
        println(recipient)
        println("recipient id \(r_temp)")
        self.messages.removeAll(keepCapacity: false)
        self.getMessagesFromEndpoint("1", limit: "30", userId: r_temp)
        self.configureTableView()
        
        var imageStringRecipient = recipient?.profileImageUrl
        if imageStringRecipient != nil {
            var urlRecipient : NSURL = NSURL(string: imageStringRecipient!)!
            recipientImage = UIImageView()
            recipientImage!.sd_setImageWithURL(urlRecipient, placeholderImage: UIImage(named: "Male-50.png"))
        } else {
            recipientImage?.image = UIImage(named: "Male-50.png")
        }
        
        senderImage = UIImageView()
        var imageStringSender = sender!.profileImageUrl
        var urlSender : NSURL = NSURL(string: imageStringSender)!
        senderImage!.sd_setImageWithURL(urlSender, placeholderImage: UIImage(named: "Male-50.png"))
        
        minimumYComposeView = composeView.frame.origin.y
        maximumXComposeTextView = composeTextView.contentSize.height * 3
        
        screenWidth = UIScreen.mainScreen().bounds.size.width
        screenHeight = UIScreen.mainScreen().bounds.size.height
        
        
        var tableFrame : CGRect = self.threadTableView.frame
        tableFrame = CGRectMake(0.0, 0.0, screenWidth!, screenHeight! - composeViewHeight)
        self.threadTableView.frame = tableFrame
        self.threadTableViewConstraint.constant = tableFrame.height
        
        
        self.threadTableView.layoutIfNeeded()
        self.threadTableView.layoutMarginsDidChange()
        
        
        var composeFrame : CGRect = self.composeView.frame
        composeFrame = CGRectMake(0.0, tableFrame.height, screenWidth!, composeViewHeight)
        self.composeView.frame = composeFrame
        self.composeViewHeightConstraint.constant = composeViewHeight
        self.composeViewBottomLayout.constant = 0
        
        self.composeView.layoutIfNeeded()
        self.composeView.layoutMarginsDidChange()
        
        self.composeTextView.maxHeight = 60.0
        self.composeTextView.heightConstraint = self.composeTVConstraint
        self.composeTextView.containerConstraint = self.composeViewHeightConstraint
        self.composeTextView.tableContentInset = self.threadTableView.contentInset
        
        var tap = UITapGestureRecognizer (target: self, action: Selector("tableTapped:"))
        self.threadTableView.addGestureRecognizer(tap)
        
        if let var tabBarTemp = self.tabBarController?.tabBar{
            if (tabBarTemp.hidden){
                self.tabBarHidden = true
            } else {
                self.tabBarHidden = false
            }
        }
        
    }
    
    func onStatusUpdate(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        println("json \(json)")
                        if let userId = json["userId"] as? Int{
                            if (String(userId) == recipient?.userId){
                                if let status = json["isOnline"] as? Bool{
                                    if (!status){
                                        recipient?.isOnline = "false"
                                        onlineView.backgroundColor = offlineColor
                                        onlineLabel.text = LocalizedStrings.offline
                                    } else {
                                        recipient?.isOnline = "true"
                                        onlineView.backgroundColor = onlineColor
                                        onlineLabel.text = LocalizedStrings.online
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func onSeenMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["recipientName"] as? String{
                            if (String(userId) == recipient?.fullName){
                                var r_temp = recipient?.userId ?? ""
                                self.messages[messages.count - 1].isSeen = "1"
                                self.threadTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func onReceiveNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let userId = json["senderUid"] as? Int{
                            if (String(userId) == recipient?.userId){
                                var r_temp = recipient?.userId ?? ""
                                self.getMessagesFromEndpoint("1", limit: "30", userId: r_temp)
                            }
                        }
                    }
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.clearProfileView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasChanged:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        self.placeCustomBackImage()
        self.placeRightNavigationControllerDetails()
        
//        SessionManager.setUnReadMessagesCount(SessionManager.getUnReadMessagesCount() - hasUnreadMessage.toInt()!)
        SessionManager.setUnReadMessagesCount(0)
        setMessageBadgeCount()
        
        self.composeTextView.becomeFirstResponder()
        
        /* set message as read */
        var r_temp = recipient?.userId ?? ""
        self.setConversationAsReadFromEndpoint(r_temp)
        self.sendButton.titleLabel?.text = LocalizedStrings.send
        
        /* GCM */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdate:",
            name: appDelegate.statusKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onSeenMessage:",
            name: appDelegate.seenMessageKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReceiveNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
    }
    
    
    
    func setMessageBadgeCount() {
        if self.tabBarController!.tabBar.items?.count == 3 && SessionManager.isSeller() {
            if SessionManager.getUnReadMessagesCount() != 0 {
                (self.tabBarController!.tabBar.items![1] as! UITabBarItem).badgeValue = String(SessionManager.getUnReadMessagesCount())
            } else {
                (self.tabBarController!.tabBar.items![1] as! UITabBarItem).badgeValue = nil
            }
        }
    }
    
    func tableTapped(tap : UITapGestureRecognizer){
        var location = tap.locationInView(self.threadTableView)
        self.composeTextView.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.seenMessageKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.messageKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: appDelegate.statusKey, object: nil)
        
        self.clearProfileView()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.findAndResignFirstResponder()
        
    }
    
    func placeRightNavigationControllerDetails(){
        var navBarHeight = self.navigationController?.navigationBar.frame.height
        var navBarWidth = UIScreen.mainScreen().bounds.size.width
        var profileImageDimension : CGFloat = 40.0
        var rightPadding : CGFloat = 10.0
        var rightPadding2 : CGFloat = 4.0
        var rightPadding3 : CGFloat = 4.0
        
        onlineLabel = UILabel()
        onlineLabel.font = UIFont(name: onlineLabel.font.fontName, size: 11.0)
        onlineLabel.textColor = UIColor.whiteColor()
        onlineLabel.sizeToFit()
        onlineLabel.text = LocalizedStrings.online
        
        var onlineLabelFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - 35 - rightPadding2, 6, 35, 15)
        
        onlineLabel.frame = onlineLabelFrame
        
        profileNameLabel = UILabel()
        profileNameLabel.text = recipient?.fullName
        profileNameLabel.font = UIFont(name: profileNameLabel.font.fontName, size: 15.0)
        profileNameLabel.textColor = UIColor.whiteColor()
        profileNameLabel.sizeToFit()
        
        var profileNameFrame = CGRectMake(navBarWidth-profileImageDimension - rightPadding - profileNameLabel.frame.width - rightPadding2, getMidpoint(navBarHeight!) - 2, profileNameLabel.frame.width, profileNameLabel.frame.height)
        
        profileNameLabel.frame = profileNameFrame
        
        profileImageView = UIImageView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding, 0,profileImageDimension, profileImageDimension))
        
        var imageStringRecipient = recipient?.profileImageUrl
        if imageStringRecipient != nil {
            var urlRecipient : NSURL = NSURL(string: imageStringRecipient!)!
            profileImageView!.sd_setImageWithURL(urlRecipient, placeholderImage: UIImage(named: "Male-50.png"))
        } else {
            profileImageView?.image = UIImage(named: "Male-50.png")
        }

        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        
        onlineView = RoundedView(frame: CGRectMake(navBarWidth-profileImageDimension - rightPadding - onlineLabel.frame.width - rightPadding2 - 10 - rightPadding3, 8, 10, 10))
        
        
        if (recipient?.isOnline == "1"){
            onlineLabel.text = LocalizedStrings.online
            onlineView.backgroundColor = onlineColor
        } else {
            onlineLabel.text = LocalizedStrings.offline
            onlineView.backgroundColor = offlineColor
        }
        
        onlineView.layer.cornerRadius = onlineView.frame.height/2
        onlineView.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.addSubview(profileImageView)
        self.navigationController?.navigationBar.addSubview(profileNameLabel)
        self.navigationController?.navigationBar.addSubview(onlineLabel)
        self.navigationController?.navigationBar.addSubview(onlineView)
        
    }
    
    func getMidpoint(temp : CGFloat) -> CGFloat{
        return temp/2
    }
    
    func placeCustomBackImage(){
        var backImage = UIImage(named: "left.png")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 12.0, height: 24.0), false, 0.0)
        backImage?.drawInRect(CGRectMake(0, 0, 12, 24))
        
        var tempImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var backItem = UIBarButtonItem(image: tempImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack"))
        
        self.navigationItem.setLeftBarButtonItem(backItem, animated: true)
    }
    
    @IBAction func onCamera(sender: UIButton) {
        self.clearProfileView()
    }
    
    func goBack(){
        self.clearProfileView()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clearProfileView(){
        if (profileImageView != nil){
            profileImageView.removeFromSuperview()
        }
        if (onlineView != nil){
            onlineView.removeFromSuperview()
        }
        if (profileNameLabel != nil){
            profileNameLabel.removeFromSuperview()
        }
        if (onlineLabel != nil){
            onlineLabel.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTableView(){
        threadTableView.rowHeight = UITableViewAutomaticDimension
        threadTableView.estimatedRowHeight = 160.0
    }
    
    func keyboardWasHidden (notification: NSNotification){
        if (keyboardIsShown){
            keyboardIsShown = false
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var keyFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var newFrame : CGRect = self.composeView.frame
            newFrame.origin.y += keyFrame.size.height
            
            var newTableFrame : CGRect = self.threadTableView.frame
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                //self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, self.tabBarHeight, 0)
                
                var tabBarH : CGFloat = 0.0
                if (!self.tabBarHidden){
                    tabBarH = self.tabBarHeight
                }
                
                self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, tabBarH, 0)
                
                self.composeView.frame = newFrame
                //self.composeViewBottomLayout.constant -= (keyFrame.size.height - self.tabBarHeight)
                self.composeViewBottomLayout.constant -= (keyFrame.size.height - tabBarH)
                
                self.goToBottomTableView()
                }, completion: nil)
            
        }
    }
    
    func keyboardWasChanged(notification: NSNotification) {
        if (keyboardIsShown){
            var info = notification.userInfo!
            var oldFrame : CGRect = (info [UIKeyboardFrameBeginUserInfoKey])!.CGRectValue()
            var updatedFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var updatedH = updatedFrame.height - oldFrame.height
            
            var newFrame : CGRect = self.composeView.frame
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.composeView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y - updatedH, newFrame.width, newFrame.height)
                self.composeViewBottomLayout.constant += (updatedH)
                self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, updatedFrame.size.height, 0)
                self.goToBottomTableView()
                
                
                }, completion: nil)
            
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if (!keyboardIsShown){
            keyboardIsShown = true
            var info = notification.userInfo!
            var keyBoardEndFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var keyFrame : CGRect = (info [UIKeyboardFrameEndUserInfoKey])!.CGRectValue()
            
            var newFrame : CGRect = self.composeView.frame
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.composeView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y - keyFrame.size.height, newFrame.width, newFrame.height)
                //self.composeViewBottomLayout.constant += (keyFrame.size.height - self.tabBarHeight)
                
                var tabBarH : CGFloat = 0.0
                if (!self.tabBarHidden){
                    tabBarH = self.tabBarHeight
                }
                
                self.composeViewBottomLayout.constant += (keyFrame.size.height - tabBarH)
                
                self.threadTableView.contentInset = UIEdgeInsetsMake(60, 0, keyFrame.size.height, 0)
                self.goToBottomTableView()
                
                
                }, completion: nil)
        }
    }
    
    @IBAction func onSend(senderButton: UIButton) {
        var lastMessage = composeTextView.text
        if (isBlank){
            lastMessage = ""
        }
        if (lastMessage == nil){
            lastMessage = " "
        }
        self.createMessage(lastMessage, isImage: "0")
    }
    
    func createMessage(lastMessage: String, isImage : String){
        var dateSeen : NSDate? = nil
        
        var recipientId = recipient?.userId ?? "0"
        var senderId = self.sender?.userId ?? "0"
        
        self.messages.append(W_Messages(message_id: 0, senderId: 0 , recipientId: recipientId.toInt()!, message: lastMessage, isImage: isImage, timeSent: NSDate(), isSeen: "0", timeSeen: dateSeen, isSent : "1"))
        self.threadTableView.reloadData()
        self.goToBottomTableView()
        self.sendMessageToEndpoint(lastMessage, recipientId: recipientId, isImage: isImage)
    }
    
    func sendMessageToEndpoint(lastMessage : String, recipientId : String, isImage : String){
        
        WebServiceManager.fireSendMessage(APIAtlas.ACTION_SEND_MESSAGE, lastMessage: lastMessage, recipientId: recipientId, isImage: isImage, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            if successful {
                self.messages[self.messages.count-1].isSent = "1"
            } else {
                self.messages[self.messages.count-1].isSent = "0"
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    if SessionManager.isLoggedIn() {
                        self.fireRefreshToken()
                    } else {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    }
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
        
        self.composeTextView.text = ""
        self.threadTableView.reloadData()
        
//        let manager = APIManager.sharedInstance
//        manager.requestSerializer = AFHTTPRequestSerializer()
//        
//        
//        let parameters: NSDictionary = [
//            "message"       : "\(lastMessage)",
//            "recipientId"  : "\(recipientId)",
//            "isImage"      : isImage,
//            "access_token"  : SessionManager.accessToken()
//            ]   as Dictionary<String, String>
//        
//        
//        /* uncomment + "a" to test retry sending */
//        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SEND_MESSAGE //+ "a"
//        
//        manager.POST(url, parameters: parameters, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            self.messages[self.messages.count-1].isSent = "1"
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//                
//                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                
//                if (Reachability.isConnectedToNetwork()) {
//                    if task.statusCode == 401 {
//                        if (SessionManager.isLoggedIn()){
//                            self.fireRefreshToken()
//                        }
//                    } else {
//                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
//                    }
//                    
//                    self.messages[self.messages.count-1].isSent = "0"
//                } else {
//                    self.showAlert(LocalizedStrings.connectionUnreachableTitle, message: LocalizedStrings.connectionUnreachableMessage)
//                }
//        })
//        self.composeTextView.text = ""
//        self.threadTableView.reloadData()
    }
    
    func getMessagesFromEndpoint(
        page : String,
        limit : String,
        userId: String){
            //SVProgressHUD.show()
            
            self.showHUD()
            
            WebServiceManager.fireGetMessage(APIAtlas.ACTION_GET_CONVERSATION_MESSAGES, page: page, limit: limit, userId: userId, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                
                if successful {
                    self.messages = W_Messages.parseMessages(responseObject as! NSDictionary)
                    self.threadTableView.reloadData()
                    self.goToBottomTableView()
                    self.hud?.hide(true)
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        if SessionManager.isLoggedIn() {
                            self.fireRefreshToken()
                        } else {
                            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        }
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    }
                    
                    self.messages = Array<W_Messages>()
                    self.threadTableView.reloadData()
                    
                    self.hud?.hide(true)
                }
            })
            
            self.goToBottomTableView()
            
//            let manager = APIManager.sharedInstance
//            manager.requestSerializer = AFHTTPRequestSerializer()
//            
//            let parameters: NSDictionary = [
//                "page"          : "\(page)",
//                "limit"         : "\(limit)",
//                "userId"        : userId, //get user id from somewhere
//                "access_token"  : SessionManager.accessToken()
//                ]   as Dictionary<String, AnyObject>
//            println(parameters)
//            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_MESSAGES
//            
//            manager.POST(url, parameters: parameters, success: {
//                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//                self.messages = W_Messages.parseMessages(responseObject as! NSDictionary)
//                self.threadTableView.reloadData()
//                self.goToBottomTableView()
//                self.hud?.hide(true)
//                //SVProgressHUD.dismiss()
//                }, failure: {
//                    (task: NSURLSessionDataTask!, error: NSError!) in
//                    
//                    if (Reachability.isConnectedToNetwork()) {
//                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                        if task.statusCode == 401 {
//                            if (SessionManager.isLoggedIn()){
//                                self.fireRefreshToken()
//                            }
//                        } else {
//                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
//                        }
//                    } else {
//                        self.showAlert(LocalizedStrings.connectionUnreachableTitle, message: LocalizedStrings.connectionUnreachableMessage)
//                    }
//                    
//                    self.messages = Array<W_Messages>()
//                    self.threadTableView.reloadData()
//                    
//                    self.hud?.hide(true)
//                    //SVProgressHUD.dismiss()
//            })
//            
//            self.goToBottomTableView()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func fireRefreshToken() {
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
//    func fireRefreshToken() {
//        let manager = APIManager.sharedInstance
//        //seller@easyshop.ph
//        //password
//        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
//        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                
//                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: LocalizedStrings.errorMessage, title: LocalizedStrings.errorTitle)
//        })
//        
//    }
    
    func setConversationAsReadFromEndpoint(userId : String){
        
        WebServiceManager.fireSetConversationAsRead(APIAtlas.ACTION_SET_AS_READ, userId: userId, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            if successful {
                
            } else {
                
            }
            
            })
        
//        let manager = APIManager.sharedInstance
//        manager.requestSerializer = AFHTTPRequestSerializer()
//        
//        let parameters: NSDictionary = [
//            "userId"        : "\(userId)", //get user id from somewhere
//            "access_token"  : SessionManager.accessToken()
//            ]   as Dictionary<String, String>
//        
//        let url = APIAtlas.baseUrl + APIAtlas.ACTION_SET_AS_READ
//        
//        manager.POST(url, parameters: parameters, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//        })
        
    }
    
}

extension MessageThreadVC : UITextViewDelegate{
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = LocalizedStrings.typeYourMessage
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            isBlank = true
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            isBlank = false
        }
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
}

extension MessageThreadVC : UITableViewDataSource, UITableViewDelegate{
    
    func resendButtonTapped(sender: UIButton, event : UIEvent!){
        var touches : NSSet = event.allTouches()!
        var touch : UITouch = touches.anyObject() as! UITouch
        
        var currentTouchPosition : CGPoint = touch.locationInView(self.threadTableView)
        var indexPath : NSIndexPath = self.threadTableView.indexPathForRowAtPoint(currentTouchPosition)!
        if (!indexPath.isEqual(nil)) {
            if (messages[indexPath.row].isImage == "0") {
                let cell = self.threadTableView.cellForRowAtIndexPath(indexPath) as! MessageThreadTVC
                self.sendMessageToEndpoint(cell.message_label.text!, recipientId: String(messages[indexPath.row].recipientId), isImage: "0")
            }
        }
    }
    
    func goToBottomTableView(){
        if(threadTableView.numberOfRowsInSection(0) > 0) {
            var lastIndexPath : NSIndexPath = getLastIndexPath(threadTableView)
            threadTableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
    func getLastIndexPath(param : UITableView) -> NSIndexPath{
        var lastSectionIndex : NSInteger = max(0, param.numberOfSections() - 1)
        var lastRowIndex : NSInteger = max(0, param.numberOfRowsInSection(lastSectionIndex) - 1)
        
        return NSIndexPath(forRow: lastRowIndex, inSection: lastSectionIndex)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row != 0) {
            if (messages[indexPath.row].senderId == messages[indexPath.row-1].senderId){
                prevIsSame = true
            } else {
                prevIsSame = false
            }
        }
        
        if (!prevIsSame){
            imagePlaced = false
        } else {
            imagePlaced = true
        }
        
        var index : Int = indexPath.row
        if (messages[index].isImage == "1"){
            if (recipient?.userId != String(messages[index].senderId)){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderImageIndentifier) as! MessageThreadImageTVC
                
                
                if(!imagePlaced){
                    cell.contact_image.layer.cornerRadius = cell.contact_image.bounds.width/2
                    cell.contact_image.layer.masksToBounds = true
                    cell.contact_image.image = senderImage!.image
                    imagePlaced = true
                }
                
                
                let url = NSURL(string: messages[index].message)
                cell.message_image.sd_setImageWithURL(url, placeholderImage: nil)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSent == "1") {
                    cell.timestamp_label.text = DateUtility.getTimeFromDate(messages[index].timeSent) as String
                    cell.resendButton.hidden = true
                    cell.timestamp_label.hidden = false
                    cell.timestamp_image.hidden = false
                } else {
                    cell.resendButton.hidden = false
                    cell.timestamp_label.hidden = true
                    cell.timestamp_image.hidden = true
                }
                cell.resendButton.addTarget(self, action: Selector("resendButtonTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                if (messages[index].isSeen == "1") {
                    cell.setSeen()
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverImageIndentifier) as! MessageThreadImageTVC
                
                
                if(!imagePlaced){
                    cell.contact_image.layer.cornerRadius = cell.contact_image.bounds.width/2
                    cell.contact_image.layer.masksToBounds = true
                    cell.contact_image.image = recipientImage!.image
                    imagePlaced = true
                }
                
                cell.timestamp_label.text = DateUtility.getTimeFromDate(messages[index].timeSent) as String
                
                let url = NSURL(string: messages[index].message)
                cell.message_image.sd_setImageWithURL(url, placeholderImage: nil)
                
                cell.message_image.superview?.layer.cornerRadius = 5.0
                cell.message_image.superview?.layer.shadowRadius = 1.0
                cell.message_image.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_image.superview?.layer.shadowOpacity = 0.4
                cell.message_image.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            }
        } else {
            if (recipient?.userId != String(messages[index].senderId)){
                let cell = tableView.dequeueReusableCellWithIdentifier(senderIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[index].message as String
                
                if(!imagePlaced){
                    cell.contact_image.layer.cornerRadius = cell.contact_image.bounds.width/2
                    cell.contact_image.layer.masksToBounds = true
                    cell.contact_image.image = senderImage!.image
                    imagePlaced = true
                }
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                if (messages[index].isSent == "1") {
                    cell.timestamp_label.text = DateUtility.getTimeFromDate(messages[index].timeSent) as String

                    cell.resendButton.hidden = true
                    cell.timestamp_label.hidden = false
                    cell.timestamp_image.hidden = false
                } else {
                    cell.resendButton.hidden = false
                    cell.timestamp_label.hidden = true
                    cell.timestamp_image.hidden = true
                    
                }
                cell.resendButton.addTarget(self, action: Selector("resendButtonTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                if (messages[index].isSeen == "0") {
                    cell.setSeenOff()
                } else {
                    cell.setSeenOn()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(receiverIdentifier) as! MessageThreadTVC
                
                cell.message_label.text = messages[index].message as String
                if(!imagePlaced){
                    cell.contact_image.layer.cornerRadius = cell.contact_image.bounds.width/2
                    cell.contact_image.layer.masksToBounds = true
                    cell.contact_image.image = recipientImage!.image
                    imagePlaced = true
                }
                
                cell.timestamp_label.text = DateUtility.getTimeFromDate(messages[index].timeSent) as String
                
                cell.message_label.superview?.layer.cornerRadius = 5.0
                
                cell.message_label.superview?.layer.shadowRadius = 1.0
                cell.message_label.superview?.layer.shadowColor = UIColor.blackColor().CGColor
                cell.message_label.superview?.layer.shadowOpacity = 0.4
                cell.message_label.superview?.layer.shadowOffset = CGSizeMake(1, 1)
                
                return cell
            }
            
        }
        
    }
    
}

extension MessageThreadVC : ImageVCDelegate{
    
    func sendMessage(url : String){
        self.createMessage(url, isImage: "1")
    }
}
