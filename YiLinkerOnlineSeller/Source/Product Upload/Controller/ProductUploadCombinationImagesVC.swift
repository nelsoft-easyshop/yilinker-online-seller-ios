//
//  ProductUploadCombinationImagesVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 5/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadCombinationImagesVCDelegate {
    func productUploadCombinationImagesVC(productModel: ProductModel, indexes: [Int])
}

class ProductUploadCombinationImagesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var productModel: ProductModel = ProductModel()
    var delegate: ProductUploadCombinationImagesVCDelegate?
    var selectedImages: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = false
        
        
        self.initCollectionView()
        self.registerNib()
        self.backButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: - Navigation bar
    // MARK: - Add back button in navigation bar
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 15, 15)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "close-1"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        checkButton.hidden = true
        
        checkButton.hidden = false
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    // MARK: -
    // MARK: - Navaigation bar's back button action
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Navigation bar's check button action
    
    func check() {
        if self.selectedImages.count == 0 {
            self.showAlert(title: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_NO_IMAGE_LOCALIZE_KEY"))
        } else {
            self.delegate?.productUploadCombinationImagesVC(self.productModel, indexes: self.selectedImages)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: -
    // MARK: - Init Collection View
    
    func initCollectionView() {
        let screenSize: CGRect = self.view.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if screenHeight <= 480 {
            layout.itemSize = CGSize(width: ((screenWidth - 5)/3), height: (screenHeight * 0.22))
        } else {
            layout.itemSize = CGSize(width: ((screenWidth - 5)/3.5), height: (screenHeight * 0.17))
        }
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView?.backgroundColor = UIColor.lightGrayColor()
        collectionView.bounds = self.view.bounds
        collectionView?.bounces = false
        collectionView?.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: -
    // MARK: - Register nib file
    
    func registerNib() {
        let nib: UINib = UINib(nibName: "ProductUploadCombinationImagesCVC", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "ProductUploadCombinationImagesCVC")
    }
    
    // MARK: -
    // MARK: - Show alert
    
    func showAlert(#title: String!) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ProductUploadCombinationImagesCVC = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadCombinationImagesCVCConstant.productUploadCombinationImagesCVCNibAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationImagesCVC
        cell.mainImage.image = self.productModel.productMainImagesModel[indexPath.row].image
        
        if self.productModel.productMainImagesModel[indexPath.row].imageStatus == true {
            cell.mainImage.alpha = 1.0
        } else {
            cell.mainImage.alpha = 0.5
        }
        
        cell.layer.borderWidth = 2.0
        if cell.selected == true {
            cell.layer.borderColor = Constants.Colors.appTheme.CGColor!
        } else {
            cell.layer.borderColor = UIColor.clearColor().CGColor!
        }
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
        
        cell!.layer.borderWidth = 2.0
        if self.productModel.productMainImagesModel[indexPath.row].imageStatus == true {
            if cell!.selected == true {
                var index: Int = self.selectedImages.count - 1
                if contains(self.selectedImages, indexPath.row) {
                    self.selectedImages.removeAtIndex(index)
                    cell!.layer.borderColor = UIColor.clearColor().CGColor!
                } else {
                    self.selectedImages.append(indexPath.row)
                    cell!.layer.borderColor = Constants.Colors.appTheme.CGColor!
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productModel.productMainImagesModel.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
