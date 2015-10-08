//
//  FollowersViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FollowerTableViewCellDelegate {
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var followersModel: FollowersModel = FollowersModel(isSuccessful: false, message: "", data: [])
    
    var hud: MBProgressHUD?
    
    var getCtr: Int = 0
    
    var errorLocalizeString: String  = ""
    
    var isPageEnd: Bool = false
    var page: Int = 1
    
    var searchTask: NSURLSessionDataTask?
    
    var contacts = [W_Contact()]
    
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
        if count(searchText) > 0 {
            page = 1
            followersModel.data.removeAll(keepCapacity: false)
            isPageEnd = false
            fireGetFollower(searchText)
        } else {
            page = 1
            followersModel.data.removeAll(keepCapacity: false)
            isPageEnd = false
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
        page = 1
        followersModel.data.removeAll(keepCapacity: false)
        isPageEnd = false
        fireGetFollower("")
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
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            showHUD()
            fireGetFollower("")
        }
    }
    
    // MARK: - Cell message button action
    func messageButtonAction(sender: AnyObject) {
        var pathOfTheCell: NSIndexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row

        getContactsFromEndpoint(followersModel.data[rowOfTheCell].email)
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
        
        if !isPageEnd {
            
            if (self.searchTask != nil) {
                searchTask?.cancel()
                manager.operationQueue.cancelAllOperations()
                searchTask = nil
            }
            
            self.emptyLabel.hidden = true
            
            var params: Dictionary = ["access_token" : SessionManager.accessToken(), "page": "\(page)", "perPage": "15"]
            if searchKey.isEmpty {
                if getCtr == 0{
                    showHUD()
                }
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                params["searchKeyword"] = searchKey
            }
            
            getCtr++
            searchTask = manager.GET(APIAtlas.getFollowers, parameters: params, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                
                let followerModel: FollowersModel = FollowersModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                if followerModel.isSuccessful {
                    self.page++
                    self.followersModel.data += followerModel.data
                    if self.followersModel.data.count == 0 {
                        self.emptyLabel.hidden = false
                    }
                    
                    if followerModel.data.count < 15 {
                        self.isPageEnd = true
                    }
                    
                    self.tableView.reloadData()
                    
                    
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.followersModel.message, title: self.errorLocalizeString)
                }
                self.hud?.hide(true)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    println(error)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if (task.response as? NSHTTPURLResponse != nil) {
                        let response: NSHTTPURLResponse  = task.response as! NSHTTPURLResponse
                        let statusCode: Int = response.statusCode
                        println("STATUS CODE \(statusCode)")
                        if statusCode == 401 {
                            self.fireRefreshToken(searchKey)
                        } else if statusCode == -1009 {
                            if !Reachability.isConnectedToNetwork() {
                                UIAlertController.displayNoInternetConnectionError(self)
                            }
                        } else if(statusCode != -999) {
                            UIAlertController.displaySomethingWentWrongError(self)
                        } else {
                            self.fireGetFollower(searchKey)
                        }
                    } else {
                        if !Reachability.isConnectedToNetwork() {
                            UIAlertController.displayNoInternetConnectionError(self)
                        }
                    }
            })
        } else {
            self.hud?.hide(true)
            let titleString = StringHelper.localizedStringWithKey("FOLLOWERS_TITLE_LOCALIZE_KEY")
            let noMoreDataString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreDataString, title: titleString)
        }
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
    
    func getContactsFromEndpoint(keyword: String){
        //SVProgressHUD.show()
        if (Reachability.isConnectedToNetwork()) {
            self.showHUD()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "1",
                "limit"         : "1",
                "keyword"       : keyword,
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONTACTS
            
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                self.goToMessaging()
                //SVProgressHUD.dismiss()
                self.hud?.hide(true)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        if (SessionManager.isLoggedIn()){
                            self.fireRefreshToken()
                        }
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    
                    self.contacts = Array<W_Contact>()
                    
                    //SVProgressHUD.dismiss()
                    self.hud?.hide(true)
            })
        }
        
    }
    
    func goToMessaging() {
        var selectedContact : W_Contact?
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
        
        
        if contacts.count != 0 {
            selectedContact = contacts[0]
        }
        
        var isOnline = "-1"
        if (SessionManager.isLoggedIn()){
            isOnline = "1"
        } else {
            isOnline = "0"
        }
        messagingViewController.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
        messagingViewController.recipient = selectedContact
        
        self.navigationController?.pushViewController(messagingViewController, animated: true)
    }
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
        })
        
    }
}



