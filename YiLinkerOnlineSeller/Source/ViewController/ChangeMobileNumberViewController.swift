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

class ChangeMobileNumberViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

   
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
   
    @IBOutlet weak var submitButton: DynamicRoundedButton!
    @IBOutlet weak var oldNumberTextField: UITextField!
    @IBOutlet weak var newNumberTextField: UITextField!
    
    @IBOutlet weak var changeMobileTitle: UILabel!
    @IBOutlet weak var oldNumberTitleLabel: UILabel!
    @IBOutlet weak var newNumberTitleLabel: UILabel!
    
    var delegate: ChangeMobileNumberViewControllerDelegate?
    
    let changeMobile: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_TITLE_LOCALIZE_KEY")
    let oldNumber: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OLD_PASSWORD_LOCALIZE_KEY")
    let newNumber: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_NEW_PASSWORD_LOCALIZE_KEY")
    let submit: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_SUBMIT_LOCALIZE_KEY")
    let enterNewNumber: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ENTER_NEW_NUMBER_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let invalidNumber: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_INVALID_NUMBER_LOCALIZE_KEY")
    let sameNumber: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_SAME_NUMBER_LOCALIZE_KEY")
     let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    var mobile: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeMobileTitle.text = changeMobile
        self.oldNumberTitleLabel.text = oldNumber
        self.newNumberTitleLabel.text = newNumber
        self.submitButton.setTitle(submit, forState: UIControlState.Normal)
        self.oldNumberTextField.text = self.mobile
        self.newNumberTextField.placeholder = enterNewNumber
        self.oldNumberTextField.enabled = false
        self.newNumberTextField.delegate = self
        var tap = UITapGestureRecognizer(target: self, action: "dissmissKeyboard")
        self.view.addGestureRecognizer(tap)
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
            self.showAlert(title: self.error, message: self.invalidNumber)
        } else {
            if newNumberTextField.text == oldNumberTextField.text {
                self.showAlert(title: self.error, message: self.sameNumber)
            } else {
                self.delegate?.setMobileNumber(newNumberTextField.text, oldNumber: oldNumberTextField.text)
                //self.delegate?.dismissView()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    @IBAction func textFieldDidBegin(sender: AnyObject) {
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
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return count(prospectiveText) <= 11
        //return true;
    }
    
    func dissmissKeyboard() {
        self.newNumberTextField.resignFirstResponder()
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
