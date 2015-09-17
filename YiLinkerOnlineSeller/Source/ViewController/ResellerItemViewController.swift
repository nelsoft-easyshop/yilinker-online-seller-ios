//
//  ResellerItemTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerItemViewController: UIViewController {
    
    let cellIdentifier: String = "ResellerItemTableViewCell"
    let cellNibName: String = "ResellerItemTableViewCell"
    let cellHeight: CGFloat = 86.0
    
    var items: [ResellerItemModel] = []
    var hud: MBProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.registerCell()
        self.title = "Add Item"
        self.backButton()
        self.checkButton()
        for var x = 0; x < 10; x++ {
            let resellerItemModel: ResellerItemModel = ResellerItemModel()
            resellerItemModel.name = "Picolo HeadPhones"
            resellerItemModel.brand = BrandModel(name: "DBZ Electronics", brandId: 1)
            self.items.append(resellerItemModel)
        }
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    
    func backButton() {
        let backButton:UIButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        let customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func registerCell() {
        let nib: UINib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    func checkButton() {
        let checkButton:UIButton = UIButton(type: UIButtonType.Custom)
        checkButton.frame = CGRectMake(0, 0, 45, 45)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        let customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    func check() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let resellerItemModel: ResellerItemModel = self.items[indexPath.row]
        let cell: ResellerItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! ResellerItemTableViewCell
        cell.cellTitleLabel.text = resellerItemModel.name
        cell.cellSellerLabel.text = resellerItemModel.brand.name
        
        if resellerItemModel.status == ResellerItemStatus.Selected {
            cell.checkImage()
        } else {
            cell.addImage()
        }
        
        return cell
    }

     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let resellerItemModel: ResellerItemModel = self.items[indexPath.row]
        if resellerItemModel.status == ResellerItemStatus.Selected {
            resellerItemModel.status = ResellerItemStatus.Unselected
        } else {
            resellerItemModel.status = ResellerItemStatus.Selected
        }
        self.tableView.reloadData()
    }
}
