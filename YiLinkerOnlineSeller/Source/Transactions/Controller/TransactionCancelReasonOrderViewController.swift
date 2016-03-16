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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var titles: [String] = []
    
    var cancellationModels: [TransactionCancellationModel] = []
    
    var hud: MBProgressHUD?
    
    var selectedRow: Int = 0
    
    var invoiceNumber: String = ""
    var orderProductId: String = ""
    
    var errorLocalizedString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        intializeLocalizeStrings()
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
        
        reasonTextField.addToolBarWithTarget(self, next: "next", previous: nil, done: "done")
        remarksTextView.addToolBarWithDoneTarget(self, done: "done")
        
    }
    
    func done() {
        tapMainAction()
    }
    
    func next() {
        remarksTextView.becomeFirstResponder()

    }
    
    func intializeLocalizeStrings() {
        titleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_TITLE_LOCALIZE_KEY")
        reasonLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_TYPE_LOCALIZE_KEY")
        reasonTextField.placeholder = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_SELECT_LOCALIZE_KEY")
        remarksLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_REMARKS_LOCALIZE_KEY")
        submitButton.setTitle(StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_SUBMIT_LOCALIZE_KEY"), forState: UIControlState.Normal)
        
        errorLocalizedString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        
        reasonLabel.required()
        remarksLabel.required()
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
        
        if sender as? UITextField == reasonTextField && reasonTextField.text.isEmpty {
            reasonTextField.text = cancellationModels[0].cancellationReason
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
            var errorString: String = ""
            if !reasonTextField.isNotEmpty() {
                errorString = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_REQURED_LOCALIZE_KEY")
            } else if remarksTextView.text == "" {
                errorString = StringHelper.localizedStringWithKey("TRANSACTION_MODAL_REASON_REMARKS_LOCALIZE_KEY")
            }
            
            if errorString.isNotEmpty() {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorString)
            } else {
                firePostCancellation()
            }
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
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: response["message"] as! String, title: self.errorLocalizedString)
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
                        UIAlertController.displaySomethingWentWrongError(self)

                    }
                } else {
                    UIAlertController.displayNoInternetConnectionError(self)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
                println(error)
        })
    }
    
    func firePostCancellation(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        var parameters: NSDictionary?
        
        if orderProductId == "" {
            parameters = ["access_token" : SessionManager.accessToken(),
                "transactionId": invoiceNumber,
                "reasonId": cancellationModels[selectedRow].cancellationId,
                "remark": remarksTextView.text];
        } else {
            parameters = ["access_token" : SessionManager.accessToken(),
                "transactionId": invoiceNumber,
                "orderProductId": orderProductId,
                "reasonId": cancellationModels[selectedRow].cancellationId,
                "remark": remarksTextView.text];
        }
        
        manager.POST(APIAtlas.postTransactionCancellation, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            var response: NSDictionary = responseObject as! NSDictionary
            if response["isSuccessful"] as! Bool {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.submitTransactionCancelReason()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: response["message"] as! String, title: self.errorLocalizedString)
                //self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                } else {
                    UIAlertController.displayNoInternetConnectionError(self)
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
