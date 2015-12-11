//
//  ChangeAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeAddressViewControllerDelegate {
    func updateStoreAddressDetail(title: String, storeAddress: String)
    func dismissView()
}

class ChangeAddressViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, CreateNewAddressViewControllerDelegate, AddAddressTableViewControllerDelegate {

    @IBOutlet weak var changeAddressCollectionView: UICollectionView!
   
    var cellCount: Int = 0
    var selectedIndex: Int = 0
    var defaultAddress: Int = 0
    var selectedAddressId: Int = 0
    var userId: Int = 0
    var index: NSIndexPath?
    
    var delegate: ChangeAddressViewControllerDelegate?
    
    var storeAddressModel: StoreAddressModel!
    var getAddressModel: GetAddressesModel!
    
    var dimView: UIView = UIView()
    
    var hud: MBProgressHUD?
    
    let changeAddressTitle: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_TITLE_LOCALIZE_KEY")
    let newAddress: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_NEW_ADDRESS_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let information: String = StringHelper.localizedStringWithKey("STORE_INFO_INFORMATION_TITLE_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dim view
        dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.edgesForExtendedLayout = .None
        
        self.titleView()
        self.backButton()
        
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
        
        self.regsiterNib()
        //self.fireSellerAddress()
        self.requestGetAddressess()
    }
    
    func titleView() {
        self.title = self.changeAddressTitle
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
    
    func fireSellerAddress(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreAddresses, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeAddressModel = StoreAddressModel.parseStoreAddressDataFromDictionary(responseObject as! NSDictionary)
            
            self.cellCount = self.storeAddressModel!.title.count
            println(self.storeAddressModel!.store_address.count)
            for var num  = 0; num < self.storeAddressModel?.title.count; num++ {
                if self.storeAddressModel.is_default[num]{
                    //self.selectedIndex = num
                    self.defaultAddress = num
                }
            }
            
            self.changeAddressCollectionView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
        })
    }
    
    func requestGetAddressess() {
        self.showHUD()
        
        let params = ["access_token": SessionManager.accessToken()]
        
        var manager = APIManager.sharedInstance
        
        manager.POST(APIAtlas.sellerStoreAddresses, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.getAddressModel = GetAddressesModel.parseDataWithDictionary(responseObject)
            self.cellCount = self.getAddressModel.listOfAddress.count
            for var num  = 0; num < self.getAddressModel.listOfAddress.count; num++ {
                if self.getAddressModel.listOfAddress[num].isDefault {
                    self.defaultAddress = num
                }
            }
            self.changeAddressCollectionView.reloadData()
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Get)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(title: self.error, message: errorModel.message)
                    } else {
                        self.showAlert(title: self.somethingWentWrong, message: nil)
                    }
                }
                self.hud?.hide(true)
        })
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
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10

        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
       fireSetDefaultStoreAddress()
    }
    
    func fireSetDefaultStoreAddress(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "userAddressId" : self.selectedAddressId];
        
        manager.POST(APIAtlas.sellerSetDefaultStoreAddress, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            if responseObject["isSuccessful"] as! Bool {
                self.showAlert(title: self.information, message: responseObject["message"] as! String)
                self.delegate?.updateStoreAddressDetail(self.getAddressModel.listOfAddress[self.defaultAddress].title, storeAddress:self.getAddressModel.listOfAddress[self.defaultAddress].fullLocation)
                self.navigationController!.popViewControllerAnimated(true)
            } else {
                self.showAlert(title: self.error, message: self.somethingWentWrong)
            }
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Create)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(title: self.error, message: errorModel.message)
                    } else {
                        self.showAlert(title: self.somethingWentWrong, message: nil)
                    }
                }
                self.hud?.hide(true)
        })
    }

    func regsiterNib() {
        let changeAddressNib: UINib = UINib(nibName: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeAddressCollectionView.registerNib(changeAddressNib, forCellWithReuseIdentifier: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier)
        
        let collectionViewFooterNib: UINib = UINib(nibName: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeAddressCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
        self.changeAddressCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        println("\(self.getAddressModel)")
        if self.getAddressModel != nil {
                /* cell.titleLabel.text = self.storeAddressModel!.title[indexPath.row]
                
                cell.subTitleLabel.text = self.storeAddressModel!.store_address[indexPath.row]
                cell.titleLabel.tag = self.storeAddressModel.user_address_id[indexPath.row]
                self.selectedIndex = indexPath.row
                */
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
       // self.selectedIndex = indexPath.row
       // self.changeAddressCollectionView.reloadData()
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.addressModel = self.getAddressModel.listOfAddress[indexPath.row]
        addAddressTableViewController.isEdit = true
        addAddressTableViewController.isEdit2 = true
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.changeAddressCollectionView.indexPathForCell(cell)!
        self.userId = cell.titleLabel.tag
        self.index = indexPath
        //if self.getAddressModel.listOfAddress[self.defaultAddress].isDefault {
        //    self.showAlert(title: StringHelper.localizedStringWithKey("STORE_INFO_DELETE_LOCALIZE_KEY"), message: nil)
        //} else {
            fireDeleteStoreAddress(cell.titleLabel.tag, indexPath: indexPath)
        //}
        
    }

    func checkAddressCollectionViewCell(checkAdressWithCell cell: ChangeAddressCollectionViewCell){
        println("check address \(cell.titleLabel.text)")
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: ChangeAddressFooterCollectionViewCell = self.changeAddressCollectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressFooterCollectionViewCell
        footerView.newAddressButton.setTitle(self.newAddress, forState: UIControlState.Normal)
        
        footerView.delegate = self
        
        return footerView
    }
    
    func fireDeleteStoreAddress(userAddressId: Int, indexPath: NSIndexPath){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "userAddressId" : NSNumber(integer: userAddressId)];
        
        manager.POST(APIAtlas.sellerDeleteStoreAddress, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            if responseObject["isSuccessful"] as! Bool {
                self.showAlert(title: self.information, message: responseObject["message"] as! String)
                self.deleteCellInIndexPath(indexPath)
                self.changeAddressCollectionView.reloadData()
            } else {
                self.showAlert(title: self.information, message: responseObject["message"] as! String)
            }
            
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                println(task.statusCode)
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Delete)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(title: self.error, message: errorModel.message)
                    } else {
                        self.showAlert(title: self.somethingWentWrong, message: nil)
                    }
                }
                self.hud?.hide(true)
        })
    }
    
    func requestRefreshToken(type: AddressRefreshType) {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if type == AddressRefreshType.Get {
                self.requestGetAddressess()
            } else if type == AddressRefreshType.Create {
                self.fireSetDefaultStoreAddress()
            } else {
                self.fireDeleteStoreAddress(self.userId, indexPath: self.index!)
            }
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else {
                    self.showAlert(title: self.somethingWentWrong, message: nil)
                }
                self.hud?.hide(true)
        })
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell) {
        /*let indexPath: NSIndexPath = NSIndexPath(forItem: self.cellCount, inSection: 0)
        self.addCellInIndexPath(indexPath)*/
        /*
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
        
        var attributeModal = CreateNewAddressViewController(nibName: "CreateNewAddressViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
*/
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.isEdit = false
        addAddressTableViewController.isEdit2 = false
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController) {
        self.requestGetAddressess()
        //self.fireSellerAddress()
    }
    
    func updateCollectionView(){
        fireSellerAddress()
        self.changeAddressCollectionView.reloadData()
    }
    
    func dismissDimView() {
        dimView.hidden = true
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
        })

    }

}
