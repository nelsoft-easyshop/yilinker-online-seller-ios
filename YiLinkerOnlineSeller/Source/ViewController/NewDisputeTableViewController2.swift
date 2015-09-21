//
//  NewDisputeTableViewController2.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class NewDisputeTableViewController2: UITableViewController {
    
    let cellTextFieldIdentifier: String = "DisputeTextFieldTableViewCell"
    let cellTextFieldNibName: String = "DisputeTextFieldTableViewCell"
    
    let textFieldRowHeight: CGFloat = 72
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fireRegisterCell()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    func fireRegisterCell() {
        let textFieldCellNib: UINib = UINib(nibName: self.cellTextFieldNibName, bundle: nil)
        self.tableView.registerNib(textFieldCellNib, forCellReuseIdentifier: self.cellTextFieldIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 3
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: DisputeTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellTextFieldIdentifier) as! DisputeTextFieldTableViewCell
            if indexPath.row == 0 {
                cell.titleLabel.text = "Dispute Title."
                cell.titleLabel.required()
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "Transaction No."
                cell.titleLabel.required()
            } else if indexPath.row == 2 {
                cell.titleLabel.text = "Dispute Type."
                cell.titleLabel.required()
            }
            
            return cell
        } else {
            let cell: DisputeTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellTextFieldIdentifier) as! DisputeTextFieldTableViewCell
            cell.titleLabel.text = "Dispute Title."
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRectZero)
        } else if section == 1 {
            let headerView: AddProductHeaderView = XibHelper.puffViewWithNibName("AddProductHeaderView", index: 0) as! AddProductHeaderView
            return headerView
        } else {
            let headerView: RemarksTableViewCell = XibHelper.puffViewWithNibName("RemarksTableViewCell", index: 0) as! RemarksTableViewCell
            return headerView
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 1 {
            height = 66
        } else if section == 2 {
            height = 194
        }
        
        return height
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.textFieldRowHeight
    }
    
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
