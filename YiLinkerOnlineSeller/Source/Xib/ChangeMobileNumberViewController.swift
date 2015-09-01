//
//  ChangeMobileNumberViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ChangeMobileNumberViewControllerDelegate {
    
}
class ChangeMobileNumberViewController: UIViewController {

   
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var oldNumberTextField: UITextField!
    
    @IBOutlet weak var newNumberTextField: UITextField!
    
    var delegate: ChangeMobileNumberViewControllerDelegate?
    var storeInfo: StoreInfoViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submit(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.storeInfo?.storeInfoHeader.mobilePhoneTextField.text = self.newNumberTextField.text
        self.storeInfo?.storeInfoTableView.reloadData()
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
