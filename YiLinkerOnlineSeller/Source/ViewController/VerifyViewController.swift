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

        let aSelector : Selector = "updateTime"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let aSelector : Selector = "updateTime"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    func subtractTime() {
        seconds--
        var secondsTemp: Int = seconds % 60
        var minutes: Int = Int(seconds / 60)
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
