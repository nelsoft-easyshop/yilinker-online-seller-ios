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
    
    var filterBySelected: Int = 0
    var currentPage: Int = 0
    var nextpage: Int = 0
    
    var allObjectArray: NSMutableArray = []
    var elements: NSMutableArray = []
    
    var filterBy = ["All", "Transaction Id", "Product Name", "Rider"]
    
    var hud: MBProgressHUD?
    
    var searchModel: SearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeViews()
        self.dimView.hidden = true
        self.searchFilterByView.hidden = true
        self.filterByButton.setTitle(filterBy[0], forState: UIControlState.Normal)
        self.searchTextField.delegate = self
        self.searchResultTableView.separatorInset = UIEdgeInsetsZero
        self.searchResultTableView.layoutMargins = UIEdgeInsetsZero
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
        /*let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            as [NSObject : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict*/
        
        // Remove trailing cells
        self.searchResultTableView.tableFooterView = UIView(frame: CGRectZero)
        self.filterByTableView.tableFooterView = UIView(frame: CGRectZero)
        // Remove NavigationBar shadow
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        //Register Nib to Tableview
        let nibCategory = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        searchResultTableView.registerNib(nibCategory, forCellReuseIdentifier: "CategoryTableViewCell")
        
        let nibSearch = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchResultTableView.registerNib(nibSearch, forCellReuseIdentifier: "SearchTableViewCell")
        
        let nibFilter = UINib(nibName: "FilterByTableViewCell", bundle: nil)
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
            if self.searchModel != nil {
                return self.searchModel!.invoiceNumber.count
            } else {
                return 1
            }
        } else {
               return 4
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView .isEqual(self.searchResultTableView)){
            return 46
        } else {
            return 30
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView.isEqual(self.searchResultTableView)){
            let cell = searchResultTableView.dequeueReusableCellWithIdentifier("SearchTableViewCell") as! SearchTableViewCell
            if self.searchModel != nil {
                cell.invoiceNumberLabel.text = self.searchModel?.invoiceNumber[indexPath.row]
            }
            
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
            
            let indexPath = tableView.indexPathForSelectedRow;
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
            self.filterByButton.setTitle(filterBy[indexPath!.row], forState: UIControlState.Normal)
            filterBySelected = indexPath!.row
            
            print(filterBySelected)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        nextpage = elements.count - 5
        if indexPath.row == nextpage {
            currentPage++
            nextpage = elements.count  - 5
            elements.addObjectsFromArray(allObjectArray.subarrayWithRange(NSMakeRange(currentPage, 20)))
            self.searchResultTableView.reloadData()
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
        
        self.fireSearch()
        return true
    }
    
    func fireSearch(){
        if filterBySelected == 1 {
            self.showHUD()
            let manager = APIManager.sharedInstance
            let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
            
            manager.GET(APIAtlas.transaction+"\(SessionManager.accessToken())&query=\(self.searchTextField.text)", parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                
                self.searchModel = SearchModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                for var i = 0; i < self.searchModel!.invoiceNumber.count; i++ {
                    self.allObjectArray.addObject(i)
                }
                self.elements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(0, 20)))
                
                let storeInfoViewController = FilterResultsViewController(nibName: "FilterResultsViewController", bundle: nil)
                storeInfoViewController.edgesForExtendedLayout = .None
                storeInfoViewController.searchModel = self.searchModel
                self.navigationController?.pushViewController(storeInfoViewController, animated: true)

                
                //self.searchResultTableView.reloadData()
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    print(error)
            })
        } else {
            print("Search not available.")
        }
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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
