//
//  LanguageTranslationTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class LanguageTranslationTableViewController: UITableViewController {
    
    var headerTitles = ["", "Product Name", "Short Description", "Complete Description", "Product Variants"]
    
    var productId: String = ""
    var productLanguage: ProductLanguageModel = ProductLanguageModel(languageId: 0)
    
    var defaultDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    var targetDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    
    var hud: MBProgressHUD?
    
    var productVariantsTapGesture: UITapGestureRecognizer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializesViews()
        self.registerNibs()
        self.addBackButton()
        
        productVariantsTapGesture = UITapGestureRecognizer(target: self, action: "productVariantsTap:")
        
        self.fireGetProductTranslation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Add table view footer
        var footerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 70))
        footerView.backgroundColor = UIColor.clearColor()
        
        var saveButton: UIButton = UIButton(frame: CGRectMake(16, 10, (self.view.bounds.width - 32), 50))
        saveButton.setTitle("SAVE TRANSLATION", forState: .Normal)
        saveButton.titleLabel?.font = UIFont(name: "Panton-Regular", size: 16)
        saveButton.backgroundColor = Constants.Colors.pmYesGreenColor
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.layer.cornerRadius = 5
        saveButton.addTarget(self, action: "saveButtonAction:", forControlEvents: .TouchUpInside)
        footerView.addSubview(saveButton)
        
        self.tableView.tableFooterView = footerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("TRANSLATION_TITLE")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.estimatedRowHeight = 150.0

    }
    
    func registerNibs() {
        var translationImagesNib = UINib(nibName: TranslationImagesTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(translationImagesNib, forCellReuseIdentifier: TranslationImagesTableViewCell.reuseIdentifier)
        
        var translationInputNib = UINib(nibName: TranslationInputTableViewCell.reuseIdetifier, bundle: nil)
        self.tableView.registerNib(translationInputNib, forCellReuseIdentifier: TranslationInputTableViewCell.reuseIdetifier)
        
        var translationProductGroupNib = UINib(nibName: TranslationProductGroupTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(translationProductGroupNib, forCellReuseIdentifier: TranslationProductGroupTableViewCell.reuseIdentifier)
    }
    
    func addBackButton() {
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
    
    //MARK: -Save Button Action
    func saveButtonAction(sender: UIButton) {
        self.fireSaveTranslations()
    }
    
    //MARK: - Product Variants Tap Action
    func productVariantsTap(gestureRecognizer: UIGestureRecognizer) {
        if defaultDetails.productVariants.count == 0 {
            Toast.displayToastWithMessage(StringHelper.localizedStringWithKey("TRANSLATION_NO_VARIANTS"), duration: 1.5, view: self.navigationController!.view)
        } else {
            let languageTranslation = LanguageTransalationVariantsCollectionViewController(nibName: "LanguageTransalationVariantsCollectionViewController", bundle: nil)
            languageTranslation.defaultDetails = self.defaultDetails
            languageTranslation.targetDetails = self.targetDetails
            languageTranslation.delegate = self
            self.navigationController?.pushViewController(languageTranslation, animated: true)
        }
    }
    
    
    //MARK: - Util Function
    //Loader function
    func showLoader() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.navigationController!.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(TranslationImagesTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! TranslationImagesTableViewCell
            
            cell.delegate = self
            if self.targetDetails.productImages.count == 0 {
                cell.setProductImages(self.defaultDetails.productImages)
            } else {
                cell.setProductImages(self.targetDetails.productImages)
            }
            
            cell.selectionStyle = .None
            return cell
        } else {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(TranslationInputTableViewCell.reuseIdetifier, forIndexPath: indexPath) as! TranslationInputTableViewCell
            cell.selectionStyle = .None
            cell.section = indexPath.section
            cell.delegate = self
            
            if indexPath.section == 1 {
                cell.defaultLanguageTextView.text = self.defaultDetails.name
                cell.translationTextView.text = self.targetDetails.name
            } else if indexPath.section == 2 {
                cell.defaultLanguageTextView.text = self.defaultDetails.shortDescription
                cell.translationTextView.text = self.targetDetails.shortDescription
            } else if indexPath.section == 3 {
                cell.defaultLanguageTextView.text = self.defaultDetails.productDescription
                cell.translationTextView.text = self.targetDetails.productDescription
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 35
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
            headerView.backgroundColor = UIColor.whiteColor()
            
            var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 0, (self.view.bounds.width - 48), 35))
            headerTextLabel.textColor = Constants.Colors.grayText
            headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
            headerTextLabel.text = self.headerTitles[section]
            headerView.addSubview(headerTextLabel)
            
            if section == 4 {
                var headerImageView: UIImageView = UIImageView(frame: CGRectMake((self.view.bounds.width - 32), 8, 16, 20))
                headerImageView.image = UIImage(named: "angle-right")
                headerImageView.contentMode = UIViewContentMode.ScaleAspectFit
                headerImageView.clipsToBounds = true
                headerView.addSubview(headerImageView)
                
                headerView.addGestureRecognizer(self.productVariantsTapGesture!)
            }
            
            return headerView
        } else {
            return UIView(frame: CGRectZero)
        }
    }
    
    //MARK: -
    //MARK: - Fire Get Product Translation
    func fireGetProductTranslation() {
        self.showLoader()
        let url: String = "\(APIAtlas.V3)/\(self.productLanguage.countryCode)/\(self.productLanguage.languageCode)/\(APIAtlas.productTranslation)"
        WebServiceManager.fireGetProductTranslationRequestWithUrl(url, productId: self.productId, access_token: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            println(responseObject)
            if successful {
                let data = ParseHelper.dictionary(responseObject, key: "data", defaultValue: NSDictionary())
                self.defaultDetails = ProductTranslationDetailsModel.parseDataWithDictionary(ParseHelper.dictionary(data, key: "default", defaultValue: NSDictionary()))
                self.targetDetails = ProductTranslationDetailsModel.parseDataWithDictionary(ParseHelper.dictionary(data, key: "target", defaultValue: NSDictionary()))
                
                if self.targetDetails.productImages.count == 0 {
                    self.targetDetails.productImages = self.defaultDetails.productImages
                }
                
                self.tableView.reloadData()
            } else {
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(true, type: "get")
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.navigationController!.view)
                }
                
            }
        }
    }
    
    // MARK: API Calls
    func fireSaveTranslations() {
        self.showLoader()
        
        var images: [[String: AnyObject]] = []
        for(var i = 0; i < self.targetDetails.productImages.count; i++) {
            let img = self.targetDetails.productImages[i]
            images.append(["name": img.raw, "isPrimary": img.isPrimary])
        }
        
        var variants: [[String: AnyObject]] = []
        for(var i = 0; i < self.targetDetails.productVariants.count; i++) {
            let temp = self.targetDetails.productVariants[i]
            var tempVar: [[String: AnyObject]] = []
            
            for(var j = 0; j < temp.values.count; j++) {
                let values = temp.values[j]
                tempVar.append(["id": values.id, "value": values.value])
            }
            
            variants.append(["id": temp.id, "name": temp.name, "values": tempVar])
            
        }
        
        let url: String = "\(APIAtlas.V3)/\(self.productLanguage.countryCode)/\(self.productLanguage.languageCode)/\(APIAtlas.translateProduct)"
        
        WebServiceManager.firePostTranslate(url, productId: self.productId, name: self.targetDetails.name, shortDescription: self.targetDetails.shortDescription, description: self.targetDetails.productDescription, productImages: StringHelper.convertArrayToJsonString(images), productVariants: StringHelper.convertArrayToJsonString(variants), access_token: SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            println(responseObject)
            self.dismissLoader()
            
            if successful {
                
                Toast.displayToastWithMessage("You have successfully transalated the product!", duration: 1.5, view: self.navigationController!.view)
                
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(true, type: "post")
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.navigationController!.view)
                }
            }
        })
    }
    
    func fireRefreshToken(showHud: Bool, type: String) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if type == "get" {
                    self.fireGetProductTranslation()
                } else if type == "post" {
                    self.fireSaveTranslations()
                }
                
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
}

extension LanguageTranslationTableViewController: TranslationInputTableViewCellDelegate {
    func translationInputTableViewCell(cell: TranslationInputTableViewCell, onTextChanged textView: UITextView, section: Int) {
        if section == 1 {
            self.targetDetails.name = textView.text
        } else if section == 2 {
            self.targetDetails.shortDescription = textView.text
        } else if section == 3 {
            self.targetDetails.productDescription = textView.text
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension LanguageTranslationTableViewController: TranslationProductGroupTableViewCellDelegate {
    func translationProductGroupTableViewCell(cell: TranslationProductGroupTableViewCell, onTextChanged textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension LanguageTranslationTableViewController: LanguageTransalationVariantsCollectionViewControllerDelegate {
    func languageTransalationVariantsCollectionViewController(controller: LanguageTransalationVariantsCollectionViewController, targetTranslation: ProductTranslationDetailsModel) {
        self.targetDetails = targetTranslation
    }
}

extension LanguageTranslationTableViewController: TranslationImagesTableViewCellDelegate{
    func translationImagesTableViewCell(cell: TranslationImagesTableViewCell, didImagesValuesChanged images: [ProductTranslationImageModel]) {
        self.targetDetails.productImages = images
    }
}
