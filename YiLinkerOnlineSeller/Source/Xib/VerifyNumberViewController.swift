//
//  VerifyNumberViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/31/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class VerifyNumberViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var verificationCodeTextFiels: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var successFailView: UIView!
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContainer.layer.cornerRadius = 5.0
        self.viewContainer.clipsToBounds = true
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }

    func updateTime() {
        
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        self.timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject!) {
         self.dismissViewControllerAnimated(true, completion: nil)
       // self.pressedDimViewFromProductPage(self)
      
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
