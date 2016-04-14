//
//  ProductManagementMenuTableViewController.swift
//  
//
//  Created by John Paul Chan on 13/04/2016.
//
//

import UIKit

class ProductManagementMenuTableViewController: UITableViewController {
    
    
    let cellTexts: [String] = [
        StringHelper.localizedStringWithKey("MANAGEMENT_MENU_LANGUAGE_TRANSLATION"),
        StringHelper.localizedStringWithKey("MANAGEMENT_MENU_STORES_AVAILABLE"),
        StringHelper.localizedStringWithKey("MANAGEMENT_MENU_PRODUCT_DETAILS")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializesViews()
        self.registerNibs()
        self.addBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("MANAGEMENT_TITLE_LOCALIZE_KEY")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nib = UINib(nibName: ProductManagementMenuTableViewCell.reuseIdentidifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductManagementMenuTableViewCell.reuseIdentidifier)
    }
    
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTexts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ProductManagementMenuTableViewCell.reuseIdentidifier, forIndexPath: indexPath) as! ProductManagementMenuTableViewCell

        cell.setCellText(self.cellTexts[indexPath.row])

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            //Redirect to Language Translation
            Toast.displayToastWithMessage("Language Translation", duration: 1.5, view: self.view)
        } else if indexPath.row == 1 {
            //Redirect to Stores Available
            Toast.displayToastWithMessage("Stores Available", duration: 1.5, view: self.view)
        } else if indexPath.row == 2 {
            //Redirect to Product Details
            Toast.displayToastWithMessage("Product Details", duration: 1.5, view: self.view)
        }
    }

}
