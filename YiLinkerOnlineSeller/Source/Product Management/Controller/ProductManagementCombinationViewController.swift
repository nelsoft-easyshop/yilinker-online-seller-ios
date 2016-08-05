//
//  ProductManagementCombinationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/3/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

private struct CombinationStrings {
    static let cellIdentifier = "ProductDetailsIdentifier"
    static let title = StringHelper.localizedStringWithKey("COMBINATION_LOCALIZE_KEY")
    static let sku = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_SKU_LOCALIZE_KEY")
    static let quantity = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_QUANTITY_LOCALIZE_KEY")
    static let retail = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_RETAIL_LOCALIZE_KEY")
    static let discounted = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_DISCOUNTED_LOCALIZE_KEY")
    static let ongoingPromoPrice = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_ON_GOING_PROMO_LOCALIZE_KEY")
    static let length = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_LENGTH_LOCALIZE_KEY")
    static let width = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_WIDTH_LOCALIZE_KEY")
    static let weight = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_WEIGHT_LOCALIZE_KEY")
    static let height = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_HEIGHT_LOCALIZE_KEY")
}

class ProductManagementCombinationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var combinationModel: CombinationModel!
    var index: Int = 0

    var titles = [CombinationStrings.sku,
        CombinationStrings.quantity,
        CombinationStrings.quantity,
        CombinationStrings.retail,
        CombinationStrings.ongoingPromoPrice,
        CombinationStrings.weight,
        CombinationStrings.height,
        CombinationStrings.width,
        CombinationStrings.length]
    var values: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = CombinationStrings.title
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: CombinationStrings.cellIdentifier)
        
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
        
        var backButton = UIBarButtonItem(image: UIImage(named: "back-white"), style: .Plain, target: self, action: "backAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
    }
    
    // MARK: - Action
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

extension ProductManagementCombinationViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CombinationStrings.cellIdentifier) as! ProductDetailsTableViewCell
        cell.selectionStyle = .None
        
        cell.itemNameLabel.text = self.titles[indexPath.row]
        cell.itemValueLabel.text = self.values[indexPath.row]
        
        return cell
    }
}

extension ProductManagementCombinationViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 44.0))
        headerView.backgroundColor = .whiteColor()
        
        let titleLabel: UILabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "  \(CombinationStrings.title) \(index)"
        titleLabel.font = UIFont.boldSystemFontOfSize(15.0)
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
}