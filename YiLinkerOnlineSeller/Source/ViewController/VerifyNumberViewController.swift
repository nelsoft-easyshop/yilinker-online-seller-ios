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

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var requestNewVerificationButton: UIButton!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var successFailView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContainer.layer.cornerRadius = 5.0
        self.viewContainer.clipsToBounds = true

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
            if self.verificationCodeTextField.text.toInt() < 6 || self.verificationCodeTextField.text.toInt() > 6 {
                self.showAlert("Error", message: "You have entered an invalid verification code.")
            } else {
                self.fireVerify(self.verificationCodeTextField.text!)
            }
        } else {
            self.showAlert("Error", message: "Please enter the 6 digit verification code.")
        }
    }
    
    //MARK: Resend verification code
    func fireResendVerificationCode() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.sellerResendVerification+"\(SessionManager.accessToken())&mobileNumber=\(self.mobileNumber)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if responseObject["isSuccessful"] as! Bool {
                    self.seconds = 300
                    self.invalidateTimer()
                } else {
                    self.showAlert("Error", message: "Something went wrong.")
                }
                println(responseObject.description)
                //self.setSelectedViewControllerWithIndex(0)
                self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.showAlert("Error", message: "Something went wrong.")
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
                if responseObject["isSuccessful"] as! Bool {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.hud?.hide(true)
                    //self.delegate?.dismissView()
                    self.delegate?.congratulationsViewController(true)
                } else {
                    self.showAlert("Error", message: "Something went wrong.")
                }
                        
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.hud?.hide(true)
                //self.delegate?.dismissView()
                self.delegate?.congratulationsViewController(false)
                self.showAlert("Error", message: "Something went wrong.")
                println(error)
            })
        } else {
             self.showAlert("Error", message: "Your verification code has expired.")
        }
       
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
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
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
