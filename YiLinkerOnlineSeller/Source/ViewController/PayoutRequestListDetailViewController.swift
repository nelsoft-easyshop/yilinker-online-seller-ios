//
//  PayoutRequestListDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutRequestListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerCell()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Regiter nib files
    func registerCell() {
        let nib: UINib = UINib(nibName: "PayoutRequestListDetailHeaderTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PayoutRequestListDetailHeaderTableViewCell")
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
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PayoutRequestListItemTableViewCell", forIndexPath: indexPath) as! PayoutRequestListItemTableViewCell

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutRequestListDetailViewController = PayoutRequestListDetailViewController(nibName: "PayoutRequestListDetailViewController", bundle: nil)
        self.navigationController?.presentViewController(payoutRequestListDetailViewController, animated: true, completion: nil)
        //self.navigationController?.pushViewController(payoutRequestListDetailViewController, animated:true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier("PayoutRequestListDetailHeaderTableViewCell") as! PayoutRequestListDetailHeaderTableViewCell
        //self.tableView.tableHeaderView = nil
        //self.tableView.tableHeaderView = tableHeaderView
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
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
