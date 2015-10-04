//
//  VerifyNumberViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/31/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol VerifyViewControllerDelegate {
    func congratulationsViewController(isSuccessful: Bool)
    func dismissView()
}

class VerifyNumberViewController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var requestNewVerificationButton: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var successFailView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var verifyTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    var viewControllers = [UIViewController]()
    var congratulationsViewController: CongratulationsViewController?
    var verifyViewController: VerifyViewController?
    var selectedChildViewController: UIViewController?
    
    var contentViewFrame: CGRect?
    var selectedIndex: Int = 0

    var delegate: VerifyViewControllerDelegate?
    
    var hud: MBProgressHUD?
    
    var isSuccessful = false
    
    var mobileNumber: String = ""
    
    var seconds: Int = 300
    var timer = NSTimer()
    
    let verifyTitle: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_TITLE_LOCALIZE_KEY")
    let message: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_MESSAGE_LOCALIZE_KEY")
    let timeLeft: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_TIME_LOCALIZE_KEY")
    let verify: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_VERIFY_LOCALIZE_KEY")
    let requestNew: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_REQUEST_NEW_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let invalid: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_INVALID_LOCALIZE_KEY")
    let empty: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_EMPTY_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let expired: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_EXPIRED_LOCALIZE_KEY")
    let information: String = StringHelper.localizedStringWithKey("STORE_INFO_INFORMATION_TITLE_LOCALIZE_KEY")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContainer.layer.cornerRadius = 5.0
        self.viewContainer.clipsToBounds = true

        self.verifyButton.layer.cornerRadius = 4.0
        self.verifyButton.clipsToBounds = true
        
        self.verifyTitleLabel.text = self.verifyTitle
        self.messageLabel.text = self.message
        self.timeLeftLabel.text = self.timeLeft
        self.verifyButton.setTitle(self.verify, forState: UIControlState.Normal)
        self.requestNewVerificationButton.setTitle(self.requestNew, forState: UIControlState.Normal)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button functions
    @IBAction func cancelAction(sender: AnyObject!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dismissView()
    }
    
    @IBAction func requestNewVerificationCode(sender: AnyObject){
        //Set action to send new verification code
        self.fireResendVerificationCode()
        println("Resending verification code")
    }
    
    @IBAction func verifyContinueRequest(sender: AnyObject){
        println("fire verify")
        if !self.verificationCodeTextField.text.isEmpty {
            println(self.verificationCodeTextField.text.toInt())
            if count(self.verificationCodeTextField.text) < 6 || count(self.verificationCodeTextField.text) > 6 {
                self.showAlert(self.error, message: self.invalid)
            } else {
                self.fireVerify(self.verificationCodeTextField.text!)
            }
        } else {
            self.showAlert(self.error, message: self.empty)
        }
    }
    
    //MARK: Resend verification code
    func fireResendVerificationCode() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.sellerResendVerification+"\(SessionManager.accessToken())&mobileNumber=\(self.mobileNumber)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if responseObject["isSuccessful"] as! Bool {
                    self.showAlert(self.information, message: responseObject["message"] as! String )
                    self.seconds = 300
                    self.invalidateTimer()
                } else {
                    self.showAlert(self.error, message: responseObject["message"] as! String)
                }
                println(responseObject.description)
                //self.setSelectedViewControllerWithIndex(0)
                self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    self.delegate?.congratulationsViewController(false)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(VerifyType.Resend)
                } else {
                    self.delegate?.congratulationsViewController(false)
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
                //self.showAlert(self.error, message: self.somethingWentWrong)
        })
    }
    
    //MARK: Send verification code
    func fireVerify(verificationCode: String){
        if self.verifyViewController?.timerLabel.text != "00:00" {
            self.showHUD()
            let manager = APIManager.sharedInstance
            let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "code" : NSNumber(integer: verificationCode.toInt()!)];
            
            manager.POST(APIAtlas.sellerMobileNumberVerification, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.hud?.hide(true)
                if responseObject["isSuccessful"] as! Bool {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    //self.delegate?.dismissView()
                    self.delegate?.congratulationsViewController(true)
                } else {
                    println("\(responseObject)")
                    self.showAlert(self.error, message: responseObject["message"] as! String)
                }
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.hud?.hide(true)
                //self.delegate?.dismissView()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    self.delegate?.congratulationsViewController(false)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(VerifyType.Verify)
                } else {
                    self.delegate?.congratulationsViewController(false)
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
                //println(error.userInfo)
                //self.delegate?.congratulationsViewController(false)
                //self.showAlert(self.error, message: self.somethingWentWrong)
                //println(error)
            })
        } else {
             self.showAlert(self.error, message: self.expired)
        }
       
    }
    
    func requestRefreshToken(type: VerifyType) {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == VerifyType.Verify {
                self.fireVerify(self.verificationCodeTextField.text)
            } else if type == VerifyType.Resend {
                self.fireResendVerificationCode()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                 self.showAlert(self.error, message: self.somethingWentWrong)
        })
    }
    
    //MARK: Show MBProgressHUD bar
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
    
    //MARK: Starts the timer
    func subtractTime() {
        seconds--
        var secondsTemp: Int = seconds % 60
        var minutes: Int = Int(seconds / 60)
        if secondsTemp < 10 {
            timerLabel.text = "0\(minutes):0\(secondsTemp)"
        } else {
            timerLabel.text = "0\(minutes):\(secondsTemp)"
        }
        
        if(seconds == 0)  {
            timer.invalidate()
            timerLabel.text = "00:00"
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: Invalidate timer - sets to 05:00
    func invalidateTimer() {
        timer.invalidate()
        seconds = 300
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        verificationCodeTextField.text = ""
    }
    
    //MARK: Show alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: self.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //MARK: Textfield
    @IBAction func textFieldDidBeginEditing(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = 40
        } else if IphoneType.isIphone5() {
            topConstraint.constant = 60
        } else {
            topConstraint.constant = 100
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
