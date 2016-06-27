//
//  ProductUploadCombinationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadCombinationTableViewCell: UITableViewCell {

    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Models
    var attributes: [AttributeModel] = []
    var productModel: ProductModel?
    
    // Global variables
    var selectedIndexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.registerCell()
        self.initializeCollectionView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private methods
    // Returns width and height of the collection view’s content
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
    }
    
    // Returns object of CombinationModel
    func data() -> CombinationModel {
        let combinationModel: CombinationModel = CombinationModel()
        let numberOfItems: Int = self.collectionView.numberOfItemsInSection(0)
        for var item = 0; item < numberOfItems; item++ {
            var dictionary: NSMutableDictionary = NSMutableDictionary()
            let indexPath: NSIndexPath = NSIndexPath(forItem: item, inSection: 0)
            let cell: ProductUploadAttributeValuesCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! ProductUploadAttributeValuesCollectionViewCell
            
            let definitionKey: String = "name"
            let valueKey: String = "value"
            
            dictionary[definitionKey] = cell.attributeDefinitionLabel.text
            dictionary[valueKey] = cell.attributeTextField.text
            combinationModel.attributes.append(dictionary)
        }
        
        return combinationModel
    }
    
    // Initialize collection view
    func initializeCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSizeMake(153, 80)
        
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            flowLayout.itemSize = CGSizeMake(132, 80)
        } else if IphoneType.isIphone6Plus() {
            flowLayout.itemSize = CGSizeMake(180, 80)
        }
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // Register collection cells
    func registerCell() {
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(valuesNib, forCellWithReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
    }
    
    // MARK: Collection view delegate and data source methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attributes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadAttributeValuesCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadAttributeValuesCollectionViewCell
        let attributeModel: AttributeModel = self.attributes[indexPath.row]
        
        cell.attributeDefinitionLabel.text = attributeModel.definition
        cell.attributeTextField.text = attributeModel.values[0]
        //cell.attributeTextField.userInteractionEnabled = false //comment this
        
        if self.productModel != nil {
            let dictionary: NSMutableDictionary = self.productModel!.validCombinations[selectedIndexPath!.section].attributes[indexPath.row]
            cell.attributeDefinitionLabel.text = dictionary["name"] as? String
            cell.attributeTextField.text  = dictionary["value"] as! String
        }
      
        cell.values = attributeModel.values
        cell.addPicker() // uncomment
        return cell
    }
    
    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
