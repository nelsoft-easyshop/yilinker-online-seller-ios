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
        self.delegate?.dismissDimView()
        self.delegate?.updateCollectionView()
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
