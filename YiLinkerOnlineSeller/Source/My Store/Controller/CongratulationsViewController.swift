//
//  CongratulationsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//CongratulationsViewController Delegate Methods
protocol CongratulationsViewControllerDelegate {
    func dismissView()
    func verifyViewController()
    func getStoreInfo()
}

class CongratulationsViewController: UIViewController {
    
    //Custom Views/Buttons
    @IBOutlet weak var continueButton: DynamicRoundedButton!
    @IBOutlet weak var requestNewButton: DynamicRoundedButton!
    @IBOutlet weak var successFailView: DynamicRoundedView!
    
    //Imageviews
    @IBOutlet weak var iconImageView: UIImageView!
    
    //Labels
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //Strings
    let congratulations: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_SUCCESS_TITLE_LOCALIZE_KEY")
    let message: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_SUCCESS_LOCALIZE_KEY")
    let continueTitle: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_SUCCESS_CONTINUE_LOCALIZE_KEY")
    let requestNewTitle: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_FAIL_REQUEST_LOCALIZE_KEY")
    let ooops: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_FAIL_TITLE_LOCALIZE_KEY")
    let incorrect: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_MESSAGE_FAIL_LOCALIZE_KEY")
    
    //Global variables declarations
    var isSuccessful: Bool = false
    
    //Initialized CongratulationsViewControllerDelegate
    var delegate: CongratulationsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSuccessful {
            self.successFailView.backgroundColor = Constants.Colors.appTheme
            //Set condition to check if fail or not
            self.iconImageView.image = UIImage(named: "checkBox.png")
            self.titleLabel.text = self.congratulations
            self.subTitleLabel.text = self.message
            self.continueButton.hidden = false
            self.requestNewButton.hidden = true
            self.continueButton.setTitle(self.continueTitle, forState: UIControlState.Normal)
        } else {
            self.successFailView.backgroundColor = Constants.Colors.grayLine
            //Set condition to check if fail or not
            self.iconImageView.image = UIImage(named: "oops.png")
            self.titleLabel.text = self.ooops
            self.subTitleLabel.text = self.incorrect
            self.continueButton.hidden = true
            self.requestNewButton.hidden = false
            self.requestNewButton.setTitle(self.requestNewTitle, forState: UIControlState.Normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action method of buttons
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissView()
        self.delegate?.getStoreInfo()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func continueAction(sender: AnyObject){
        self.delegate?.dismissView()
        self.delegate?.getStoreInfo()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func requestNewVerificationAction(sender: AnyObject){
        self.delegate?.verifyViewController()
        //self.delegate?.dismissView()
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
