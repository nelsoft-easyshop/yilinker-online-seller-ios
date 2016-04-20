//
//  ProductUploadTC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadTC: UITableViewController, ProductUploadUploadImageTVCDataSource, ProductUploadUploadImageTVCDelegate, ProductUploadTextFieldTableViewCellDelegate, ProductUploadTextViewTableViewCellDelegate, ProductUploadDimensionsAndWeightTableViewCellDelegate, ProductUploadFooterViewDelegate {
    
    // Variables
    var productModel: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Product Upload"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.addFooter()
        self.backButton()
        self.registerNib()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return 6
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 1 {
            //Product Information Section
            if indexPath.row == 0 {
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 1 {
                return ProductUploadTableViewControllerConstant.normalTextViewCellHeight
            } else {
                return ProductUploadTableViewControllerConstant.completeDescriptionHeight
            }
        } else if indexPath.section == 2 {
            return 75
        } else if indexPath.section == 3 {
            return 44
        } else {
            return 245
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ProductUploadImageTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadImageTVC") as! ProductUploadImageTVC
            cell.dataSource = self
            cell.delegate = self
            cell.collectionView.reloadData()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            // Configure the cell...
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.cellTitleLabel.text = ProductUploadStrings.productName
                cell.cellTitleLabel.required()
                cell.cellTexField.placeholder = ProductUploadStrings.productName
                cell.cellTexField.text = "Sample Product Name" //self.productModel.name
                cell.textFieldType = ProductTextFieldType.ProductName
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductShortDescription
                cell.cellTitleLabel.text = ProductUploadStrings.shortDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = "Sample short description" //self.productModel.shortDescription
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductCompleteDescription
                cell.cellTitleLabel.text = ProductUploadStrings.completeDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = "Sample Complete Description" //self.productModel.completeDescription
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            }
        }  else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.category
                cell.cellTexField.placeholder = ProductUploadStrings.selectCategory
                cell.cellTexField.text = "YiLinker Category" //self.productModel.category.name
                cell.textFieldType = ProductTextFieldType.Category
                
                cell.cellTexField.rightView = self.addRightView("cell-right")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.delegate = self
                cell.cellTitleLabel.required()
                
                /*
                if self.productModel.category.name != "" {
                    cell.cellTexField.text = self.productModel.category.name
                }
                */
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
               
                cell.cellTitleLabel.text = "Shipping Category" //ProductUploadStrings.brand
                cell.cellTexField.placeholder = "Select Category" //ProductUploadStrings.brand
                cell.delegate = self
                cell.cellTexField.text = "YiLinker Shipping Category" //self.productModel.brand.name
                
                cell.cellTexField.rightView = self.addRightView("cell-right")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.textFieldType = ProductTextFieldType.ShippingCategory
                cell.cellTitleLabel.required()
               
                /*
                if self.productModel.brand.name != "" {
                    cell.cellTexField.text = self.productModel.brand.name
                }
                */
                
                cell.addTextFieldDelegate()
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else if indexPath.row == 2 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.brand
                cell.cellTexField.placeholder = ProductUploadStrings.brand
                cell.delegate = self
                cell.cellTexField.text = "YiLinker Brand" //self.productModel.brand.name
                
                cell.cellTexField.rightView = self.addRightView("arrow_down")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.textFieldType = ProductTextFieldType.Brand
                
                /*
                if self.productModel.brand.name != "" {
                    cell.cellTexField.text = self.productModel.brand.name
                }
                */
                
                cell.addTextFieldDelegate()
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else if indexPath.row == 3 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.condition
                cell.cellTexField.placeholder = ProductUploadStrings.condition
                cell.textFieldType = ProductTextFieldType.Condition
                cell.delegate = self
                cell.cellTitleLabel.required()
                cell.cellTexField.text = "Condition" //self.productModel.condition.name
                
                cell.cellTexField.rightView = self.addRightView("arrow_down")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always

                /*
                var values: [String] = []
                
                if self.conditions.count != 0 {
                    for condition in self.conditions as [ConditionModel] {
                        values.append(condition.name)
                    }
                
                    if indexPath.row == 2 {
                        cell.values = values
                        cell.addPicker()
                    }
                }
                */
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else if indexPath.row == 4 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = "SKU[Stock Keeping Unit]"//ProductUploadStrings.condition
                cell.cellTexField.placeholder = "" //ProductUploadStrings.condition
                cell.textFieldType = ProductTextFieldType.ProductSKU
                cell.delegate = self
                cell.cellTexField.text = "SKU123" //self.productModel.condition.name
                cell.cellTitleLabel.required()
                
                /*
                var values: [String] = []
                
                if self.conditions.count != 0 {
                    for condition in self.conditions as [ConditionModel] {
                        values.append(condition.name)
                    }
                
                    if indexPath.row == 2 {
                        cell.values = values
                        cell.addPicker()
                    }
                }
                */
                
                cell.userInteractionEnabled = self.checkIfSeller()
                
                return cell
            } else {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
               
                cell.cellTitleLabel.text = "Product Group"//ProductUploadStrings.condition
                cell.cellTexField.placeholder = ""//ProductUploadStrings.condition
                cell.textFieldType = ProductTextFieldType.Condition
                cell.delegate = self
                cell.cellTexField.text = "Product Group" //self.productModel.condition.name
                
                /*
                var values: [String] = []
                
                if self.conditions.count != 0 {
                    for condition in self.conditions as [ConditionModel] {
                        values.append(condition.name)
                    }
                
                    if indexPath.row == 2 {
                        cell.values = values
                        cell.addPicker()
                    }
                }
                */
                
                cell.userInteractionEnabled = self.checkIfSeller()
            
                return cell
            }
        } else if indexPath.section == 3 {
            let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
            
            // TODO: Add delegate to button and add action to delegate methods
            cell.cellButton.setTitle("ADD MORE DETAILS ", forState: UIControlState.Normal)
            
            cell.userInteractionEnabled = self.checkIfSeller()
            
            return cell
        } else {
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell
            cell.delegate = self
            // TODO: Add delegate to textfields and add action to delegate methods
            cell.addTextFieldDelegate()
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ProductUploadTableHeaderView = XibHelper.puffViewWithNibName("ProductUploadTableHeaderView", index: 0) as! ProductUploadTableHeaderView
        
        if section == 1 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productInformation
        } else if section == 2 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productDetails
        } else if section == 3 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight //ProductUploadStrings.price
        } else if section == 4 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight //ProductUploadStrings.price
        } else if section == 5 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: CGFloat = 0
        
        if section == 0 {
            sectionHeight = 0
        } else if section == 3 {
            sectionHeight = 0
        } else if section == 4 {
            return 41
        } else {
            sectionHeight = 41
        }
        return sectionHeight
    }
    
    // MARK: -
    // MARK: - Local Methods
    // MARK: - Add table view footer
    
    func addFooter() {
        let footerView: ProductUploadFooterView = XibHelper.puffViewWithNibName("ProductUploadFooterView", index: 0) as! ProductUploadFooterView
        self.tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    // MARK: -
    // MARK: - Add right view in textfield
    
    func addRightView(image: String) -> UIImageView {
        let arrow = UIImageView(image: UIImage(named: image))
        arrow.frame = CGRectMake(0.0, 0.0, arrow.image!.size.width+10.0, arrow.image!.size.height)
        arrow.contentMode = UIViewContentMode.Center
        
        return arrow
    }
    
    // MARK: -
    // MARK: - Navigation bar: Add Back Button in navigation bar
    
    func backButton() {
        //ProductCroppedImages.imagesCropped.removeAll(keepCapacity: false)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        /*
        if self.productModel.name != "" {
            if ProductUploadCombination.draft {
                self.draft()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }*/
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 
    // MARK: Check if seller
    
    func checkIfSeller() -> Bool {
        if SessionManager.isSeller() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerNib() {
        let nib: UINib = UINib(nibName: "ProductUploadImageTVC", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ProductUploadImageTVC")
        
        let nibTextField: UINib = UINib(nibName: "ProductUploadTextFieldTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTextField, forCellReuseIdentifier: "ProductUploadTextFieldTableViewCell")
       
        let nibTextView: UINib = UINib(nibName: "ProductUploadTextViewTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTextView, forCellReuseIdentifier: "ProductUploadTextViewTableViewCell")
        
        let nibAddDetails: UINib = UINib(nibName: "ProductUploadButtonTableViewCell", bundle: nil)
        self.tableView.registerNib(nibAddDetails, forCellReuseIdentifier: "ProductUploadButtonTableViewCell")
        
        let nibDimensions: UINib = UINib(nibName: "ProductUploadDimensionsAndWeightTableViewCell", bundle: nil)
        self.tableView.registerNib(nibDimensions, forCellReuseIdentifier: "ProductUploadDimensionsAndWeightTableViewCell")
    }
    
    // MARK: - Product Upload Upload Image Table View Cell Delegate method
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadImageTVC) -> Int {
        /*if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage.count
        } else {
            return self.productModel.images.count
        }*/
        return 2

    }
    
    //MARK: - Upload Delegate
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadImageTVC) {
        println("tap image")
        /*if self.uploadType == UploadType.EditProduct {
            if indexPath.row == self.productModel.editedImage.count - 1 && self.productModel.editedImage.count <= 5 {
                let picker: UzysAssetsPickerController = UzysAssetsPickerController()
                let maxCount: Int = 6
                
                let imageLimit: Int = maxCount - self.productModel.images.count
                picker.delegate = self
                picker.maximumNumberOfSelectionVideo = 0
                picker.maximumNumberOfSelectionPhoto = 100
                UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
                self.presentViewController(picker, animated: true, completion: nil)
            }
            
        } else {
            if indexPath.row == self.productModel.images.count - 1 && self.productModel.images.count <= 5 {
                let picker: UzysAssetsPickerController = UzysAssetsPickerController()
                let maxCount: Int = 6
                
                let imageLimit: Int = maxCount - self.productModel.images.count
                picker.delegate = self
                picker.maximumNumberOfSelectionVideo = 0
                picker.maximumNumberOfSelectionPhoto = 100
                UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }*/
    }
    
    //MARK: - Product Upload Upload Image Table View Cell Delegate method
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView) {
        /*if self.uploadType == UploadType.EditProduct {
            if self.productModel.editedImage[indexPath.row].uid != "" {
                if !contains(self.deletedImagesId, self.productModel.editedImage[indexPath.row].uid) {
                    self.deletedImagesId.append(self.productModel.editedImage[indexPath.row].uid)
                }
            }
            self.productModel.editedImage.removeAtIndex(indexPath.row)
        } else {
            self.productModel.images.removeAtIndex(indexPath.row)
            ProductCroppedImages.imagesCropped.removeAtIndex(indexPath.row)
        }
        collectionView.deleteItemsAtIndexPaths([indexPath])*/
    }
    
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView) {
        cell.imageView.image = UIImage(named: "active")
        cell.starButton.setBackgroundImage(UIImage(named: "active2"), forState: UIControlState.Normal)
        collectionView.reloadData()
    }
    
    func productUploadUploadImageTableViewCell(images cell: ProductUploadImageTVC) -> [UIImage] {
        /*
        if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage
        } else {
            return self.productModel.images
        }*/
        var images: [UIImage] = []
        images.append(UIImage(named: "YiLinkerLogo")!)
        images.append(UIImage(named: "addPhoto")!)
        return images
    }
    
    // MARK: -
    // MARK: - ProductUploadTextFieldTableViewCell Delegate Methods
    
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextFieldTableViewCell, textFieldType: ProductTextFieldType) {
        println(text)
    }
    
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType) {
        println(text)
    }
    
    // MARK: -
    // MARK: - ProductUploadDimensionsAndWeightTableViewCell Delegate Method
    
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell) {
        
    }
    
    // MARK: - 
    // MARK: - ProductUploadFooterView Delegate Method
    // TODO: Add action to upload product details
    
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView) {
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
