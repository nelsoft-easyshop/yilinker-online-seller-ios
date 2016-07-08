//
//  ChangeAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

//MARK: Delegate
//ChangeAddressViewController Delegate methods
protocol ChangeAddressViewControllerDelegate {
    func updateStoreAddressDetail(title: String, storeAddress: String)
    func dismissView()
}

class ChangeAddressViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, CreateNewAddressViewControllerDelegate, AddAddressTableViewControllerDelegate {

    //Collection view
    @IBOutlet weak var changeAddressCollectionView: UICollectionView!
    
    //Strings
    let changeAddressTitle: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_TITLE_LOCALIZE_KEY")
    let newAddress: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_NEW_ADDRESS_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let information: String = StringHelper.localizedStringWithKey("STORE_INFO_INFORMATION_TITLE_LOCALIZE_KEY")
    
    //Models declaration
    var storeAddressModel: StoreAddressModel!
    var getAddressModel: GetAddressesModel!
    
    //Global variables declaration
    var dimView: UIView = UIView()
    var hud: MBProgressHUD?
    
    var cellCount: Int = 0
    var selectedIndex: Int = 0
    var defaultAddress: Int = 0
    var selectedAddressId: Int = 0
    var userId: Int = 0
    var index: NSIndexPath?
    
    //Initialized ChangeAddressViewControllerDelegate
    var delegate: ChangeAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.initializedCollectionView()
        self.initializedDimView()
        self.titleView()
        self.backButton()
        self.regsiterNib()
        self.requestGetAddressess()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Dismiss dim view
    func dismissDimView() {
        dimView.hidden = true
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
        })
        
    }
    
    //Initialized collectiion view
    func initializedCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.changeAddressCollectionView.frame.size.width, 41)
        changeAddressCollectionView.collectionViewLayout = layout
        changeAddressCollectionView.dataSource = self
        changeAddressCollectionView.delegate = self
        
        if IphoneType.isIphone5(){
            layout.itemSize = CGSize(width: self.view.frame.size.width - 100, height: 79)
        } else if IphoneType.isIphone5() {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 80, height: 79)
        } else {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        }
    }
    
    //Initialized dim view
    func initializedDimView() {
        dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
    }
    
    //MARK: Register nib files
    func regsiterNib() {
        let changeAddressNib: UINib = UINib(nibName: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeAddressCollectionView.registerNib(changeAddressNib, forCellWithReuseIdentifier: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier)
        
        let collectionViewFooterNib: UINib = UINib(nibName: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeAddressCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
        self.changeAddressCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
    }

    //MARK: Show Alert view
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Show hud
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
    
    //Set title of navigation bar
    func titleView() {
        self.title = self.changeAddressTitle
    }
    
    func updateCollectionView(){
        fireSellerAddress()
        self.changeAddressCollectionView.reloadData()
    }
    
    //MARK: Delegate Methods
    func addCellInIndexPath(indexPath: NSIndexPath) {
        self.cellCount++
        self.changeAddressCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        if cellCount != 0 {
            self.cellCount = self.cellCount - 1
        }
        
        self.changeAddressCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    //MARK: Navigation Bar - Set button of navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]        
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10

        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    //Navigation bar methods
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
       fireSetDefaultStoreAddress()
    }

    //MARK: Collection view Delegate Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        
        if self.getAddressModel != nil {
            cell.titleLabel.text = self.getAddressModel.listOfAddress[indexPath.row].title
            
            cell.subTitleLabel.text = self.getAddressModel.listOfAddress[indexPath.row].fullLocation
            cell.titleLabel.tag = self.getAddressModel.listOfAddress[indexPath.row].userAddressId
            self.selectedIndex = indexPath.row
            if self.defaultAddress == indexPath.row {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
                cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
                cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
            } else {
                cell.checkBoxButton.setImage(nil, forState: UIControlState.Normal)
                cell.checkBoxButton.layer.borderWidth = 1
                cell.checkBoxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.checkBoxButton.backgroundColor = UIColor.clearColor()
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
            
            cell.layer.cornerRadius = 5
            cell.delegate = self
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.addressModel = self.getAddressModel.listOfAddress[indexPath.row]
        addAddressTableViewController.isEdit = true
        addAddressTableViewController.isEdit2 = true
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: ChangeAddressFooterCollectionViewCell = self.changeAddressCollectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressFooterCollectionViewCell
        footerView.newAddressButton.setTitle(self.newAddress, forState: UIControlState.Normal)
        
        footerView.delegate = self
        
        return footerView
    }
    
    //MARK: ChangeAddressCollectionViewCell Delegate Methods
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.changeAddressCollectionView.indexPathForCell(cell)!
        self.userId = cell.titleLabel.tag
        self.index = indexPath
        fireDeleteStoreAddress(cell.titleLabel.tag, indexPath: indexPath)
    }

    func checkAddressCollectionViewCell(checkAdressWithCell cell: ChangeAddressCollectionViewCell){
        let indexPath: NSIndexPath = self.changeAddressCollectionView.indexPathForCell(cell)!
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
        cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
        cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
       
        self.defaultAddress = indexPath.row
        self.selectedAddressId = cell.titleLabel.tag
        
        cell.layer.cornerRadius = 5
        cell.delegate = self
        self.changeAddressCollectionView.reloadData()
        self.selectedIndex = indexPath.row
    }
    
    //MARK: ChangeAddressFooterCollectionViewCell Delegate Methods
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell) {
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.isEdit = false
        addAddressTableViewController.isEdit2 = false
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    //MARK: AddAddressTableViewController Delegate Method
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController) {
        self.requestGetAddressess()
    }
    
    //MARK: -
    //MARK: - Rest API Request
    //MARK: POST METHOD - Delete address of seller
    /*
    *
    * (Parameters) - access_token, userAddressId
    *
    * Function to delete address of seller
    */
    func fireDeleteStoreAddress(userAddressId: Int, indexPath: NSIndexPath){
        
        self.showHUD()
        
        //Set parameter of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "userAddressId" : NSNumber(integer: userAddressId)]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerDeleteStoreAddress, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.showAlert(title: self.information, message: responseObject["message"] as! String)
                self.deleteCellInIndexPath(indexPath)
                self.changeAddressCollectionView.reloadData()
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Delete)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }

    //MARK: POST METHOD - Set default address of seller
    /*
    *
    * (Parameters) - access_token, userAddressId
    *
    * Function to set the default address of seller
    */
    func fireSetDefaultStoreAddress(){
        
        self.showHUD()
        
        //Set parameter of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "userAddressId" : self.selectedAddressId];
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerSetDefaultStoreAddress, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
//                self.showAlert(title: self.information, message: responseObject["message"] as! String)
                self.delegate?.updateStoreAddressDetail(self.getAddressModel.listOfAddress[self.defaultAddress].title, storeAddress:self.getAddressModel.listOfAddress[self.defaultAddress].fullLocation)
                self.navigationController!.popViewControllerAnimated(true)
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Create)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }

    //MARK: POST METHOD - Fire Seller Address
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get seller's address
    */
    func fireSellerAddress(){
        
        self.showHUD()
        
        //Set parameter of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerStoreAddresses, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.storeAddressModel = StoreAddressModel.parseStoreAddressDataFromDictionary(responseObject as! NSDictionary)
                
                self.cellCount = self.storeAddressModel!.title.count
                
                for i in 0..<self.storeAddressModel!.title.count {
                    if self.storeAddressModel.is_default[i]{
                        self.defaultAddress = i
                    }
                }
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    //Call method 'fireRefreshToken' if the token is expired
                    self.requestRefreshToken(AddressRefreshType.SellerAddress)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }
    
    //MARK: POST METHOD - Request get address
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get seller's address
    */
    func requestGetAddressess() {
        
        self.showHUD()
        
        //Set parameter of POST Method
        let parameters = ["access_token": SessionManager.accessToken()]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerStoreAddresses, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.getAddressModel = GetAddressesModel.parseDataWithDictionary(responseObject)
                
                self.cellCount = self.getAddressModel.listOfAddress.count
                
                for i in 0..<self.getAddressModel.listOfAddress.count {
                    if self.getAddressModel.listOfAddress[i].isDefault {
                        self.defaultAddress = i
                    }
                }
                
                if self.getAddressModel.listOfAddress.count == 1 {
                    self.selectedAddressId = self.getAddressModel.listOfAddress[0].userAddressId
                }
                
                self.changeAddressCollectionView.reloadData()
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    //Call method 'fireRefreshToken' if the token is expired
                    self.requestRefreshToken(AddressRefreshType.Get)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }

    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token
    */
    func requestRefreshToken(type: AddressRefreshType) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameter of POST METHOD
        let parameter: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameter, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if type == AddressRefreshType.Get {
                self.requestGetAddressess()
            } else if type == AddressRefreshType.Create {
                self.fireSetDefaultStoreAddress()
            } else if type == AddressRefreshType.SellerAddress {
                self.fireSellerAddress()
            } else {
                self.fireDeleteStoreAddress(self.userId, indexPath: self.index!)
            }
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                //Catch unsuccessful return from API
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    //Parse error messages from API return
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else {
                    self.showAlert(title: self.somethingWentWrong, message: nil)
                }
                self.hud?.hide(true)
        })
    }

}
