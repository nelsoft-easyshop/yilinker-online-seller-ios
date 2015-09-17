//
//  FilterViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/31/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func dismissView()
}

class FilterViewController: UIViewController, FilterFooterTableViewCellDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyFilterButton: SemiRoundedButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    var tableData: [FilterAttributeModel] = [
        FilterAttributeModel(title: "Search By", attributes: ["Product Name", "Transaction Id", "Rider"]),
        FilterAttributeModel(title: "Date", attributes: ["All", "Today", "Day Ago", "Week", "New"])]
    
    var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "FilterTableViewCell", bundle: nil)
        filterTableView.registerNib(nib, forCellReuseIdentifier: "FilterTableViewCell")
        
        let nibCalendar = UINib(nibName: "FilterCalendarTableViewCell", bundle: nil)
        filterTableView.registerNib(nibCalendar, forCellReuseIdentifier: "FilterCalendarTableViewCell")
        
        let filterFooterNib: UINib = UINib(nibName: "FilterFooterTableViewCell", bundle: nil)
        self.filterTableView.registerNib(filterFooterNib, forCellReuseIdentifier: "FilterFooterTableViewCell")
        
        self.filterTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        self.filterTableView.rowHeight = UITableViewAutomaticDimension
        self.filterTableView.layoutIfNeeded()
        self.filterTableView.tableFooterView = self.tableFooterView()
        self.filterTableView.tableFooterView!.frame = CGRectMake(0, 0, 0, self.filterTableView.tableFooterView!.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dismissView()
    }
    
    @IBAction func resetAction(sender: AnyObject) {
    }
    
    @IBAction func applyFilterAction(sender: AnyObject) {
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 298
        } else if indexPath.row == 0{
            return 95
        } else {
            return 95
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
            print("\(tableData.count)")
            //if !tableData.isEmpty {
                cell.passModel(tableData[0])
            //}
            
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
            print("\(tableData.count)")
            //if !tableData.isEmpty {
            cell.passModel(tableData[1])
            //}
            
            return cell
        }  else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCalendarTableViewCell", forIndexPath: indexPath) as! FilterCalendarTableViewCell
            return cell
        }
        
    }
    
    func tableFooterView() -> UIView {
        let guestCheckoutTableViewCell: FilterFooterTableViewCell = self.filterTableView.dequeueReusableCellWithIdentifier("FilterFooterTableViewCell") as! FilterFooterTableViewCell
        guestCheckoutTableViewCell.frame = CGRectMake(0, 0, self.filterTableView.frame.size.width, guestCheckoutTableViewCell.frame.size.height)
        guestCheckoutTableViewCell.delegate = self
        
        return guestCheckoutTableViewCell
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
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
