//
//  ProductManagementAllTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementAllTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var storesLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProductImage(image: String) {
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setStatus(status: Int) {
        
        if status == 0 {
            statusLabel.text = "Draft"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == 1 {
            statusLabel.text = "Under Review"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == 2 {
            statusLabel.text = "Active"
            statusLabel.textColor = Constants.Colors.pmCheckGreenColor
            increaseAlpha()
        } else if status == 3 {
            statusLabel.text = "Deleted"
            statusLabel.textColor = UIColor.darkGrayColor()
            setDeleted()
        } else if status == 4 {
            statusLabel.text = "Fully Deleted"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == 5 {
            statusLabel.text = "Rejected"
            statusLabel.textColor = UIColor.redColor()
            increaseAlpha()
        } else if status == 6 {
            statusLabel.text = "Inactive"
            statusLabel.textColor = UIColor.redColor()
            increaseAlpha()
        }
    }
    
    func setDeleted() {
        self.productImageView.alpha = 0.50
        self.titleLabel.alpha = 0.75
        self.subTitleLabel.alpha = 0.75
        self.statusLabel.alpha = 0.75
    }
    
    func increaseAlpha() {
        self.productImageView.alpha = 1.0
        self.titleLabel.alpha = 1.0
        self.subTitleLabel.alpha = 1.0
        self.statusLabel.alpha = 1.0
    }
    
    func setCountries(countries: [String]) {
        
        // remove previous images
        for view in self.storesLabel.subviews {
            if let imgview = view as? UIImageView {
                imgview.removeFromSuperview()
            }
        }
        
        // add images
        let random = Int(arc4random_uniform(7))

        for i in 0..<5 {
            
            let flagImageView: UIImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(storesLabel.frame) + (CGFloat(i) * 24.0), 2.5, 20, 10))

            if i > 3 {
                flagImageView.image = UIImage(named: "flags_more")
            } else {
                flagImageView.sd_setImageWithURL(NSURL(string: countries[i]))
            }
            
            self.storesLabel.addSubview(flagImageView)
        }
        
    }
    
    func setLanguages(language: [String]) {
        
        // remove previous labels and images
        for view in self.languageLabel.subviews {
            if let lblview = view as? UILabel {
                lblview.removeFromSuperview()
            } else if let imgview = view as? UIImageView {
                imgview.removeFromSuperview()
            }
        }
        
        // add labels
        var limiter = 4 // screen with is 320 or below
        if UIScreen.mainScreen().bounds.width > 320 {
            limiter = 5
        }
        
        let random = Int(arc4random_uniform(7))

        for i in 0..<5/*self.tag*/ {
            
            if i > 3 {
                let flagImageView: UIImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(languageLabel.frame) + 92, 2.5, 20, 10))
                flagImageView.image = UIImage(named: "flags_more")
                self.languageLabel.addSubview(flagImageView)
                break
            } else {
                let langLabel: UILabel = UILabel(frame: CGRectMake(CGRectGetWidth(languageLabel.frame) + (CGFloat(i) * 23.0), 2.5, 20, 10))
                langLabel.backgroundColor = Constants.Colors.lightBackgroundColor
                langLabel.font = UIFont(name: "Helvetica-Light", size: 7.0)
                langLabel.text = language[i]
                langLabel.textAlignment = .Center
                self.languageLabel.addSubview(langLabel)
            }
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
                langLabel.text = /*product.selectedLanguages[i].countryCode + " - " + */product.selectedLanguages[i].languageCode.uppercaseString
                langLabel.textAlignment = .Center
                self.languageLabel.addSubview(langLabel)
            }
        }
    }
    
}
