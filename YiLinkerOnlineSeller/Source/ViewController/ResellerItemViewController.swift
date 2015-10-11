//
//  ResellerItemTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ResellerStrings {
    static let reseller: String = StringHelper.localizedStringWithKey("RESELLER_LOCALIZE_KEY")
    static let resellerAddItem: String = StringHelper.localizedStringWithKey("RESELLER_ADDITEMS_LOCALIZE_KEY")
}

class ResellerItemViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate {
    
    let cellIdentifier: String = "ResellerItemTableViewCell"
    let cellNibName: String = "ResellerItemTableViewCell"
    let cellHeight: CGFloat = 86.0
    
    var items: [ResellerItemModel] = []
    var hud: MBProgressHUD?
    var page: Int = 1
    
    var resellerGetProductModel: ResellerGetProductModel = ResellerGetProductModel()
    var categoryModel: CategoryModel = CategoryModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resellerViewController: ResellerViewController = ResellerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.initParentViewController()
        self.registerCell()
        self.title = ResellerStrings.resellerAddItem
        self.backButton()
        self.checkButton()
        self.footerView()
        self.fireGetProductList()
    }
    
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    // Init Parent View Controller
    
    func initParentViewController() {
        self.resellerViewController = self.navigationController!.viewControllers[0] as! ResellerViewController
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
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
    
    func registerCell() {
        let nib: UINib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    func checkButton() {
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 45, 45)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    //MARK: - Check
    func check() {
        self.resellerViewController.animateSelectedItems()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resellerGetProductModel.resellerItems.count
    }


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let resellerItemModel: ResellerItemModel = self.resellerGetProductModel.resellerItems[indexPath.row]
        let cell: ResellerItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! ResellerItemTableViewCell
        cell.cellTitleLabel.text = resellerItemModel.productName
        cell.cellSellerLabel.text = resellerItemModel.manufacturer
        println(resellerItemModel.imageUrl)
        cell.cellImageView.sd_setImageWithURL(NSURL(string: resellerItemModel.imageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))

        var isSelected: Bool = false
        
        for item in self.resellerViewController.resellerUploadedItemModels {
            if item.uid == resellerItemModel.uid {
                isSelected = true
            }
        }
        
        if isSelected {
            cell.checkImage()
        } else {
            cell.addImage()
        }
        
        return cell
    }

     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
      //MARK: - TableView Delegate
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let resellerItemModel: ResellerItemModel = self.resellerGetProductModel.resellerItems[indexPath.row]
        
        var isSelected: Bool = false
        
        for (index, item) in enumerate(self.resellerViewController.resellerUploadedItemModels) {
            if item.uid == resellerItemModel.uid {
                self.resellerViewController.resellerUploadedItemModels.removeAtIndex(index)
                isSelected = true
            }
        }
        
        if !isSelected {
            self.resellerViewController.resellerUploadedItemModels.append(resellerItemModel)
        }
        
        self.tableView.reloadData()
    }
    
    func fireGetProductList() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "categoryId": self.categoryModel.uid,
            "page": self.page]
        
        manager.GET(APIAtlas.resellerUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if self.page == 1 {
                self.resellerGetProductModel = ResellerGetProductModel.parseDataFromDictionary(responseObject as! NSDictionary)
            } else {
                let resellerAppendGetProductModel: ResellerGetProductModel = ResellerGetProductModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                for item in resellerAppendGetProductModel.resellerItems {
                    self.resellerGetProductModel.resellerItems.append(item)
                }
            }
            self.page++
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                }
                
                self.hud?.hide(true)
        })
    }
    
    func fireGetProductListWithQuery(query: String) {
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "categoryId": self.categoryModel.uid,
            "page": 1,
            "query": query]
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        manager.operationQueue.cancelAllOperations()
        manager.GET(APIAtlas.resellerUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if self.page == 1 {
                self.resellerGetProductModel = ResellerGetProductModel.parseDataFromDictionary(responseObject as! NSDictionary)
            } else {
                let resellerAppendGetProductModel: ResellerGetProductModel = ResellerGetProductModel.parseDataFromDictionary(responseObject as! NSDictionary)
                self.resellerGetProductModel.resellerItems.removeAll(keepCapacity: true)
                for item in resellerAppendGetProductModel.resellerItems {
                    self.resellerGetProductModel.resellerItems.append(item)
                }
            }
            
            self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireGetProductList()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset: CGPoint = scrollView.contentOffset
        let bounds: CGRect = scrollView.bounds
        
        let size: CGSize = scrollView.contentSize
        let inset: UIEdgeInsets = scrollView.contentInset;
        let y: CGFloat = offset.y + bounds.size.height - inset.bottom
        let h: CGFloat = size.height
  
    
        let reload_distance: CGFloat = 10
        
        if(y > h + reload_distance) && self.items.count != 0 {
            self.fireGetProductList()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.fireGetProductListWithQuery(searchText)
        
        if searchText == "" {
            self.page = 1
            self.fireGetProductList()
        }
    }
}
