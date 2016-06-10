//
//  ProductMainImagesModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 5/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductMainImagesModel: NSObject {
    var image: UIImage = UIImage()
    var imageName: String = ""
    var imageStatus: Bool = false
    var imageFailed: Bool = false
    
    init(image: UIImage, imageName: String, imageStatus: Bool, imageFailed: Bool) {
        self.image = image
        self.imageName = imageName
        self.imageStatus = imageStatus
        self.imageFailed = imageFailed
    }
}
