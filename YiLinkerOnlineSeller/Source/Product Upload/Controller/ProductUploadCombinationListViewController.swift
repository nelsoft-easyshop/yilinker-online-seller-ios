//
//  ProductUploadCombinationListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable declarations
struct PUCLVCConstant {
    static let productUploadCombinationHeaderTableViewCellNibNameAndIdentifier = "ProductUploadCombinationHeaderTableViewCell"
    static let productUploadCombinationTableViewCellNibNameAndIdentifier = "ProductUploadCombinationTableViewCell"
    static let productUploadCombinationFooterTableViewCellNibNameAndIdentifier = "ProductUploadCombinationFooterTableViewCell"
    static let productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeValluesCollectionViewCell"
    static let productUploadPlainCombinationTableViewCellNibNameAndIdentifier = "ProductUploadPlainDetailCombinationTableViewCell"
}

class ProductUploadCombinationListViewController: UIViewController, ProductUploadAddFooterViewDelegate, ProductUploadCombinationTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, PUAttributeSetHeaderTableViewCellDelegate {

    // Button
    @IBOutlet weak var footerButton: UIButton!
    
    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var productModel: ProductModel?
    
    //  Global variable
    var isValidSku: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title
        self.title = Constants.ViewControllersTitleString.attributeCombination
        self.footerView()
        self.backButton()
        self.registerCell()
        
        let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.changeButtonName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button action
    @IBAction func saveDetails(sender: AnyObject) {
        if self.productModel!.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.combinationRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else {
            let productUploadTableViewController: ProductUploadTC
            = self.navigationController?.viewControllers[0] as! ProductUploadTC
            productUploadTableViewController.replaceProductAttributeWithAttribute(self.productModel!.attributes, combinations: self.productModel!.validCombinations)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    // MARK: -
    // MARK: - Navigation bar
    // MARK: - Add back button in navigation bar
    
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
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Change button name
    
    func changeButtonName() {
        if self.productModel!.validCombinations.count == 0 {
            self.footerButton.backgroundColor = Constants.Colors.transactionGrey
            self.footerButton.userInteractionEnabled = false
        } else {
            self.footerButton.backgroundColor = Constants.Colors.selectedGreenColor
            self.footerButton.userInteractionEnabled = true
        }
        
        self.footerButton.setTitle(ProductUploadStrings.saveProductDetails, forState: UIControlState.Normal)
    }
    
    // MARK: -
    // MARK: - Private methods
    // MARK: - Add footer in tableview
    
    func footerView() {
        let addMoreTableViewFooter: ProductUploadAddFooterView = XibHelper.puffViewWithNibName("ProductUploadAddFooterView", index: 0) as! ProductUploadAddFooterView
        addMoreTableViewFooter.delegate = self
        self.tableView.tableFooterView = addMoreTableViewFooter
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerCell() {
        let footerNib: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(footerNib, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier)
        
        let combinationCell: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationCell, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier)
        
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(valuesNib, forCellReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
        
        let combinationPlainNib: UINib = UINib(nibName: PUCLVCConstant.productUploadPlainCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationPlainNib, forCellReuseIdentifier: PUCLVCConstant.productUploadPlainCombinationTableViewCellNibNameAndIdentifier)
        
        let nib: UINib = UINib(nibName: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier)
        
        let weightAndHeightNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(weightAndHeightNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier)
        
        let skuDimensionsAndWeightNib: UINib = UINib(nibName: ProductUploadCombinationFooterTVCConstant.productUploadCombinationFooterTVCNibAndIdentifier, bundle: nil)
        self.tableView.registerNib(skuDimensionsAndWeightNib, forCellReuseIdentifier: ProductUploadCombinationFooterTVCConstant.productUploadCombinationFooterTVCNibAndIdentifier)
    }
    
    // MARK: -
    // MARK: - Table view data source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.productModel!.validCombinations.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 41
        } else if indexPath.row == 1 {
            let rowHeight: CGFloat = 95
            let rowInitialHeight: CGFloat = 14
            
            var attributes: [AttributeModel] = []
            for dictionary in  self.productModel!.validCombinations[indexPath.section].attributes as [NSMutableDictionary] {
                let attributeModel: AttributeModel = AttributeModel()
                attributeModel.definition = dictionary["name"] as! String
                attributeModel.values = [dictionary["value"] as! String]
                attributes.append(attributeModel)
            }
            
            let cellCount: Int = attributes.count
            
            
            var numberOfRows: CGFloat = CGFloat(cellCount) / 2
            
            if numberOfRows == 0 {
                numberOfRows = 1
            } else if floor(numberOfRows) != numberOfRows {
                numberOfRows++
            }
            
            var dynamicHeight: CGFloat = floor(numberOfRows) * rowHeight
            
            var cellHeight: CGFloat = rowInitialHeight + dynamicHeight
            
            return cellHeight
        } else {
            return 294
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PUAttributeSetHeaderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier) as! PUAttributeSetHeaderTableViewCell
            cell.delegate = self
            cell.attributeDefinitionLabel!.text = "\(ProductUploadStrings.combination) \(indexPath.section + 1)"
            
            return cell
        } else if indexPath.row == 1 {
            let cell: ProductUploadCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationTableViewCell
            
            var attributes: [AttributeModel] = []
            for dictionary in  self.productModel!.validCombinations[indexPath.section].attributes as [NSMutableDictionary] {
                let attributeModel: AttributeModel = AttributeModel()
                attributeModel.definition = dictionary["name"] as! String
                attributeModel.values = [dictionary["value"] as! String]
                attributes.append(attributeModel)
            }
            
            cell.attributes = attributes
            cell.collectionView.reloadData()
            cell.userInteractionEnabled = false
            
            return cell
        } else {
            
            let cell: ProductUploadCombinationFooterTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadCombinationFooterTVC") as! ProductUploadCombinationFooterTVC
            cell.isPreview = true
            
            if self.productModel != nil {
                
                let combination: CombinationModel = self.productModel!.validCombinations[indexPath.section]
                
                let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
                
                if viewController.uploadType == UploadType.NewProduct {
                    cell.images = combination.images
                } else {
                    println(self.productModel!.editedImage)
                    var combiImages: [ServerUIImage] = []
                    for (index, image) in enumerate(combination.editedImages) {
                        for (index2, mainImage) in enumerate(self.productModel!.editedImage) {
                            if mainImage.uid == image.uid {
                                if !contains(combiImages, combination.editedImages[index]) {
                                    combiImages.append(combination.editedImages[index])
                                }
                            }
                        }
                    }
                    combination.editedImages = combiImages
                    cell.images = combination.editedImages
                }
                
                cell.collectionView.reloadData()
                
                cell.userInteractionEnabled = false
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.skuTextField.text = combination.sku
                cell.weightTextField.text = combination.weight
                cell.lengthTextField.text = combination.length
                cell.heightTextField.text = combination.height
                cell.widthTextField.text = combination.width
                cell.availableSwitch.setOn(combination.isAvailable, animated: true)
                
            }
            
            return cell
        }
    }
    
    // MARK: -
    // MARK: - Add More: ProductUploadAddFooterView Delegate Method
    
    func productUploadAddFooterView(didSelectAddMore view: UIView) {
        let productUploadCombinationTableViewController: ProductUploadCombinationTableViewController = ProductUploadCombinationTableViewController(nibName: "ProductUploadCombinationTableViewController", bundle: nil)
        productUploadCombinationTableViewController.attributes = self.productModel!.attributes
        productUploadCombinationTableViewController.delegate = self
        productUploadCombinationTableViewController.productModelCombi = self.productModel!
        var counter: Int = 0
        if self.productModel != nil {
           counter = self.productModel!.validCombinations.count
        }
        
        productUploadCombinationTableViewController.headerTitle = "\(ProductUploadStrings.combination) \(counter + 1)"
        self.navigationController?.pushViewController(productUploadCombinationTableViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Add Combination: ProductUploadCombinationTableViewController Delegate method
    
    func productUploadCombinationTableViewController(appendCombination combination: CombinationModel, isEdit: Bool, indexPath: NSIndexPath) {
        
        var isValidCombination: Bool = true
        
        if self.productModel != nil && !isEdit {
            for combinationLoop in self.productModel!.validCombinations {
                if combinationLoop.attributes == combination.attributes {
                    isValidCombination = false
                    break
                }
            }
        }
        
        if isValidCombination {
            
            let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
            
            if viewController.uploadType == UploadType.NewProduct {
                if !isEdit {
                    self.productModel!.validCombinations.append(combination)
                } else {
                    self.productModel!.validCombinations[indexPath.section] = combination
                }
            } else {
                combination.editedImages.removeAll(keepCapacity: false)
                for webImage in combination.images {
                    if let image = webImage as? ServerUIImage {
                        combination.editedImages.append(image)
                    } else {
                        let imageData: NSData = UIImagePNGRepresentation(webImage)
                        var imageServer: ServerUIImage = ServerUIImage(data: imageData)!
                        combination.editedImages.append(imageServer)
                    }
                }
                if !isEdit {
                    self.productModel!.validCombinations.append(combination)
                } else {
                    self.productModel!.validCombinations[indexPath.section] = combination
                }
            }
            
            self.tableView.reloadData()
        } else {
            if self.isValidSku {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.invalid, title: "SKU must be unique for each combination.")
            } else {
                 UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.combinationAlreadyExist, title: Constants.Localized.error)
            }
        }
    }
    
    // MARK: -
    // MARK: - Delete Combination: ProductUploadAttributeSetHeaderTableViewCell delegate methods
    
    func pUAttributeSetHeaderTableViewCell(didClickDelete cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let range: NSRange = NSMakeRange(indexPath.section, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        
        self.productModel!.validCombinations.removeAtIndex(indexPath.section)
        self.tableView.beginUpdates()
        self.tableView.deleteSections(section, withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    // MARK: -
    // MARK: - Edit Combination: ProductUploadAttributeSetHeaderTableViewCell delegate method
    
    func pUAttributeSetHeaderTableViewCell(didClickEdit cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
    
        let productUploadCombinationTableViewController: ProductUploadCombinationTableViewController = ProductUploadCombinationTableViewController(nibName: "ProductUploadCombinationTableViewController", bundle: nil)
        productUploadCombinationTableViewController.attributes = self.productModel!.attributes
        productUploadCombinationTableViewController.productModelCombi = self.productModel!
        productUploadCombinationTableViewController.productModel = self.productModel!.copy()
        productUploadCombinationTableViewController.selectedIndexpath = indexPath
        productUploadCombinationTableViewController.delegate = self
    
        var counter: Int = 0
        if self.productModel != nil {
            counter = self.productModel!.validCombinations.count
        }
    
        productUploadCombinationTableViewController.headerTitle = "\(ProductUploadStrings.combination) \(indexPath.section+1)"
    
        self.navigationController?.pushViewController(productUploadCombinationTableViewController, animated: true)
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
