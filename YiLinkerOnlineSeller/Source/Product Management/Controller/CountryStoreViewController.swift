//
//  CountryStoreViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/20/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountryStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EmptyViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var countryListModel: [CountryListModel] = []
    
    var hud: MBProgressHUD?
    var emptyView: EmptyView?
    
    var productId: String = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        fireGetCountries()
        setupNavigationBar()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.registerNib(UINib(nibName: "CountryStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "countryId")
    }

    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Country Store"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
    }

    func populateData() {
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Requests
    
    func fireGetCountries() {

        self.showHUD()
        WebServiceManager.fireGetListOfCountries(APIAtlas.getCountryList + SessionManager.accessToken(), productId: productId, actionHandler: { (successful, responseObject, requestErrorType) -> Void in

            self.hud?.hide(true)
            
            if successful {
                var responseList: NSArray = (responseObject["data"] as? NSArray)!
                self.countryListModel = []
                if responseList.count != 0 {
                    
                    for response in responseList {
                        self.countryListModel.append(CountryListModel.parseDataWithDictionary(response))
                    }
                    
                } else {
                    println("No countries.")
                }
                
                self.populateData()
                
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
            
        })
        
    }
    
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetCountries()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
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
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: - Empty View
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func didTapReload() {
        self.emptyView?.removeFromSuperview()
        if Reachability.isConnectedToNetwork() {
            
        } else {
            addEmptyView()
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryListModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CountryStoreTableViewCell = tableView.dequeueReusableCellWithIdentifier("countryId") as! CountryStoreTableViewCell
        cell.selectionStyle = .None
        
        cell.flagImageView.sd_setImageWithURL(NSURL(string: self.countryListModel[indexPath.row].flag))
        cell.countryLabel.text = self.countryListModel[indexPath.row].name
        if self.countryListModel[indexPath.row].isAvailable {
            cell.availableLabel.hidden = false
        }
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let countryStoreSetup: CountryStoreSetupViewController = CountryStoreSetupViewController(nibName: "CountryStoreSetupViewController", bundle: nil)
        countryStoreSetup.productId = self.productId
        countryStoreSetup.countryStoreModel = self.countryListModel[indexPath.row]
        self.navigationController?.pushViewController(countryStoreSetup, animated: true)
        
    }

}
