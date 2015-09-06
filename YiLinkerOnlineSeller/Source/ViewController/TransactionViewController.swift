//
//  TransactionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var pageTitle: [String] = ["TRANSACTIONS", "NEW UPDATE", "ON-GOING", "COMPLETED", "CANCELLED"]
    var selectedImage: [String] = ["transactions2", "newUpdates2", "onGoing2", "completed2", "cancelled3"]
    var deSelectedImage: [String] = ["transaction", "newUpdates", "onGoing", "completed", "cancelled"]
    var selectedItems: [Bool] = []
    
    var selectedIndex: Int = 0
    var tableViewSectionHeight: CGFloat = 0
    var tableViewSectionTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerNibs()
        customizedNavigationBar()
        customizedVies()
    }

    // MARK: - Methods
    
    func registerNibs() {
        let tab = UINib(nibName: "TransactionCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(tab, forCellWithReuseIdentifier: "TransactionCollectionIdentifier")
        
        let list = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(list, forCellReuseIdentifier: "TransactionTableIdentifier")
    }
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Transaction"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "filter"), style: .Plain, target: self, action: "filterAction"), navigationSpacer]
    }
    
    func customizedVies() {
        
    }
    
    // MARK: - Actions

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func filterAction() {        
        let filterController = TransactionTableViewController(nibName: "TransactionTableViewController", bundle: nil)
        var navigation = UINavigationController(rootViewController: filterController)
        navigation.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        navigation.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
    
    
}



extension TransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TransactionCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("TransactionCollectionIdentifier", forIndexPath: indexPath) as! TransactionCollectionViewCell
        
        cell.pageLabel.text = pageTitle[indexPath.row].uppercaseString
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deSelectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        
        self.collectionView.reloadData()
//        self.tableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return
            CGSize(width: self.view.frame.size.width / 5, height: 50)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionTableIdentifier") as! TransactionTableViewCell
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var transactionDetailsController = TransactionDetailsTableViewController(nibName: "TransactionDetailsTableViewController", bundle: nil)
        self.navigationController?.pushViewController(transactionDetailsController, animated:true)

    }
}
