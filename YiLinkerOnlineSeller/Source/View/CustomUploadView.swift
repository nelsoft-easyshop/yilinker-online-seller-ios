//
//  CustomUploadView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol CustomUploadViewDelegate {
    func customUploadViewDidTap(customUploadView: CustomUploadView)
}

class CustomUploadView: UIView {
    
    var delegate: CustomUploadViewDelegate?
    
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var placeHolderIconImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var dimView: UIView!
    
    var uploadImageStatus: UploadImageStatus = .NoPhoto
    
    //MARK: -
    //MARK: - Nib Name
    class func nibName() -> String {
        return "CustomUploadView"
    }
    
    //MARK: - 
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeHolderView.layer.zPosition = 2
        self.activityIndicatorView.layer.zPosition = 2
        self.dimView.layer.zPosition = 1
        self.dimView.alpha = 0
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - 
    //MARK: - Tap
    func tap(sender: UITapGestureRecognizer) {
        self.bounceView(sender.view!)
        self.delegate?.customUploadViewDidTap(self)
    }
    
    func bounceView(tappedView: UIView) {
        var sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(2.0, 2.0))
        sprintAnimation.springBounciness = 10.0
        tappedView.pop_addAnimation(sprintAnimation, forKey: "springAnimation")
    }
    
    //MARK: -
    //MARK: Start Loading
    func startLoading() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.dimView.alpha = 0.6
        })
        self.placeHolderView.hidden = true
        self.activityIndicatorView.startAnimating()
    }
    
    //MARK: -
    //MARK: Stop Loading
    func uploadSuccess() {
        self.stopLoading()
        self.uploadImageStatus = .UploadSuccess
    }
    
    //MARK: -
    //MARK: Stop Loading
    func stopLoading() {
        self.activityIndicatorView.stopAnimating()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.dimView.alpha = 0
        })
    }
    
    //MARK: - 
    //MARK: - Show Error Loading
    func showErrorLoading() {
        self.activityIndicatorView.stopAnimating()
        self.placeHolderView.hidden = false
        self.placeHolderView.backgroundColor = UIColor.clearColor()
        self.placeHolderLabel.text = "Tap to reload."
        self.placeHolderIconImageView.image = UIImage(named: "empty-reload-icon")!
        self.uploadImageStatus = .UploadError
    }
}
