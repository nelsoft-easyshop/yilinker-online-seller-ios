//
//  FollowersViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FollowerTableViewCellDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var followersModel: FollowersModel = FollowersModel(isSuccessful: false, message: "", data: [])
    
    var hud: MBProgressHUD?
    
    var getCtr: Int = 0
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        initializeLocalizedString()
        titleView()
        backButton()
        registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getCtr = 0
        fireGetFollower("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
    }
    
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        emptyLabel.hidden = true
        emptyLabel.text = StringHelper.localizedStringWithKey("NO_FOLLOWER_LOCALIZE_KEY")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    func registerNibs() {
        var nib = UINib(nibName: "FollowerTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "FollowerTableViewCell")
    }
    
    func titleView() {
        self.title = StringHelper.localizedStringWithKey("FOLLOWERS_TITLE_LOCALIZE_KEY")
    }
    
    func backButton() {
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
    
    // Mark: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 1 {
            fireGetFollower(searchText)
        } else {
            fireGetFollower("")
        }
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fireGetFollower(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersModel.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowerTableViewCell", forIndexPath: indexPath) as! FollowerTableViewCell
        cell.delegate = self
        
        var temp: FollowerModel = followersModel.data[indexPath.row]
        
        cell.setFollowerImage(NSURL(string: temp.profileImageUrl)!)
        cell.setFollowerName(temp.fullName)
        cell.setFollowerEmail(temp.email)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Cell message button action
    func messageButtonAction(sender: AnyObject) {
        println("Message button clicked!")
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func fireGetFollower(searchKey: String) {
        self.emptyLabel.hidden = true
    
        let manager = APIManager.sharedInstance
        
        var params: Dictionary = ["access_token" : SessionManager.accessToken()]
        if searchKey.isEmpty {
            if getCtr == 0{
                showHUD()
            }
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            params["searchKeyword"] = searchKey
        }
        
        getCtr++
        
        manager.operationQueue.cancelAllOperations()
        manager.GET(APIAtlas.getFollowers, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.followersModel = FollowersModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            if self.followersModel.isSuccessful {
                if self.followersModel.data.count == 0 {
                    self.emptyLabel.hidden = false
                }
                self.tableView.reloadData()
                
                
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.followersModel.message, title: self.errorLocalizeString)
            }
            self.hud?.hide(true)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    if task.statusCode == 401 {
                        self.fireRefreshToken(searchKey)
                    } else {
                        self.emptyLabel.hidden = false
                        if Reachability.isConnectedToNetwork() {
                            UIAlertController.displaySomethingWentWrongError(self)
                        } else {
                            UIAlertController.displayNoInternetConnectionError(self)
                        }
                        println(error)
                    }
                }
        })
    }
    
    func fireRefreshToken(searchKey: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireGetFollower(searchKey)
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                UIAlertController.displaySomethingWentWrongError(self)
                self.hud?.hide(true)
        })
        
    }
    
}



