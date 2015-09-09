//
//  VerifyNumberViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/31/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol VerifyViewControllerDelegate {
    func dismissView()
}

class VerifyNumberViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var requestNewVerificationButton: UIButton!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var successFailView: UIView!
    
    var viewControllers = [UIViewController]()
    var congratulationsViewController: CongratulationsViewController?
    var verifyViewController: VerifyViewController?
    var selectedChildViewController: UIViewController?
    
    var contentViewFrame: CGRect?
    var selectedIndex: Int = 0

    var delegate: VerifyViewControllerDelegate?
    
    var hud: MBProgressHUD?
    
    var isSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContainer.layer.cornerRadius = 5.0
        self.viewContainer.clipsToBounds = true
    
        initViewController()
        self.setSelectedViewControllerWithIndex(0)
    }
    
    func initViewController() {
        
        verifyViewController = VerifyViewController(nibName: "VerifyViewController", bundle: nil)
        congratulationsViewController = CongratulationsViewController(nibName: "CongratulationsViewController", bundle: nil)
        
        self.viewControllers.append(verifyViewController!)
        self.viewControllers.append(congratulationsViewController!)
        
    }
    
    func setSelectedViewControllerWithIndex(index: Int) {
        if index == 0 {
            let viewController: UIViewController = viewControllers[index]
            self.verifyTitleLabel.hidden  = false
            self.verifyButton.setTitle("Verify", forState: UIControlState.Normal)
            self.requestNewVerificationButton.hidden = false
            setSelectedViewController(viewController)
        } else if index == 1 {
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
            self.verifyTitleLabel.hidden  = true
            if isSuccessful {
                self.congratulationsViewController?.successFailView.backgroundColor = Constants.Colors.appTheme
                //Set condition to check if fail or not
                self.congratulationsViewController?.iconImageView.image = UIImage(named: "checkBox.png")
                self.verifyButton.setTitle("Continue", forState: UIControlState.Normal)
                self.verifyButton.frame = CGRectMake(131, 203, 96, 26)
                self.congratulationsViewController?.titleLabel.text  = "Congratulatutions!"
                self.congratulationsViewController?.subTitleLabel.text  = "You have successfully verified your account."
            } else {
                self.congratulationsViewController?.successFailView.backgroundColor = Constants.Colors.grayLine
                //Set condition to check if fail or not
                self.congratulationsViewController?.iconImageView.image = UIImage(named: "oops.png")
                self.verifyButton.setTitle("REQUEST NEW VERIFICATION CODE", forState: UIControlState.Normal)
                self.verifyButton.frame = CGRectMake(53, 203, 252, 26)
                self.congratulationsViewController?.titleLabel.text  = "Ooops!"
                self.congratulationsViewController?.subTitleLabel.text  = "You have either entered an incorrect code or \nit has already expired."
            }
           
            self.requestNewVerificationButton.hidden = true
        }
    }
    
    func setSelectedViewController(viewController: UIViewController) {
        if !(selectedChildViewController == viewController) {
            if self.isViewLoaded() {
                selectedChildViewController?.willMoveToParentViewController(self)
                selectedChildViewController?.view.removeFromSuperview()
                selectedChildViewController?.removeFromParentViewController()
            }
        }
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = self.contentViewFrame!
        successFailView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedChildViewController = viewController
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewFrame = successFailView.bounds
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dismissView()
      
    }
    
    @IBAction func requestNewVerificationCode(sender: AnyObject){
        //Set action to send new verification code
    }
    
    @IBAction func verifyContinueRequest(sender: AnyObject){
        //Set action to send verification/continue/request new code
        if self.verifyButton.titleLabel?.text == "Verify" {
            println("fire verify")
            self.fireVerify(self.verifyViewController!.verificationCodeTextField.text!)
        } else if self.verifyButton.titleLabel?.text == "Continue" {
            println("Continue")
            self.delegate?.dismissView()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            println("Request new ferification code")
            //self.setSelectedViewControllerWithIndex(1)
            //self.isSuccessful = true
        }
        
    }
    
    func fireVerify(verificationCode: String){
        
        if self.verifyViewController?.timerLabel.text != "00:00" {
            self.showHUD()
            let manager = APIManager.sharedInstance
            let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "code" : NSNumber(integer: verificationCode.toInt()!)];
            
            manager.POST(APIAtlas.sellerMobileNumberVerification, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                
                if responseObject["isSuccessful"] as! Bool {
                    self.isSuccessful = true
                } else {
                    self.isSuccessful = false
                }
                self.setSelectedViewControllerWithIndex(1)
                //            self.delegate?.dismissView()
                //            self.dismissViewControllerAnimated(true, completion: nil)
                println(responseObject.description)
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    println(error)
            })
        } else {
            println("Verification code has expired.")
             self.setSelectedViewControllerWithIndex(1)
            self.isSuccessful = false
        }
       
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
