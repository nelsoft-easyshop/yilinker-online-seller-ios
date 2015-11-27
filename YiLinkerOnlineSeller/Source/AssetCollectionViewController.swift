//
//  AssetCollectionViewController.swift
//  FaImagePicker
//
//  Created by juniac on 07/16/2015.
//  Copyright (c) 2015 maneuling. All rights reserved.
//

import UIKit
import AssetsLibrary

let reuseIdentifier = "AssetCell"
let itemsPerLine:CGFloat = 4
class AssetCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var assets = [ALAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(AssetCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAssetsGroup(group:ALAssetsGroup) {
        self.navigationItem.title = group.valueForProperty(ALAssetsGroupPropertyName) as? String
        
        group.enumerateAssetsUsingBlock({
            (anAsset:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            if let asset = anAsset {
                self.assets.append(asset)
            } else {

                self.collectionView?.reloadData()
            }

        })

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            if segue.identifier == "showCropper" {
                let cell = sender as! AssetCollectionViewCell
                let indexPath = self.collectionView?.indexPathForCell(cell)
                let cropAssetViewController:CropAssetViewController = segue.destinationViewController as! CropAssetViewController
                println(self.assets.count)
                let asset = self.assets[indexPath!.row]
//                cropAssetViewController.imageView.image = 
                
                let defaultRepresentation: ALAssetRepresentation = asset.defaultRepresentation()
                let fullResolutionImage = defaultRepresentation.fullResolutionImage().takeUnretainedValue()
                
                let image = UIImage(CGImage: fullResolutionImage)
                cropAssetViewController.image = image

            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section

        return self.assets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:AssetCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AssetCollectionViewCell
        
        // Configure the cell
        let asset = assets[indexPath.item]
        
        let assetImage = asset.thumbnail().takeUnretainedValue()
        let thumbnail = UIImage(CGImage: assetImage)
        cell.frame.size.width = self.view.bounds.width / itemsPerLine - 1
        cell.frame.size.height = self.view.bounds.width / itemsPerLine - 1
        cell.imageView.image = thumbnail
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeZero
        size.width = self.view.bounds.width / itemsPerLine - 1
        size.height = self.view.bounds.width / itemsPerLine - 1
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }


    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
        
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
