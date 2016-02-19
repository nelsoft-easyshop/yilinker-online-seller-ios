//
//  FilterModalViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

private struct Strings {
    static let sortBy = StringHelper.localizedStringWithKey("SORT_BY_LOCALIZE_KEY")
    static let status = StringHelper.localizedStringWithKey("STATUS_LOCALIZE_KEY")
    static let categoryFiles = StringHelper.localizedStringWithKey("CATEGORY_FILES_LOCALIZE_KEY")
    static let reset = StringHelper.localizedStringWithKey("RESET_LOCALIZE_KEY")
    static let cancel = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    
    static let all = StringHelper.localizedStringWithKey("ALL_LOCALIZE_KEY")
    static let available = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    static let selected = StringHelper.localizedStringWithKey("SELECTED_LOCALIZE_KEY")
    
    static let latest = StringHelper.localizedStringWithKey("LATEST_LOCALIZE_KEY")
    static let earning = StringHelper.localizedStringWithKey("EARNING_LOCALIZE_KEY")
    
    static let applyFilter = StringHelper.localizedStringWithKey("APPLY_FILTER_LOCALIZE_KEY")
}

protocol FilterModalViewControllerDelegate {
    func filterModalViewController(filterModalViewController: FilterModalViewController, didTapButton button: UIButton)
}

class FilterModalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var categoryFilesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var availableButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var earningButton: UIButton!
    @IBOutlet weak var latestButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: FilterModalViewControllerDelegate?
    
    var categories: [AffiliateCategoryModel] = []
    
    //MARK: - 
    //MARK: - Nib Name
    class func nibName() -> String {
        return "FilterModalViewController"
    }
    
    //MARK: -
    //MARK: Register Cells
    func registerCell() {
        let cellNib: UINib = UINib(nibName: SelectCategoryCollectionViewCell.nibNameAndIdentifier(), bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: SelectCategoryCollectionViewCell.nibNameAndIdentifier())
    }
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initButtons()
        
        self.activateButton(self.latestButton)
        self.deActivateButton(self.earningButton)
        
        self.activateButton(self.allButton)
        self.deActivateButton(self.availableButton)
        self.deActivateButton(self.selectedButton)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.registerCell()
        
        self.dummyFunction()
        self.localizedStrings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Localized Strings
    func localizedStrings() {
        self.cancelButton.setTitle(Strings.cancel, forState: .Normal)
        self.resetButton.setTitle(Strings.reset, forState: .Normal)
        self.latestButton.setTitle(Strings.latest, forState: .Normal)
        self.earningButton.setTitle(Strings.earning, forState: .Normal)
       
        self.availableButton.setTitle(Strings.available, forState: .Normal)
        self.allButton.setTitle(Strings.all, forState: .Normal)
        self.selectedButton.setTitle(Strings.selected, forState: .Normal)

        self.applyFilterButton.setTitle(Strings.applyFilter, forState: .Normal)
        
        self.sortByLabel.text = Strings.sortBy
        self.statusLabel.text = Strings.status
        self.categoryFilesLabel.text = Strings.categoryFiles
    }
    
    //MARK: - 
    //MARK: - Cancel Action
    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate!.filterModalViewController(self, didTapButton: sender)
    }
    
    //MARK: - 
    //MARK: - Init Buttons
    func initButtons() {
        self.latestButton.layer.cornerRadius = 15
        self.earningButton.layer.cornerRadius = 15
        
        self.allButton.layer.cornerRadius = 14
        self.availableButton.layer.cornerRadius = 15
        self.selectedButton.layer.cornerRadius = 15
        
        self.applyFilterButton.layer.cornerRadius = 5
    }
    
    //MARK: -
    //MARK: - Did Select Item Action
    @IBAction func disSelectItemAction(sender: UIButton) {
        if sender == self.latestButton {
            self.activateButton(self.latestButton)
            self.deActivateButton(self.earningButton)
        } else if sender == self.earningButton {
            self.activateButton(self.earningButton)
            self.deActivateButton(self.latestButton)
        } else if sender == self.allButton {
            self.activateButton(self.allButton)
            self.deActivateButton(self.availableButton)
            self.deActivateButton(self.selectedButton)
        } else if sender == self.availableButton {
            self.activateButton(self.availableButton)
            self.deActivateButton(self.allButton)
            self.deActivateButton(self.selectedButton)
        } else if sender == self.selectedButton {
            self.activateButton(self.selectedButton)
            self.deActivateButton(self.allButton)
            self.deActivateButton(self.availableButton)
        }
        
        self.bounceButton(sender)
    }
    
    //MARK: - 
    //MARK: - Activate Button
    func activateButton(button: UIButton) {
        button.layer.borderWidth = 0.5
        button.backgroundColor = Constants.Colors.appTheme
        button.layer.borderColor = UIColor.clearColor().CGColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    //MARK: -
    //MARK: De Activate Button
    func deActivateButton(button: UIButton) {
        button.layer.borderWidth = 0.5
        button.backgroundColor = UIColor.clearColor()
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    }
    
    //MARK: - 
    //MARK: - Apply Filter Action
    @IBAction func applyFilterAction(sender: UIButton) {
        self.delegate?.filterModalViewController(self, didTapButton: sender)
    }
    
    //MARK: - 
    //MARK: - Bounce Button
    func bounceButton(button: UIButton) {
        var sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(2.0, 2.0))
        sprintAnimation.springBounciness = 10.0
        button.pop_addAnimation(sprintAnimation, forKey: "springAnimation")
    }
    
    //MARK: -
    //MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SelectCategoryCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(SelectCategoryCollectionViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! SelectCategoryCollectionViewCell
        cell.categoryNameLabel.text = self.categories[indexPath.row].name
        
        if self.categories[indexPath.row].isSelected {
            cell.checkBoxImageView.image = UIImage(named: "category-checked")
        } else {
            cell.checkBoxImageView.image = UIImage(named: "category-unchecked")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width: CGFloat = ((self.view.frame.size.width - 30) / 2)
            return CGSizeMake(width, 44)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(self.view.frame.size.width, 30)
    }
    
    //MARK: -
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(2.0, 2.0))
        sprintAnimation.springBounciness = 10.0
        let cell: SelectCategoryCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! SelectCategoryCollectionViewCell
        cell.pop_addAnimation(sprintAnimation, forKey: "springAnimation")
        
        let category: AffiliateCategoryModel = self.categories[indexPath.row]
        
        if category.isSelected {
            category.isSelected = false
            cell.checkBoxImageView.image = UIImage(named: "category-unchecked")
        } else {
            category.isSelected = true
            cell.checkBoxImageView.image = UIImage(named: "category-checked")
        }
    }
    
    //MARK: - 
    //MARK: - Dummy Function
    func dummyFunction() {
        for i in 0..<10 {
            let category: AffiliateCategoryModel = AffiliateCategoryModel()
            category.productCategoryId = i + 1
            category.name = "Category \(i+1)"
            self.categories.append(category)
        }
    }
}
