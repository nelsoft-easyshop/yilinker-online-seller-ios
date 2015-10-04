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
    
    let searchTitle: String = StringHelper.localizedStringWithKey("SEARCH_TITLE_LOCALIZE_KEY")
    let all: String = StringHelper.localizedStringWithKey("SEARCH_ALL_LOCALIZE_KEY")
    let transaction: String = StringHelper.localizedStringWithKey("SEARCH_TRANSACTION_LOCALIZE_KEY")
    let productName: String = StringHelper.localizedStringWithKey("SEARCH_PRODUCT_LOCALIZE_KEY")
    let rider: String = StringHelper.localizedStringWithKey("SEARCH_RIDER_LOCALIZE_KEY")
    
    var filterBy: [String] = []
    
    var hud: MBProgressHUD?
    
    var searchModel: SearchModel?
    var searchProductNameModel: SearchProductNameModel?
    var tableData: [SearchProductNameModel] = []
    var transactionModel: TransactionModel?
    
    var riderNameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.filterBy = [self.all, self.transaction, self.productName, self.rider]
        self.initializeViews()
        self.dimView.hidden = true
        self.searchFilterByView.hidden = true
        self.filterByButton.setTitle(filterBy[0], forState: UIControlState.Normal)
        self.searchTextField.delegate = self
        self.searchResultTableView.separatorInset = UIEdgeInsetsZero
        self.searchResultTableView.layoutMargins = UIEdgeInsetsZero
        //self.searchTextField.becomeFirstResponder()
        self.title = searchTitle
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
        
        var nibSearch = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchResultTableView.registerNib(nibSearch, forCellReuseIdentifier: "SearchTableViewCell")
        
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
            if self.filterBySelected == 2 {
                if !self.tableData.isEmpty {
                    return self.tableData.count
                } else {
                    return 0
                }
            } else if self.filterBySelected == 3 {
                return self.riderNameArray.count
            } else {
                return 0
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
            if self.filterBySelected == 2 {
                if !self.tableData.isEmpty {
                    cell.invoiceNumberLabel.text = self.tableData[indexPath.row].name2
                }
            } else {
                if !self.riderNameArray.isEmpty {
                    cell.invoiceNumberLabel.text = self.riderNameArray[indexPath.row]
                }
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
            
            let indexPath = tableView.indexPathForSelectedRow();
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
            self.filterByButton.setTitle(filterBy[indexPath!.row], forState: UIControlState.Normal)
            filterBySelected = indexPath!.row
            
            println(filterBySelected)
        } else {
            if self.filterBySelected == 2 {
                
            } else {
              println("--\(self.riderNameArray[indexPath.row])")
                var filterRiderNameViewController = FilterResultsRiderNameViewController(nibName: "FilterResultsRiderNameViewController", bundle: nil)
                filterRiderNameViewController.edgesForExtendedLayout = .None
                filterRiderNameViewController.riderName = self.riderNameArray[indexPath.row]
                filterRiderNameViewController.searchType = 3
                self.navigationController?.pushViewController(filterRiderNameViewController, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
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
        
        if filterBySelected == 0 {
            self.showAlert(title: "Information", message: "Search by \(filterBy[filterBySelected]) is not yet available.")
        } else if filterBySelected == 2 {
            self.tableData.removeAll(keepCapacity: false)
            self.fireSearchProduct(2)
        } else if filterBySelected == 3 {
            self.riderNameArray.removeAll(keepCapacity: false)
            self.fireSearchProduct(3)
        } else {
            if count(textField.text) < 3 {
                self.showAlert(title: "Error", message: "Minimum character is 3. Please enter another transaction id.")
                textField.text = ""
            } else {
                self.fireSearch()
            }
            
        }
        
        return true
    }
    
    func fireSearch(){
        if filterBySelected == 1 {
            self.showHUD()
            let manager = APIManager.sharedInstance
            let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
            
            manager.GET(APIAtlas.transaction+"\(SessionManager.accessToken())&query=\(self.searchTextField.text)", parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
           
                self.searchModel = SearchModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                for var i = 0; i < self.searchModel!.invoiceNumber.count; i++ {
                    self.allObjectArray.addObject(i)
                }
                self.elements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(0, 20)))
                
                var storeInfoViewController = FilterResultsViewController(nibName: "FilterResultsViewController", bundle: nil)
                storeInfoViewController.edgesForExtendedLayout = .None
                storeInfoViewController.searchModel = self.searchModel
                self.navigationController?.pushViewController(storeInfoViewController, animated: true)

                
                //self.searchResultTableView.reloadData()
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    } else if task.statusCode == 401 {
                        self.fireRefreshToken(SearchRefreshType.TransactionId)
                    } else {
                        self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    }
                    self.hud?.hide(true)
            })
        } else {
            println("Search not available.")
        }
    }
    
    func fireSearchProduct(search: Int){
        self.showHUD()
        let manager = APIManager.sharedInstance
        var url: String = ""
        if search == 2 {
            url = APIAtlas.searchNameSuggestion
        } else {
            url = APIAtlas.searchRiderSuggestion
        }
        manager.GET(url+"\(SessionManager.accessToken())&queryString=\(self.searchTextField.text)", parameters: nil, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(">> \(responseObject)")
            
            if search == 2 {
                let searchProductNameModel: SearchProductNameModel = SearchProductNameModel.parseDataFromDictionary(responseObject as! NSDictionary)
                println("\(searchProductNameModel.name.count)")
                for var i = 0; i < searchProductNameModel.name.count; i++ {
                    self.tableData.append(SearchProductNameModel(name2: searchProductNameModel.name[i], productId2: searchProductNameModel.productId[i]))
                }
            } else {
                var rider: NSArray = responseObject["data"] as! NSArray
                println(responseObject["data"] as! NSArray)
                for var i: Int = 0; i < rider.count; i++ {
                    self.riderNameArray.append(rider[i] as! String)
                }
            }
            
            self.searchResultTableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                    self.fireRefreshToken(SearchRefreshType.ProductName)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                }
                self.hud?.hide(true)
        })
        
    }
    
    func fireRefreshToken(type: SearchRefreshType) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == SearchRefreshType.ProductName {
                self.fireSearchProduct(2)
            } else if type == SearchRefreshType.All {
                
            } else if type == SearchRefreshType.TransactionId {
                self.fireSearch()
            } else {
                self.fireSearchProduct(3)
            }
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
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
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
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
