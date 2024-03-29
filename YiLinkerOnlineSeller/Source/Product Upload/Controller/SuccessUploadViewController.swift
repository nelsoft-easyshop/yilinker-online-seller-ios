//
//  SuccessUploadViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SuccessUploadViewControllerDelegate {
    func successUploadViewController(didTapDashBoard viewController: SuccessUploadViewController)
    func successUploadViewController(didTapUploadAgain viewController: SuccessUploadViewController)
}

class SuccessUploadViewController: UIViewController {

    var delegate: SuccessUploadViewControllerDelegate?
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var uploadAgainButton: UIButton!
    @IBOutlet weak var backToDashboardButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.successLabel.text = ProductUploadStrings.successfullyUploaded
        self.uploadAgainButton.setTitle(ProductUploadStrings.uploadAgain, forState: UIControlState.Normal)
        self.backToDashboardButton.setTitle(ProductUploadStrings.backToDashboard, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToDashBoard(sender: AnyObject) {
        self.delegate?.successUploadViewController(didTapDashBoard: self)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToDashboard()
    }

    @IBAction func uploadAgain(sender: AnyObject) {
        let productTC: ProductUploadTC = ProductUploadTC(nibName: "ProductUploadTC", bundle: nil)
        productTC.productModel = ProductModel()
        productTC.productImagesName = []
        productTC.productImagesCount = 0;
        //self.navigationController!.pushViewController(productTC, animated: true)
        self.delegate?.successUploadViewController(didTapUploadAgain: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
