//
//  CreateNewAddressViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//CreateNewAddressViewController Delegate Methods
protocol CreateNewAddressViewControllerDelegate {
    func updateCollectionView()
    func dismissDimView()
}

class CreateNewAddressViewController: UIViewController {

    //Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    //Textfields
    @IBOutlet weak var addressInfoTextField: UITextField!
    @IBOutlet weak var addressLine1TextField: UITextField!
    @IBOutlet weak var addressLine2TextField: UITextField!
    @IBOutlet weak var addressTitleTextField: UITextField!
    
    //Global variable declarations
    var hud: MBProgressHUD?
    
    //Initialized CreateNewAddressViewControllerDelegate
    var delegate: CreateNewAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button actions
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAddress(sender: AnyObject){
        
        self.createNewAddress()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Private Methods
    // Show hud
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
    
    //MARK: -
    //MARK: - REST API request
    //MARK: POST METHOD - Create new address
    /*
    *
    * (Parameters) - access_token
    *
    * Function to create new address
    *
    */
    func createNewAddress() {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        self.delegate?.dismissDimView()
        
        manager.POST(APIAtlas.sellerAddBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.delegate?.updateCollectionView()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
        })
        
        self.delegate?.dismissDimView()
        self.delegate?.updateCollectionView()
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
