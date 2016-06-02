//
//  ProductManagementTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductManagementTableViewCellDelegate {
    func updateSelectedItems(index: Int, selected: Bool)
}

private struct Strings {
    static let stores = StringHelper.localizedStringWithKey("MANAGEMENT_STORES_LOCALIZE_KEY")
    static let language = StringHelper.localizedStringWithKey("MANAGEMENT_LANGUAGE_LOCALIZE_KEY")
}

class ProductManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var checkTapView: UIView!
    @IBOutlet weak var checkContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var storesLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    var delegate: ProductManagementTableViewCellDelegate?
    
    var index: Int = 0
    var checkedItems: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        costumizeVies()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - Methods
    
    func setProductImage(image: String) {
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func costumizeVies() {
        
        storesLabel.text = Strings.stores + " :"
        languageLabel.text = Strings.language + " :"
        
        checkContainerView.layer.cornerRadius = 4.0
        checkTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkAction:"))
    }
    
    func clearCheckImage() {
        checkImageView.hidden = true
        checkContainerView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func decreaseAlpha() {
        self.titleLabel.alpha = 0.75
        self.subTitleLabel.alpha = 0.75
        self.arrowImageView.alpha = 0.50
    }
    
    func increaseAlpha() {
        self.titleLabel.alpha = 1
        self.subTitleLabel.alpha = 1
        self.arrowImageView.alpha = 1
    }
    
    func selected() {
        checkImageView.hidden = false
        if index == 4 {
            checkContainerView.backgroundColor = Constants.Colors.pmCheckGreenColor
            self.productImageView.alpha = 1
            increaseAlpha()
        } else {
            checkContainerView.backgroundColor = .redColor()
            decreaseAlpha()
        }
    }
    
    func deselected() {
        clearCheckImage()
        
        if index == 4 {
            self.productImageView.alpha = 0.75
            decreaseAlpha()
        } else {
            self.productImageView.alpha = 1
            increaseAlpha()
        }
    }
    
    func isSelected(selected: Bool) {
        if selected {
            self.selected()
        }
    }
    
    // MARK: - Actions
    
    func checkAction(gesture: UIGestureRecognizer) {

        if checkImageView.hidden {
            checkedItems++
            selected()
        } else {
            checkedItems--
            deselected()
        }
     
        if checkedItems == 0 {
            delegate?.updateSelectedItems(self.tag, selected: false)
        } else {
            delegate?.updateSelectedItems(self.tag, selected: true)
        }
    }
    
    
    func setCountriesAndLanguages(product: ProductManagementProductsModel) {
        
        var limiter = 3 // screen with is 320 or below
        if UIScreen.mainScreen().bounds.width > 320 {
            limiter = 4
        }
        
        // Countries
        
        // remove previous images
        for view in self.storesLabel.subviews {
            if let imgview = view as? UIImageView {
                imgview.removeFromSuperview()
            }
        }
        
        // add images
        
        for i in 0..<product.selectedCountries.count {
            
            let flagImageView: UIImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(storesLabel.frame) + (CGFloat(i) * 24.0), 2.5, 20, 10))
            if i > limiter {
                flagImageView.image = UIImage(named: "flags_more")
            } else {
                flagImageView.sd_setImageWithURL(NSURL(string: product.selectedCountries[i].image))
            }
            self.storesLabel.addSubview(flagImageView)
            
        }
        
        
        // Languages
        
        // remove previous labels and images
        for view in self.languageLabel.subviews {
            if let lblview = view as? UILabel {
                lblview.removeFromSuperview()
            } else if let imgview = view as? UIImageView {
                imgview.removeFromSuperview()
            }
        }
        
        for i in 0..<product.selectedLanguages.count {
            
            if i > limiter {
                let flagImageView: UIImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(languageLabel.frame) + 100/*179*/, 2.5, 20, 10))
                flagImageView.image = UIImage(named: "flags_more")
                self.languageLabel.addSubview(flagImageView)
                break
            } else {
                let langLabel: UILabel = UILabel(frame: CGRectMake(CGRectGetWidth(languageLabel.frame) + (CGFloat(i) * 23.0), 2.5, 20, 10))
                langLabel.backgroundColor = Constants.Colors.lightBackgroundColor
                langLabel.font = UIFont(name: "Helvetica-Light", size: 7.0)
                langLabel.text = product.selectedLanguages[i].languageCode.uppercaseString
                langLabel.textAlignment = .Center
                self.languageLabel.addSubview(langLabel)
            }
        }
    }

}


