//
//  PayoutViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StringHelper.localizedStringWithKey("WITHDRAWAL_BALANCE_ITEMS_LOCALIZE_KEY")
        self.backButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // MARK: - Add Back Button in navigation bar
    func backButton() {
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - Navigation bar back button action
    func back() {
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
