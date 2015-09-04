//
//  CreateNewAddressViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol CreateNewAddressViewControllerDelegate {
    func updateCollectionView()
    func dismissDimView()
}

class CreateNewAddressViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var addressTitleTextField: UITextField!
    
    @IBOutlet weak var addressLine1TextField: UITextField!
    
    @IBOutlet weak var addressLine2TextField: UITextField!
    
    @IBOutlet weak var addressInfoTextField: UITextField!
    
    var hud: MBProgressHUD?
    
    var delegate: CreateNewAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAddress(sender: AnyObject){
        
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        self.delegate?.dismissDimView()
        
        manager.POST(APIAtlas.sellerAddBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println("\(parameters)")
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.hud?.hide(true)
            self.delegate?.updateCollectionView()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
        })

        
        self.delegate?.dismissDimView()
        self.delegate?.updateCollectionView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
