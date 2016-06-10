//
//  TranslationImagesTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/27/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol TranslationImagesTableViewCellDelegate{
    func translationImagesTableViewCell(cell: TranslationImagesTableViewCell, didImagesValuesChanged images: [ProductTranslationImageModel])
}

class TranslationImagesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TranslationImagesTableViewCell"
    
    var delegate: TranslationImagesTableViewCellDelegate?
    
    var images: [ProductTranslationImageModel] = []

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.intializeViews()
        self.registerNibs()
    }

    func intializeViews() {
        self.titleLabel.text = StringHelper.localizedStringWithKey("TRANSLATION_TRANSLATE_TO")
        self.shortDescriptionLabel.text = StringHelper.localizedStringWithKey("TRANSLATION_SHORT_DESCRIPTION")
        
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.delegate = self
    }
    
    func registerNibs() {
        var cellNib = UINib(nibName: TranslationImageCollectionViewCell.reuseIdentifier, bundle: nil)
        self.imagesCollectionView!.registerNib(cellNib, forCellWithReuseIdentifier: TranslationImageCollectionViewCell.reuseIdentifier)
    }
    
    func setLanguage(language: String) {
        self.titleLabel.text = "\(self.titleLabel.text) \(language)"
    }
    
    func setProductImages(images: [ProductTranslationImageModel]) {
        self.images = images
        self.imagesCollectionView.reloadData()
    }
    
}

extension TranslationImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TranslationImageCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! TranslationImageCollectionViewCell
        
        let tempModel = images[indexPath.row]
        cell.indexPath = indexPath
        cell.setCellImage(tempModel.imageLocation)
        cell.setIsSelected(tempModel.isSelected)
        cell.setIsPrimary(tempModel.isPrimary)
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 125, height: 125)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.images[indexPath.row].isSelected = !self.images[indexPath.row].isSelected
        self.imagesCollectionView.reloadData()
        
        self.delegate?.translationImagesTableViewCell(self, didImagesValuesChanged: self.images)
    }
}

extension TranslationImagesTableViewCell: TranslationImageCollectionViewCellDelegate {
    func translationImageCollectionViewCell(cell: TranslationImageCollectionViewCell, didTapAtIndexPath indexPath: NSIndexPath) {
        
        for var i = 0; i < self.images.count; i++ {
            self.images[i].isPrimary = false
        }
        
        self.images[indexPath.row].isPrimary = true
        self.imagesCollectionView.reloadData()
        
        self.delegate?.translationImagesTableViewCell(self, didImagesValuesChanged: self.images)
    }
}