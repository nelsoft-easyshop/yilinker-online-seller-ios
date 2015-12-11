//
//  ResolutionCenterProductListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ResolutionCenterProductListViewControllereDelegate {
    func resolutionCenterProductListViewController(resolutionCenterProductListViewController: ResolutionCenterProductListViewController, didSelecteProducts products: [TransactionOrderProductModel])
}

class ResolutionCenterProductListViewController: UIViewController {
    
    var delegate: ResolutionCenterProductListViewControllereDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    var transactionDetails: TransactionDetailsModel = TransactionDetailsModel()
    var transactionDetailsFiltered: [TransactionOrderProductModel] = []
    var transactionItemModel: [TransactionItemModel] = []
    
    let cellIdentifier: String = "ResellerItemTableViewCell"
    let cellNibName: String = "ResellerItemTableViewCell"
    let cellHeight: CGFloat = 86.0
    
    var transactionId: String = ""
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.registerCell()
        self.title = "Add Item"
        self.backButton()
        self.checkButton()
        self.footerView()
        self.fireGetTransactionItems()
    }
    
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func check() {
        var products: [TransactionOrderProductModel] = []
        
        for i in 0..<self.transactionDetails.transactionItems[0].products.count {
            if self.transactionDetails.transactionItems[0].products[i].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
                //self.transactionDetailsFiltered.append(self.transactionDetails.transactionItems[0].products[i])
                //self.transactionItemModel.append(self.transactionDetails.transactionItems[0])
                products.append(self.transactionDetails.transactionItems[0].products[i])
            }
            
        }
        
        /*
        for product in self.transactionDetails.transactionItems[0].products {
            if product.transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
                products.append(product)
            }
        }*/
        
        self.delegate!.resolutionCenterProductListViewController(self, didSelecteProducts: products)
        self.navigationController?.popViewControllerAnimated(true)
    }

    func fireGetTransactionItems() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        var productIds: [Int] = []
        
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "transactionId": self.transactionId]
        
        manager.GET(APIAtlas.resolutionCenterGetTransactionItems, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            println(responseObject)
            self.transactionDetails = TransactionDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            for i in 0..<self.transactionDetails.transactionItems[0].products.count {
                if self.transactionDetails.transactionItems[0].products[i].orderProductStatusId == 4 {
                    self.transactionDetailsFiltered.append(self.transactionDetails.transactionItems[0].products[i])
                    self.transactionItemModel.append(self.transactionDetails.transactionItems[0])
                }

            }
            self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(Constants.Localized.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    }
                    //self.navigationController?.view.makeToast(Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
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
            
            self.fireGetTransactionItems()
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
        })
        
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.transactionDetails.transactionItems.count != 0 {
//            return self.transactionDetails.transactionItems[0].products.count
//        } 
        if self.transactionDetailsFiltered.count != 0 {
            return self.transactionDetailsFiltered.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let transactionProductModel: TransactionOrderProductModel =  self.transactionDetails.transactionItems[0].products[indexPath.row]
        let cell: ResellerItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! ResellerItemTableViewCell
        
        //if self.transactionDetails.transactionItems[0].products[indexPath.row].orderProductStatusId == 4 {
            cell.cellTitleLabel.text = self.transactionDetailsFiltered[indexPath.row].productName
            cell.cellSellerLabel.text = self.transactionItemModel[indexPath.row].sellerStore
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.cellImageView.sd_setImageWithURL(NSURL(string: self.transactionDetailsFiltered[indexPath.row].productImage), placeholderImage: UIImage(named: "dummy-placeholder"))
            
            if self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
                cell.checkImage()
            } else {
                cell.addImage()
            }

        //}
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        /*let transactionProductModel: TransactionOrderProductModel =  self.transactionDetails.transactionItems[0].products[indexPath.row]
        if transactionProductModel.transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
            transactionProductModel.transactionOrderItemStatus = TransactionOrderItemStatus.UnSelected
        } else {
            transactionProductModel.transactionOrderItemStatus = TransactionOrderItemStatus.Selected
        }*/
        if self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
            self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus = TransactionOrderItemStatus.UnSelected
        } else {
            self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus = TransactionOrderItemStatus.Selected
        }
        self.tableView.reloadData()
    }
    
    func showAlert(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
