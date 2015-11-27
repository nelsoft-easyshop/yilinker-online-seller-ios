//
//  FaImagePickerController.swift
//  FaImagePicker
//
//  Created by juniac on 07/16/2015.
//  Copyright (c) 2015 maneuling. All rights reserved.
//

import UIKit
protocol FaImagePickerControllerDelegate {
//    func faImagePickerController(picker: FaImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    func faImagePickerController(picker: FaImagePickerController, didFinishPickingImage image: UIImage?)
    func faImagePickerControllerDidCancel(picker: FaImagePickerController)
}

class FaImagePickerController: UINavigationController {
    var imagePickerDelegate:FaImagePickerControllerDelegate! = nil
    
//    var info = [NSObject : AnyObject]()
    var image:UIImage! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func shouldBeCancel() {
        self.imagePickerDelegate.faImagePickerControllerDidCancel(self)
    }
    
    func shouldBeDone() {
        self.imagePickerDelegate.faImagePickerController(self, didFinishPickingImage :image)
    }
    
}
