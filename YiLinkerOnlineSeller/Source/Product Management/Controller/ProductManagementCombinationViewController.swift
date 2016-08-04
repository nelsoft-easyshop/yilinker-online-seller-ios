//
//  ProductManagementCombinationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/3/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementCombinationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var combinationModel: CombinationModel!
    var index: Int = 0

    var titles = ["SKU", "Quantity", "Regular Price", "Discounted Price", "Ongoing Promo Price", "Weight", "Height", "Width", "Length"]
    var values: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Combination"
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ProductDetailsIdentifier")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.values = [combinationModel.sku,
            combinationModel.quantity,
            combinationModel.retailPrice.formatToPeso(),
            combinationModel.discountedPrice.formatToPeso(),
            "-",
            combinationModel.weight + "kg",
            combinationModel.height + "cm",
            combinationModel.width + "cm",
            combinationModel.length + "cm"]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 44.0))
        headerView.backgroundColor = .whiteColor()
        
        let titleLabel: UILabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "  Combination \(index)"
        titleLabel.font = UIFont.boldSystemFontOfSize(15.0)
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ProductDetailsIdentifier") as! ProductDetailsTableViewCell
        cell.selectionStyle = .None
        
        cell.itemNameLabel.text = self.titles[indexPath.row]
        cell.itemValueLabel.text = self.values[indexPath.row]
        
        return cell
    }

}
