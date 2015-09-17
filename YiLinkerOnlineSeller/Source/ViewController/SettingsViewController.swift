//
//  SettingsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsItemTableViewCellDelegate, SettingDeactivateTableViewCellDelegate {
    
    let settingsHeaderIdentifier: String = "SettingsHeaderTableViewCell"
    let settingsItemIdentifier: String = "SettingsItemTableViewCell"
    let settingsDeactivateIdentifier: String = "SettingDeactivateTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerNibs() {
        let nibHeader = UINib(nibName: settingsHeaderIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: settingsHeaderIdentifier)
        
        let nibItem = UINib(nibName: settingsItemIdentifier, bundle: nil)
        tableView.registerNib(nibItem, forCellReuseIdentifier: settingsItemIdentifier)
        
        let nibDeactivate = UINib(nibName: settingsDeactivateIdentifier, bundle: nil)
        tableView.registerNib(nibDeactivate, forCellReuseIdentifier: settingsDeactivateIdentifier)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsItemIdentifier, forIndexPath: indexPath) as! SettingsItemTableViewCell
            cell.delegate = self
            
            if indexPath.row == 0 {
                cell.setTitleText("Email")
                cell.setSettingSwitchStatus(false)
            } else if indexPath.row == 1 {
                cell.setTitleText("SMS")
                cell.setSettingSwitchStatus(true)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsDeactivateIdentifier, forIndexPath: indexPath) as! SettingDeactivateTableViewCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        } else {
            return 35
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(settingsHeaderIdentifier) as! SettingsHeaderTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }*/
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - SettingsItemTableViewCellDelegate : Switch Value CHanged

    func settingSwitchChanged(sender: AnyObject, isOn: Bool) {
        print(isOn)
    }
    
    // MARK: - SettingDeactivateTableViewCellDelegate : Deactivate My Account is Tapped
    func deactivateTapped(sender: AnyObject) {
        print("Deactivate account tapped!")
    }

}
