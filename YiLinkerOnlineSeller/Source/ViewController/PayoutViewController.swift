//
//  PayoutViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutViewController: UIViewController {

    @IBOutlet weak var tabsCollectionView: UICollectionView!
    
    var pageTitle: [String] = ["WITHDRAW", "REQUESTS", "RECORD", "EARNINGS"]
    var selectedImage: [String] = ["withdraw", "request", "record", "earning"]
    var deselectedImage: [String] = ["withdraw2", "request2", "record2", "earning2"]
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibCVC = UINib(nibName: "ProductManagementCollectionViewCell", bundle: nil)
        self.tabsCollectionView.registerNib(nibCVC, forCellWithReuseIdentifier: "ProductManagementIdentifier")
    } // view did load

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductManagementCollectionViewCell = self.tabsCollectionView.dequeueReusableCellWithReuseIdentifier("ProductManagementIdentifier", forIndexPath: indexPath) as! ProductManagementCollectionViewCell
        
        cell.titleLabel.text = pageTitle[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deselectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            self.tabsCollectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 4, height: 60)
    }

}
