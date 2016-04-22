//
//  ProductCombinationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductCombinationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellTitles = ["Finish", "Storage", "SKU"]
    let cellValues = ["Silver", "16GB", "G86712835-12"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Product Combinations"
        
        setupTableView()
    }

    // MARK: - Functions
    
    func setupTableView() {
        
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 10.0))
        self.tableView.tableHeaderView = headerView
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 80.0))
        let saveButton: UIButton = UIButton(frame: CGRectMake(15, 0, self.tableView.frame.size.width - 30, 50.0))
        saveButton.backgroundColor = Constants.Colors.pmCheckGreenColor
        saveButton.titleLabel!.font = UIFont(name: "Helvetica-Neue", size: 12.0)
        saveButton.layer.cornerRadius = 2.0
        saveButton.setTitle("SAVE PRODUCT COMBINATIONS", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveAction", forControlEvents: .TouchUpInside)
        footerView.addSubview(saveButton)
        self.tableView.tableFooterView = footerView
        
        // registering cells
        
        self.tableView.registerNib(UINib(nibName: "ProductCombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell")
        self.tableView.registerNib(UINib(nibName: "ProductCombination2TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell2")
        self.tableView.registerNib(UINib(nibName: "ProductCombination3TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell3")
    }
    
    
    // MARK: - Actions
    
    func saveAction() {
        
    }
    
}

extension ProductCombinationViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {
            let cell: ProductCombination2TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell2") as! ProductCombination2TableViewCell
            return cell
        } else if indexPath.row == 4 {
            let cell: ProductCombination3TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell3") as! ProductCombination3TableViewCell
            return cell
        }
        
        let cell: ProductCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell") as! ProductCombinationTableViewCell
        cell.titleLabel.text = cellTitles[indexPath.row]
        cell.valueLabel.text = cellValues[indexPath.row]
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 40.0))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let textLabel: UILabel = UILabel(frame: CGRectMake(15, 0, headerView.frame.size.width - 15, headerView.frame.size.height))
        textLabel.text = "Combination \(section + 1)"
        headerView.addSubview(textLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 89.0
        } else if indexPath.row == 4 {
            return 70.0
        }
        
        return 44.0
    }
    
}
