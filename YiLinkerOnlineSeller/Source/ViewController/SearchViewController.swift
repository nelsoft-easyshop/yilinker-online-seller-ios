//
//  SearchViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBOutlet weak var filterByTableView: UITableView!
    
    @IBOutlet weak var searchFilterByView: UIView!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var searchTextField: DynamicRoundedTextField!
    
    @IBOutlet weak var filterByButton: DynamicRoundedButton!
    
    @IBOutlet weak var arrowView: UIView!
    
    var filterBySelected: String = ""
    
    var filterBy = ["All", "Transaction Id", "Product Name", "Rider"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeViews()
        self.dimView.hidden = true
        self.searchFilterByView.hidden = true
        self.filterByButton.setTitle(filterBy[0], forState: UIControlState.Normal)
        self.searchTextField.delegate = self
        //self.searchTextField.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        // Connect all delegate prototypes
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.delegate = self
        self.filterByTableView.dataSource = self
        self.filterByTableView.delegate = self
        self.filterByTableView.separatorInset = UIEdgeInsetsZero
        self.filterByTableView.layoutMargins = UIEdgeInsetsZero
        // Do any additional setup after loading the view.
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            as [NSObject : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict
        
        // Remove trailing cells
        self.searchResultTableView.tableFooterView = UIView(frame: CGRectZero)
        self.filterByTableView.tableFooterView = UIView(frame: CGRectZero)
        // Remove NavigationBar shadow
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        //Register Nib to Tableview
        var nibCategory = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        searchResultTableView.registerNib(nibCategory, forCellReuseIdentifier: "CategoryTableViewCell")
        
        var nibFilter = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        filterByTableView.registerNib(nibFilter, forCellReuseIdentifier: "FilterByTableViewCell")
        
        
    }
    
    //    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    //        self.searchBar.resignFirstResponder()
    //    }
    
    // Mark: - UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(self.searchResultTableView)){
            return 3
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView .isEqual(self.searchResultTableView)){
            return 144
        } else {
            return 30
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView .isEqual(self.searchResultTableView)){
            let cell = searchResultTableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
            
            return cell
        } else {
            let cell = filterByTableView.dequeueReusableCellWithIdentifier("FilterByTableViewCell") as! FilterByTableViewCell
            cell.filterByLabel.text = filterBy[indexPath.row]
            cell.layoutMargins = UIEdgeInsetsZero
            
            return cell
        }
        
    }
    
    // Mark: - UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView.isEqual(self.filterByTableView)){
            self.filterByButton.tag = 1
            self.dimView.hidden = true
            self.searchFilterByView.hidden = true
            self.filterByButton.backgroundColor = UIColor.whiteColor()
            self.arrowView.backgroundColor = UIColor.whiteColor()
            self.filterByButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            
            let indexPath = tableView.indexPathForSelectedRow();
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
            self.filterByButton.setTitle(filterBy[indexPath!.row], forState: UIControlState.Normal)
            filterBySelected = filterBy[indexPath!.row]
            
            println(filterBySelected)
        }
    }
    
    @IBAction func showFilterByView(sender: AnyObject){
        
        if(self.filterByButton.tag == 1){
            self.filterByButton.tag = 2
            self.dimView.hidden = false
            self.searchFilterByView.hidden = false
            self.filterByButton.backgroundColor = Constants.Colors.appTheme
            self.filterByButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.arrowView.backgroundColor = Constants.Colors.appTheme
        } else {
            self.filterByButton.tag = 1
            self.dimView.hidden = true
            self.searchFilterByView.hidden = true
            self.filterByButton.backgroundColor = UIColor.whiteColor()
            self.arrowView.backgroundColor = UIColor.whiteColor()
            self.filterByButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.searchTextField.resignFirstResponder()
        self.searchTextField.endEditing(true)
        var storeInfoViewController = FilterResultsViewController(nibName: "FilterResultsViewController", bundle: nil)
        storeInfoViewController.edgesForExtendedLayout = .None
        self.navigationController?.pushViewController(storeInfoViewController, animated: true)
        return true
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
