//
//  LanguageTransalationCombinationsCollectionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class LanguageTransalationCombinationsCollectionViewController: UICollectionViewController {
    
    var defaultDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    var targetDetails: ProductTranslationDetailsModel = ProductTranslationDetailsModel(productId: "")
    
    var comPos = 0
    typealias Variant = (variantDefault: String, variantTranslation: String)
    typealias Combination = (combinationName: String, variants: [Variant])
    var combinations: [Combination] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializesViews()
        self.addBackButton()
        self.registerNibs()
        
        self.combine("", pos: -1)
        
        println(combinations)
        println(combinations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("TRANSLATION_COMBINATION_TITLE")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    func registerNibs() {
        
        var cellNib = UINib(nibName: LanguageCombinationCollectionViewCell.reuseIdentifier, bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: LanguageCombinationCollectionViewCell.reuseIdentifier)
        
        var header = UINib(nibName: LanguageCombinationHeaderCollectionReusableView.reuseIdentifier, bundle: nil)
        self.collectionView!.registerNib(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LanguageCombinationHeaderCollectionReusableView.reuseIdentifier)
        
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
    
    func combine(temp: String, pos: Int) {
        if pos == self.defaultDetails.productVariants.count - 1 {
            var array = temp.componentsSeparatedByString("&&&&&&&&&")
            comPos++
            var variants: [Variant] = []
            
            for(var x = 0; x < array.count; x++) {
                variants.append(Variant(variantDefault: self.targetDetails.productVariants[x].name, variantTranslation: array[x]))
            }
            
            combinations.append(Combination((combinationName: "Combination\(comPos)", variants: variants)))
        } else {
            var nextPos = pos + 1
            
            for(var x = 0; x < self.defaultDetails.productVariants[nextPos].values.count; x++) {
                var str = ""
                if x < self.targetDetails.productVariants[nextPos].values.count {
                    if (self.targetDetails.productVariants[nextPos].values[x].value.isNotEmpty()) {
                        str = self.targetDetails.productVariants[nextPos].values[x].value
                    }
                } else {
                    str = self.defaultDetails.productVariants[nextPos].values[x].value
                }
                combine(temp.isEmpty ? str : "\(temp)&&&&&&&&&\(str)", pos: nextPos)
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.combinations.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.combinations[section].variants.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LanguageCombinationCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! LanguageCombinationCollectionViewCell
        
        cell.setVariant(self.combinations[indexPath.section].variants[indexPath.row].variantDefault, variantValue: self.combinations[indexPath.section].variants[indexPath.row].variantTranslation)
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        return CGSize(width: ((screenWidth / 2) - 20), height: 55)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: LanguageCombinationHeaderCollectionReusableView.reuseIdentifier, forIndexPath: indexPath) as! LanguageCombinationHeaderCollectionReusableView
            return cell
        } else {
            return UICollectionReusableView(frame: CGRectZero)
        }
    }
}
