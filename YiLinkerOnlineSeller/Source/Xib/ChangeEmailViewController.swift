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
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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
