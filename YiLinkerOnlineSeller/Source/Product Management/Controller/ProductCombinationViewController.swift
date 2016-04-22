//
//  ProductCombinationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

typealias CombinationElement = (original: String, discount: String, isEnabled: Bool)

class ProductCombinationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellTitles = ["Finish", "Storage", "SKU"]
    let cellValues = ["Silver", "16GB", "G86712835-12"]
    
    var combinations: [CombinationElement] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        setupTableView()
        
        for i in 0..<3 {
            let element: CombinationElement
            element.original = ""
            element.discount = ""
            element.isEnabled = true
            combinations.append(element)
        }
    }

    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Product Combinations"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
        self.navigationItem.rightBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-check"), style: .Plain, target: self, action: "checkAction")]
    }
    
    func setupTableView() {
        
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 10.0))
        self.tableView.tableHeaderView = headerView
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 80.0))
        let saveButton: UIButton = UIButton(frame: CGRectMake(15, 0, self.tableView.frame.size.width - 30, 50.0))
        saveButton.backgroundColor = Constants.Colors.pmYesGreenColor
        saveButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        saveButton.layer.cornerRadius = 3.0
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
        
        for combination in combinations {
            
            if combination.isEnabled {
                println("ON  -- \(combination.original) > \(combination.discount)")
            } else {
                println("OFF -- \(combination.original) > \(combination.discount)")
            }

        }
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

extension ProductCombinationViewController: UITableViewDataSource, UITableViewDelegate, ProductCombination2TableViewCellDelegate, ProductCombination3TableViewCellDelegate {
    
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
            cell.delegate = self
            cell.tag = indexPath.section
            
            cell.originalTextField.text = combinations[indexPath.section].original
            cell.discountTextField.text = combinations[indexPath.section].discount
            
            return cell
        } else if indexPath.row == 4 {
            let cell: ProductCombination3TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell3") as! ProductCombination3TableViewCell
            cell.delegate = self
            cell.tag = indexPath.section
            
            cell.availableSwitch.on = combinations[indexPath.section].isEnabled
            
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
        textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        textLabel.textColor = UIColor.darkGrayColor()
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
    
    // MARK: - Product Combination View Delegate 2
    
    func getText(view: ProductCombination2TableViewCell, section: Int, text: String, isOriginalPrice: Bool) {

        if isOriginalPrice {
            combinations[section].original = text
        } else {
            combinations[section].discount = text
        }
    }
    
    // MARK: - Product Combination View Delegate 3
    
    func getSwitchValue(view: ProductCombination3TableViewCell, section: Int, value: Bool) {
        
        combinations[section].isEnabled = value
    }
    
}
