//
//  ChangeEmailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ChangeEmailViewControllerDelegate {
    func dismissView()
}

class ChangeEmailViewController: UIViewController {
    
    @IBOutlet weak var submitEmailAddressButton: DynamicRoundedButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var oldEmailAddressTextField: UITextField!
    
    @IBOutlet weak var newEmailAddressTextField: UITextField!
    
    @IBOutlet weak var confirmEmailAddressTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var oldEmailLabel: UILabel!
   
    @IBOutlet weak var newEmailLabel: UILabel!
    
    @IBOutlet weak var confirmEmailLabel: UILabel!
    
    var type: String = ""
    
    var hud : MBProgressHUD?
    
    var delegate: ChangeEmailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sumbitAction(sender: AnyObject) {
        self.delegate?.dismissView()
        if type == "email" {
            println("Submit email")
        } else {
            println("Submit password")
            self.showHUD()
            let manager = APIManager.sharedInstance
            let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldPassword" : self.oldEmailAddressTextField.text, "newPassword" : self.newEmailAddressTextField.text, "newPasswordConfirm" : self.confirmEmailAddressTextField.text];
            self.showHUD()
            manager.POST(APIAtlas.sellerChangePassword, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println("SUCCESS!")
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    println(error)
            })
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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
