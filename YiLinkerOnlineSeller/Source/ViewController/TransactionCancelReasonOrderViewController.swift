//
//  TransactionCancelReasonOrderViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/10/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionCancelReasonOrderViewControllerDelegate {
    func closeTransactionCancelReasonOrderViewController()
    func submitTransactionCancelReason()
}

class TransactionCancelReasonOrderViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: TransactionCancelReasonOrderViewControllerDelegate?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var remarksTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var titles: [String] = []
    
    var cancellationModels: [TransactionCancellationModel] = []
    
    var hud: MBProgressHUD?
    
    var selectedRow: Int = 0
    
    var invoiceNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        addPicker()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fireGetTransactionDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        remarksTextView.delegate = self
        
        mainView.layer.cornerRadius = 5
        remarksTextView.layer.cornerRadius = 5
        submitButton.layer.cornerRadius = 5
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func tapMainAction() {
        reasonTextField.resignFirstResponder()
        remarksTextView.resignFirstResponder()
        
        topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = screenHeight! / 20
        } else if IphoneType.isIphone5() {
            topConstraint.constant = screenHeight! / 10
        }
    }
    
    // MARK : UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        editBegin(textView)
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeTransactionCancelReasonOrderViewController()
        } else if sender as! UIButton == submitButton {
            firePostCancellation()
        }
    }
    
    // MARK : UIPickerViewDelegate
    func addPicker() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        self.reasonTextField.inputView = pickerView
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return cancellationModels.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.cancellationModels[row].cancellationReason
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reasonTextField.text = self.cancellationModels[row].cancellationReason
        selectedRow = row
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = self.cancellationModels[row].cancellationReason
        pickerLabel.numberOfLines = 0
        pickerLabel.font = UIFont(name: "Panton-Regular", size: 12)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func fireGetTransactionDetails(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.GET(APIAtlas.transactionCancellation, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
           println(responseObject)
            var response: NSDictionary = responseObject as! NSDictionary
            if response["isSuccessful"] as! Bool {
                for subValue in response["data"] as! NSArray {
                    self.cancellationModels.append(TransactionCancellationModel.parseDataWithDictionary(subValue as! NSDictionary))
                }
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: response["message"] as! String, title: "Error")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                        self.dismissViewControllerAnimated(true, completion: nil)

                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Check your internet connection!", title: "Error")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
                println(error)
        })
    }
    
    func firePostCancellation(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(),
            "transactionId": invoiceNumber,
            "reasonId": cancellationModels[selectedRow].cancellationId,
            "remark": remarksTextView.text];
        
        manager.POST(APIAtlas.postTransactionCancellation, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            var response: NSDictionary = responseObject as! NSDictionary
            if response["isSuccessful"] as! Bool {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.submitTransactionCancelReason()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: response["message"] as! String, title: "Error")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Check your internet connection!", title: "Error")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
                println(error)
        })
    }
    
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireGetTransactionDetails()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
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

}
