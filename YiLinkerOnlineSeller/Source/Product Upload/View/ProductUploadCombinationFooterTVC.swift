//
//  ProductUploadCombinationFooterTVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadCombinationFooterTVCDelegate {
    func productUploadIsAvailableTableViewCell(switchValueChanged sender: UISwitch, value: Bool, cell:
        ProductUploadCombinationFooterTVC)
    func productUploadSkuDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell:
        ProductUploadCombinationFooterTVC)
    func productUploadCombinationFooterTVC(didClickUploadImage cell: ProductUploadCombinationFooterTVC)
    func productUploadCombinationFooterTVC(didDeleteUploadImage cell: ProductUploadCombinationFooterTVC, indexPath: NSIndexPath)
    func productUploadCombinationFooterTVC(didClickDoneButton cell: ProductUploadCombinationFooterTVC, sku: String, length: String, width: String, height: String, weight: String, uploadImages: [UIImage])
    
}

class ProductUploadCombinationFooterTVC: UITableViewCell, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ProductUploadImageCollectionViewCellDelegate {

    // CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Labels
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    // Switch
    @IBOutlet weak var availableSwitch: UISwitch!
    
    // Variables
    var viewController: UIViewController?
    
    // Global variables
    var images: [UIImage] = []
    var combiImages: [String] = []
    var isPreview: Bool = false
    
    var delegate: ProductUploadCombinationFooterTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTextFieldDelegate()
        self.registerCell()
        
        // Set labels texts
        self.lengthLabel.text = ProductUploadStrings.length
        self.heightLabel.text = ProductUploadStrings.height
        self.widthLabel.text = ProductUploadStrings.width
        self.weightLabel.text = ProductUploadStrings.weight
        
        // Append asterisk (*) in label's text
        // self.lengthLabel.required()
        // self.widthLabel.required()
        // self.heightLabel.required()
        // self.weightLabel.required()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func save(sender: AnyObject) {
        //if self.images.last == UIImage(named: "addPhoto") {
        self.images.removeLast()
        //}
        
        if self.lengthTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Lenght is required.", title: ProductUploadStrings.incompleteProductDetails)
        } else if self.widthTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Width is required.", title: ProductUploadStrings.incompleteProductDetails)
        } else if self.skuTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.skuRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else {
            if self.viewController != nil {
                viewController!.view.endEditing(true)
            }
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.delegate?.productUploadCombinationFooterTVC(didClickDoneButton: self, sku: self.skuTextField.text, length: self.lengthTextField.text, width: self.widthTextField.text, height: self.heightTextField.text, weight: self.weightTextField.text, uploadImages: self.images)
            }
        }
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender.on {
            println("on")
            self.delegate?.productUploadIsAvailableTableViewCell(switchValueChanged: sender, value: true, cell: self)
        } else {
            println("off")
            self.delegate?.productUploadIsAvailableTableViewCell(switchValueChanged: sender, value: false, cell: self)
        }
    }
    
    // MARK: Collection view delegate and data source methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        cell.delegate = self
        cell.imageView.image = self.images[indexPath.row]
        cell.starButton.hidden = true
        cell.tapToReuploadButton.hidden = true
        
        if self.isPreview {
            cell.closeButton.hidden = true
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        } else {
            if indexPath.row == self.images.count - 1 {
                cell.closeButton.hidden = true
                cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
            } else {
                cell.closeButton.hidden = false
                cell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.images.count - 1 {
            self.delegate?.productUploadCombinationFooterTVC(didClickUploadImage: self)
        }
    }
    
    // MARK: -
    // MARK: - Local methods
    // MARK: - Add textfield delegate actions
    
    func addTextFieldDelegate() {
        self.heightTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.heightTextField.delegate = self
        self.widthTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.widthTextField.delegate = self
        self.weightTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.weightTextField.delegate = self
        self.lengthTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.lengthTextField.delegate = self
        self.skuTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.skuTextField.delegate = self
    }
    
    // MARK: -
    // MARK: - Hide Keyboard
    
    func hideKeyboard() {
        //self.contentView.endEditing(true)
    }
    
    // MARK: -
    // MARK: - Register Cell
    
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    // MARK: -
    // MARK: - Uploaded Images
    
    func uploadedImages() -> [UIImage] {
        //self.images.removeLast()
        return self.images
    }
    
    func combiImagesName() -> [String] {
        return self.combiImages
    }
    
    // MARK: -
    // MARK: - Textfield data source methods
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadSkuDimensionsAndWeightTableViewCell(textFieldDidChange: sender, text: sender.text, cell: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    // MARK: ProductUploadImageCollectionViewCell Delegate method
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.images.removeAtIndex(indexPath.item)
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
        self.delegate!.productUploadCombinationFooterTVC(didDeleteUploadImage: self, indexPath: indexPath)
    }
    
    func productUploadImageCollectionViewCell(didTapStarButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        cell.starButton.setBackgroundImage(UIImage(named:"active2"), forState: UIControlState.Normal)
    }
    
    func productUploadImageCollectionViewCell(didTapReuploadButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        
    }
    
    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}