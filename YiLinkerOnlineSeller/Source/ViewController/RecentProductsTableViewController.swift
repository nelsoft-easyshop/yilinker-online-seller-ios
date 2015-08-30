//
//  RecentProductsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class RecentProductsTableViewController: UITableViewController {
    
    let recentOrderCellIdentifier: String = "RecentProductsTableViewCell"
    
    var tableData: [RecentOrderModel] = [
        RecentOrderModel(imageURL: "http://ecx.images-amazon.com/images/I/61My0e0VboL._SY355_.jpg", productName: "Beats Solo", modeOfPayment: "Cash on Delivery", price: "P 11, 192", status: "Pending"),
         RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-solo2-2787-212883-1-zoom.jpg", productName: "Beats Solo 2", modeOfPayment: "Cash on Delivery", price: "P 13, 164", status: "Complete"),
         RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-pro-over-the-ear-headphones-white-9961-587063-1-zoom.jpg", productName: "Beats Pro", modeOfPayment: "Cash on Delivery", price: "P 24, 500", status: "Pending"),
        
        RecentOrderModel(imageURL: "http://ecx.images-amazon.com/images/I/61My0e0VboL._SY355_.jpg", productName: "Beats Solo", modeOfPayment: "Cash on Delivery", price: "P 11, 192", status: "Pending"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-solo2-2787-212883-1-zoom.jpg", productName: "Beats Solo 2", modeOfPayment: "Cash on Delivery", price: "P 13, 164", status: "Complete"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-pro-over-the-ear-headphones-white-9961-587063-1-zoom.jpg", productName: "Beats Pro", modeOfPayment: "Cash on Delivery", price: "P 24, 500", status: "Pending"),
        
        RecentOrderModel(imageURL: "http://ecx.images-amazon.com/images/I/61My0e0VboL._SY355_.jpg", productName: "Beats Solo", modeOfPayment: "Cash on Delivery", price: "P 11, 192", status: "Pending"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-solo2-2787-212883-1-zoom.jpg", productName: "Beats Solo 2", modeOfPayment: "Cash on Delivery", price: "P 13, 164", status: "Complete"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-pro-over-the-ear-headphones-white-9961-587063-1-zoom.jpg", productName: "Beats Pro", modeOfPayment: "Cash on Delivery", price: "P 24, 500", status: "Pending"),
        
        RecentOrderModel(imageURL: "http://ecx.images-amazon.com/images/I/61My0e0VboL._SY355_.jpg", productName: "Beats Solo", modeOfPayment: "Cash on Delivery", price: "P 11, 192", status: "Pending"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-solo2-2787-212883-1-zoom.jpg", productName: "Beats Solo 2", modeOfPayment: "Cash on Delivery", price: "P 13, 164", status: "Complete"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-pro-over-the-ear-headphones-white-9961-587063-1-zoom.jpg", productName: "Beats Pro", modeOfPayment: "Cash on Delivery", price: "P 24, 500", status: "Pending"),
        
        RecentOrderModel(imageURL: "http://ecx.images-amazon.com/images/I/61My0e0VboL._SY355_.jpg", productName: "Beats Solo", modeOfPayment: "Cash on Delivery", price: "P 11, 192", status: "Pending"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-solo2-2787-212883-1-zoom.jpg", productName: "Beats Solo 2", modeOfPayment: "Cash on Delivery", price: "P 13, 164", status: "Complete"),
        RecentOrderModel(imageURL: "http://srv-live.lazada.com.ph/p/beats-pro-over-the-ear-headphones-white-9961-587063-1-zoom.jpg", productName: "Beats Pro", modeOfPayment: "Cash on Delivery", price: "P 24, 500", status: "Pending")]
        
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
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nib = UINib(nibName: recentOrderCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: recentOrderCellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(recentOrderCellIdentifier, forIndexPath: indexPath) as! RecentProductsTableViewCell

        var temp: RecentOrderModel = tableData[indexPath.row]
        cell.setProductImage(temp.imageURL)
        cell.setProductName(temp.productName)
        cell.setModeOfPayment(temp.modeOfPayment)
        cell.setPrice(temp.price)
        cell.setStatus(temp.status)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
