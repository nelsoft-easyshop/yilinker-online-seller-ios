//
//  VerifyViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    var seconds: Int = 300
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK: Start countdown timer
    func subtractTime() {
        seconds--
        let secondsTemp: Int = seconds % 60
        let minutes: Int = Int(seconds / 60)
        if secondsTemp < 10 {
            timeLabel.text = "0\(minutes):0\(secondsTemp)"
        } else {
            timeLabel.text = "0\(minutes):\(secondsTemp)"
        }
        
        if(seconds == 0)  {
            timer.invalidate()
            timeLabel.text = "00:00"
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: Invalidate timer - Reset to 05:00
    func invalidateTimer() {
        timer.invalidate()
        seconds = 300
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        verificationCodeTextField.text = ""
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
