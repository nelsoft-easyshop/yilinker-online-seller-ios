//
//  ChangeAddressViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ChangeAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeAddressTableViewCellDelegate, ChangeAddressFooterTableViewCellDelegate {

    @IBOutlet weak var changeAddressTableView: UITableView!
    
    let changeAddressTableViewCellIndentifier: String = "ChangeAddressTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeAddressTableView.delegate = self
        self.changeAddressTableView.dataSource = self
        
        let changeAdress: ChangeAddressFooterTableViewCell = XibHelper.puffViewWithNibName("ChangeAddressFooterTableViewCell", index: 0) as! ChangeAddressFooterTableViewCell
        changeAdress.delegate = self
        
        self.changeAddressTableView.tableFooterView = changeAdress
        
        self.registerNibs()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs(){
        var changeAddress = UINib(nibName: "ChangeAddressTableViewCell", bundle: nil)
        self.changeAddressTableView.registerNib(changeAddress, forCellReuseIdentifier: "ChangeAddressTableViewCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(changeAddressTableViewCellIndentifier, forIndexPath: indexPath) as! ChangeAddressTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { 
        return 121
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
