//
//  EdititemsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class EdititemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    var selectedIndex: Int = -1
    var selectedItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
        
        let nib = UINib(nibName: "AddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddItemTableViewCell")
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Edit Items"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkAction() {
        closeAction()
    }
    
    @IBAction func clearAllAction(sender: AnyObject) {
    }
    
    @IBAction func removeItemsAction(sender: AnyObject) {
        self.clearAllButton.hidden = false
        self.bottomBarView.hidden = false
    }
    
    @IBAction func addItem(sender: AnyObject) {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        var rootViewController = UINavigationController(rootViewController: addItem)
        self.navigationController?.presentViewController(rootViewController, animated: false, completion: nil)
    }
    
    @IBAction func removedSelectedAction(sender: AnyObject) {
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        self.bottomBarView.hidden = true
        self.clearAllButton.hidden = true
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddItemTableViewCell") as! AddItemTableViewCell
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.selectedIndex = indexPath.row
//        
//        let cell: AddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! AddItemTableViewCell
//        if cell.addImageView?.image == UIImage(named: "addItem") {
//            cell.updateStatusImage(true)
//            selectedItem++
//        } else {
//            cell.updateStatusImage(false)
//            selectedItem--
//        }
        
    }

}
