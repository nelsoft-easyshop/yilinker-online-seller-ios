//
//  LanguageTransalationVariantsCollectionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol LanguageTransalationVariantsCollectionViewControllerDelegate {
    func languageTransalationVariantsCollectionViewController(controller: LanguageTransalationVariantsCollectionViewController, targetTranslation: ProductTranslationDetailsModel)
}

class LanguageTransalationVariantsCollectionViewController: UICollectionViewController {
    
    var delegate: LanguageTransalationVariantsCollectionViewControllerDelegate?
    
    var defaultDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    var targetDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializesViews()
        self.addBackButton()
        self.registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("TRANSLATION_VARIANT_TITLE")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
    }
    
    func registerNibs() {
        
        var cellNib = UINib(nibName: LanguageVariantsCollectionViewCell.reuseIdentifier, bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: LanguageVariantsCollectionViewCell.reuseIdentifier)
        
        var header = UINib(nibName: LanguageVariantsHeaderCollectionReusableView.reuseIdentifier, bundle: nil)
        self.collectionView!.registerNib(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LanguageVariantsHeaderCollectionReusableView.reuseIdentifier)
        
        var footer = UINib(nibName: LanguageVariantsFooterCollectionReusableView.reuseIdentifier, bundle: nil)
        self.collectionView!.registerNib(footer, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LanguageVariantsFooterCollectionReusableView.reuseIdentifier)
        
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
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.defaultDetails.productVariants.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.defaultDetails.productVariants[section].values.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LanguageVariantsCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! LanguageVariantsCollectionViewCell
        
            cell.delegate = self
            cell.indexPath = indexPath
        cell.setVariant(self.targetDetails.productVariants[indexPath.section].values[indexPath.row].value, variantPlaceholder: self.defaultDetails.productVariants[indexPath.section].values[indexPath.row].value)
    
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        return CGSize(width: ((screenWidth / 2) - 20), height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section != (collectionView.numberOfSections() - 1) {
            return CGSizeZero
        } else {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            
            return CGSizeMake(screenWidth, 120)
        }
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: LanguageVariantsHeaderCollectionReusableView.reuseIdentifier, forIndexPath: indexPath) as! LanguageVariantsHeaderCollectionReusableView
            cell.delegate = self
            cell.indexPath = indexPath
            cell.setVariant(indexPath.section, variantName: self.targetDetails.productVariants[indexPath.section].name, variantNamePlaceholder: self.defaultDetails.productVariants[indexPath.section].name)
            return cell
        } else if kind == UICollectionElementKindSectionFooter {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: LanguageVariantsFooterCollectionReusableView.reuseIdentifier, forIndexPath: indexPath) as! LanguageVariantsFooterCollectionReusableView
            cell.delegate = self
            return cell
        } else {
            return UICollectionReusableView(frame: CGRectZero)
        }
    }
}

extension LanguageTransalationVariantsCollectionViewController: LanguageVariantsFooterCollectionReusableViewDelegate {
    func languageVariantsFooterCollectionReusableView(cell: LanguageVariantsFooterCollectionReusableView, onSaveButtonTap button: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        self.delegate?.languageTransalationVariantsCollectionViewController(self, targetTranslation: self.targetDetails)
    }
    
    func languageVariantsFooterCollectionReusableView(cell: LanguageVariantsFooterCollectionReusableView, onCombinarionButtonTap button: UIButton) {
        let languageCombination = LanguageTransalationCombinationsCollectionViewController(nibName: "LanguageTransalationCombinationsCollectionViewController", bundle: nil)
        languageCombination.defaultDetails = self.defaultDetails
        languageCombination.targetDetails = self.targetDetails
        self.navigationController?.pushViewController(languageCombination, animated: true)
    }
}

extension LanguageTransalationVariantsCollectionViewController: LanguageVariantsHeaderCollectionReusableViewDelegate {
    func languageVariantsHeaderCollectionReusableView(cell: LanguageVariantsHeaderCollectionReusableView, onTextChanged textField: UITextField, indexPath: NSIndexPath) {
        self.targetDetails.productVariants[indexPath.section].name = textField.text
    }
}

extension LanguageTransalationVariantsCollectionViewController: LanguageVariantsCollectionViewCellDelegate {
    func languageVariantsCollectionViewCell(cell: LanguageVariantsCollectionViewCell, onTextChanged textField: UITextField, indexPath: NSIndexPath) {
        self.targetDetails.productVariants[indexPath.section].values[indexPath.row].value = textField.text
    }
}

