//
//  ChangeMobileNumberViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ChangeMobileNumberViewControllerDelegate {
    func setMobileNumber(newMobile: String, oldNumber: String)
    func dismissView()
}

class ChangeMobileNumberViewController: UIViewController {

   
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
   
    @IBOutlet weak var submitButton: DynamicRoundedButton!
    @IBOutlet weak var oldNumberTextField: UITextField!
    @IBOutlet weak var newNumberTextField: UITextField!
    
    var delegate: ChangeMobileNumberViewControllerDelegate?
    
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
    
    @IBAction func submit(sender: AnyObject){
        var newNumber: String = newNumberTextField.text
        var oldNumber:String = oldNumberTextField.text
        println(count("\(newNumber)"))
        if count("\(newNumber)") < 11 || count("\(oldNumber)") < 11 {
            self.showAlert(title: "Error", message: "Mobile number is invalid/empty. Please follow the format 09XXXXXXXXX.")
        } else {
            if newNumberTextField.text == oldNumberTextField.text {
                self.showAlert(title: "Error", message: "Your new mobile number and old number is the same.")
            } else {
                self.delegate?.setMobileNumber(newNumberTextField.text, oldNumber: oldNumberTextField.text)
                //self.delegate?.dismissView()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    @IBAction func textFieldDidBeginEditing(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = 40
        } else if IphoneType.isIphone5() {
            topConstraint.constant = 60
        } else {
             topConstraint.constant = 100
        }
       
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
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
