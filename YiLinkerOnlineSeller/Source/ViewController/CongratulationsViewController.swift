//
//  CongratulationsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol CongratulationsViewControllerDelegate {
    func dismissView()
    func verifyViewController()
}

class CongratulationsViewController: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var requestNewButton: UIButton!
    
    @IBOutlet weak var successFailView: DynamicRoundedView!
    
    var delegate: CongratulationsViewControllerDelegate?
    
    var isSuccessful: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSuccessful {
            self.successFailView.backgroundColor = Constants.Colors.appTheme
            //Set condition to check if fail or not
            self.iconImageView.image = UIImage(named: "checkBox.png")
            self.continueButton.hidden = false
            self.requestNewButton.hidden = true
        } else {
            self.successFailView.backgroundColor = Constants.Colors.grayLine
            //Set condition to check if fail or not
            self.iconImageView.image = UIImage(named: "oops.png")
            self.titleLabel.text = "Ooops!"
            self.subTitleLabel.text = "You have either entered an incorrect code or it has already expired."
            self.continueButton.hidden = true
            self.requestNewButton.hidden = false
        }
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
    
    @IBAction func continueAction(sender: AnyObject){
        self.delegate?.dismissView()
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
