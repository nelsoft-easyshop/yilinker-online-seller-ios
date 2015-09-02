//
//  CreateNewBankAccountViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit
protocol CreateNewBankAccountViewControllerDelegate{
   func updateCollectionView()
}
class CreateNewBankAccountViewController: UIViewController {

    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var accountTitleTextField: UITextField!
    
    @IBOutlet weak var accountNameTextField: UITextField!
    
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    @IBOutlet weak var bankNameTextField: UITextField!
    
    var storeInfoModel: StoreInfoModel!
    
    var delegate: CreateNewBankAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createBankAcount(sender: AnyObject) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        var accountNumber: Int? = self.accountNumberTextField.text.toInt()
        var bankId: Int? = "1".toInt()
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "accountTitle" : self.accountTitleTextField.text, "accountNumber" : NSNumber(integer: accountNumber!), "accountName" : self.accountNameTextField.text, "bankId" : 1]
        println(NSNumber(integer: accountNumber!))
        manager.POST(APIAtlas.sellerAddBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println("\(parameters)")
            self.dismissViewControllerAnimated(true, completion: nil)
            SVProgressHUD.dismiss()
            self.delegate?.updateCollectionView()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                println(error)
        })
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
