//
//  AlbumTableViewController.swift
//  FaImagePicker
//
//  Created by juniac on 07/16/2015.
//  Copyright (c) 2015 maneuling. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class AlbumTableViewController: UITableViewController {
    
    let assetsLibrary = ALAssetsLibrary()
    var assetsGroups = [ALAssetsGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let allowGroupType = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos
        assetsLibrary.enumerateGroupsWithTypes(allowGroupType, usingBlock: {
            (group: ALAssetsGroup?, stop: UnsafeMutablePointer<ObjCBool>) in
            
                if let unWrappedGroup = group {
                    unWrappedGroup.setAssetsFilter(ALAssetsFilter.allPhotos())
                    
                    if unWrappedGroup.numberOfAssets() > 0 {
                        self.assetsGroups.append(unWrappedGroup)
                    }
                    
                }
            
            self.tableView.reloadData()
            
            
           
            
            }, failureBlock: {
                (error: NSError!) in
                
           
                
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeBarButtonAction(sender: UIBarButtonItem) {
        let faImagePickerController:FaImagePickerController = self.navigationController as! FaImagePickerController
        faImagePickerController.shouldBeCancel()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return assetsGroups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AlbumTableViewCell = tableView.dequeueReusableCellWithIdentifier("AlbumIdentifier", forIndexPath: indexPath) as! AlbumTableViewCell

        // Configure the cell...
        let group = self.assetsGroups[indexPath.row]
        let thumbnail = group.posterImage().takeUnretainedValue()
        cell.thumbnailImageView?.image = UIImage(CGImage: thumbnail)
        cell.nameLabel.text = group.valueForProperty(ALAssetsGroupPropertyName) as? String
        cell.assetCountLabel.text = String(group.numberOfAssets())
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            
            if segue.identifier == "showAssetCollection" {
                let cell = sender as! AlbumTableViewCell
                let indexPath = self.tableView.indexPathForCell(cell)
                let assetCollectionViewController:AssetCollectionViewController = segue.destinationViewController as! AssetCollectionViewController
                let group = self.assetsGroups[indexPath!.row]
                assetCollectionViewController.loadAssetsGroup(group)
                
            }
        }

    }


}
