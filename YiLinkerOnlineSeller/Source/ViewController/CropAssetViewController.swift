//
//  CropAssetViewController.swift
//  FaImagePicker
//
//  Created by juniac on 07/16/2015.
//  Copyright (c) 2015 maneuling. All rights reserved.
//

import UIKit

struct ASSET_ASPECT {
    static let RATIO_ORIGINAL = 0
    static let RATIO_1x1 = 1
    static let RATIO_4x3 = 2
    static let RATIO_3x4 = 3
    
}
class CropAssetViewController: UIViewController, UIScrollViewDelegate {

    var image:UIImage!
    var imageView = UIImageView()
    var croppedImages: [UIImage] = []
    var scrollView: UIScrollView! = UIScrollView()

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var ratio1x1Button: UIButton!
    @IBOutlet weak var ratio4x3Button: UIButton!
    @IBOutlet weak var ratio3x4Button: UIButton!
    @IBOutlet weak var ratioOriginalButton: UIButton!
    
    var topDimmedView: UIView = UIView()
    var bottomDimmedView: UIView = UIView()
    var imageCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        self.view.addSubview(topDimmedView)
        self.view.addSubview(bottomDimmedView)
        topDimmedView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 1)
        bottomDimmedView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 1)
        topDimmedView.alpha = 0.7
        bottomDimmedView.alpha = 0.7
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        self.scrollView.addSubview(imageView)
        self.scrollView.delegate = self
        menuView.hidden = true
        self.view.bringSubviewToFront(menuView)
        
        var frameSize:CGSize = CGSizeZero
        var imageFrameSize:CGSize
        frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_1x1)
        imageFrameSize = self.imageViewSizeWithFrame(frameSize)
        
        self.changeCroppingAreaWithAnimation(true, frame: frameSize, imageFrameSize: imageFrameSize)
        
        backButton()
    }
    
    //MARK: Navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 0, 0)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }

    func check(){
        let cropImage = self.cropImage()
        
        let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
        println(ProductUploadStrings.cropped)
        ProductCroppedImages.imagesCropped.insert(cropImage, atIndex: ProductCroppedImages.imagesCropped.count)
        //productUploadTableViewController.productModel.imagesCropped.append(cropImage)
        self.navigationController!.popViewControllerAnimated(true)
        productUploadTableViewController.reloadTable()

    }
    
    override func viewWillAppear(animated: Bool) {
     
    }
    
    override func viewDidLayoutSubviews() {
        if image != nil {
            self.imageView.image = image
            let frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_1x1)
            let imageFrameSize = self.imageViewSizeWithFrame(frameSize)
            self.changeCroppingAreaWithAnimation(false, frame: frameSize, imageFrameSize: imageFrameSize)
        }
    }
    override func viewDidAppear(animated: Bool) {
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func frameSizeWithAspectRatio(ratio:Int) -> CGSize {
        let availableSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height - self.topLayoutGuide.length)
        var frameSize:CGSize = availableSize
//        println(availableSize)
        let frameRatio = availableSize.width / availableSize.height
    
        switch ratio {
        case ASSET_ASPECT.RATIO_1x1:
            if frameRatio > 1 {
                frameSize = CGSizeMake(availableSize.height, availableSize.height)
            } else {
                frameSize = CGSizeMake(availableSize.width, availableSize.width)
            }
            break;
        case ASSET_ASPECT.RATIO_4x3:
            if frameRatio > 4 / 3 {
                
                frameSize = CGSizeMake(availableSize.height * (4 / 3), availableSize.height)
            } else {
                frameSize = CGSizeMake(availableSize.width, availableSize.width / (4 / 3))
                
            }
            break;
        case ASSET_ASPECT.RATIO_3x4:
            if frameRatio > 3 / 4 {
                frameSize = CGSizeMake(availableSize.height * (3 / 4), availableSize.height)
            } else {
                frameSize = CGSizeMake(availableSize.width, availableSize.width / (3 / 4))
                
            }
            break;
            
        case ASSET_ASPECT.RATIO_ORIGINAL:
            
            let imageRatio = self.image.size.width / self.image.size.height
            if frameRatio > imageRatio {
                frameSize = CGSizeMake(availableSize.height * imageRatio, availableSize.height)
            } else {
                frameSize = CGSizeMake(availableSize.width, availableSize.width / imageRatio)
            }
            /*if frameRatio > 1 {
                frameSize = CGSizeMake(availableSize.height, availableSize.height)
            } else {
                frameSize = CGSizeMake(availableSize.width, availableSize.width)
            }*/
            break
        default:
            break
            
        }
        return frameSize
    }
    
    func imageViewSizeWithFrame(size:CGSize) -> CGSize {
        let imageRatio = self.image.size.width / self.image.size.height

        let frameRatio = size.width / size.height
        var imageFrameSize:CGSize = CGSizeZero
        
        if imageRatio < 1 {
            imageFrameSize = CGSizeMake(size.width, size.width / imageRatio)
        } else if imageRatio > 1 {
            imageFrameSize = CGSizeMake(size.height * imageRatio, size.height)
        } else {
            imageFrameSize = CGSizeMake(max(size.width, size.height), max(size.width, size.height))
        }
        return imageFrameSize
    }

    func changeCroppingAreaWithAnimation(animation:Bool, frame:CGSize, imageFrameSize:CGSize) {
        
        let availableSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height - self.topLayoutGuide.length)
        let scrollViewFrame = CGRectMake((availableSize.width - frame.width) / 2, (availableSize.height - frame.height) / 2 + self.topLayoutGuide.length, frame.width, frame.height)
        
        let topDimmedViewFrame = CGRectMake(0, self.topLayoutGuide.length, self.view.bounds.width, scrollViewFrame.origin.y - self.topLayoutGuide.length)
        let bottomDimmedViewFrame = CGRectMake(0, CGRectGetMaxY(scrollViewFrame), self.view.bounds.width, self.view.bounds.height - CGRectGetMaxY(scrollViewFrame))
        scrollView.contentSize = imageFrameSize
        scrollView.contentInset = UIEdgeInsetsZero
        let imageViewFrame = CGRectMake(0, 0, imageFrameSize.width, imageFrameSize.height)
        let offset = CGPointMake((imageFrameSize.width - scrollViewFrame.width) / 2, (imageFrameSize.height - scrollViewFrame.height) / 2)
        self.scrollView.setContentOffset(offset, animated: false)
        if animation == true {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: .CurveLinear, animations: {
                self.imageView.frame = imageViewFrame
                self.scrollView.frame = scrollViewFrame
                self.topDimmedView.frame = topDimmedViewFrame
                self.bottomDimmedView.frame = bottomDimmedViewFrame
                }, completion: { finished in

            })
        } else {

                self.scrollView.frame = scrollViewFrame
                self.imageView.frame = imageViewFrame
                self.topDimmedView.frame = topDimmedViewFrame
                self.bottomDimmedView.frame = bottomDimmedViewFrame
        }

    }
    
    func cropImage() -> UIImage {
        var scale:CGFloat
        if imageView.frame.width == scrollView.frame.width {
            scale = self.image.size.width / imageView.frame.width
        } else {
            scale = self.image.size.height / imageView.frame.height
        }
        let resultImageSize = CGSizeMake(self.scrollView.frame.size.width * scale, self.scrollView.frame.size.height * scale)
        
        let resultImageOrigin = CGPointMake(self.scrollView.contentOffset.x * scale, self.scrollView.contentOffset.y * scale)
        let rect = CGRect(origin: resultImageOrigin, size: resultImageSize)

        
        var rectTransform:CGAffineTransform!
        switch (self.image.imageOrientation)  {
        case UIImageOrientation.Left:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(M_PI_2)), 0, -self.image.size.height)
            break;
        case UIImageOrientation.Right:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(-M_PI_2)), -self.image.size.width, 0)
            break;
        case UIImageOrientation.Down:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(-M_PI)), -self.image.size.width, -self.image.size.height)
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
        };
        rectTransform = CGAffineTransformScale(rectTransform, self.image.scale, self.image.scale)
        
        let imageRef:CGImageRef = CGImageCreateWithImageInRect(self.image.CGImage, CGRectApplyAffineTransform(rect, rectTransform))
        
        let cropImage = UIImage(CGImage: imageRef, scale: self.image.scale, orientation: self.image.imageOrientation)!
        println("cropImageSize:\(cropImage)")
        return cropImage

    }
    
    @IBAction func ratioButtonAction(sender: UIButton) {
        var frameSize:CGSize = CGSizeZero
        var imageFrameSize:CGSize
        if sender == ratio1x1Button {
            frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_1x1)
        } else if sender == ratio3x4Button {
            frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_3x4)
        } else if sender == ratio4x3Button {
            frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_4x3)
        } else if sender == ratioOriginalButton {
            frameSize = self.frameSizeWithAspectRatio(ASSET_ASPECT.RATIO_ORIGINAL)
        }
        imageFrameSize = self.imageViewSizeWithFrame(frameSize)

        
        self.changeCroppingAreaWithAnimation(true, frame: frameSize, imageFrameSize: imageFrameSize)
//        println("frameSize:\(frameSize)")
//        println("imageFrameSize:\(imageFrameSize)")
    }
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        let cropImage = self.cropImage()
        
        let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
        ProductCroppedImages.imagesCropped.insert(cropImage, atIndex: ProductCroppedImages.imagesCropped.count)
        self.navigationController!.popViewControllerAnimated(true)
        productUploadTableViewController.reloadTable()
    }

}
