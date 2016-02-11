//
//  LoginRegisterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginRegisterTableViewCellDelegate {
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, textFieldShouldReturn textField: UITextField)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapForgotPassword forgotPasswordButton: UIButton)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapSignin signInButton: UIButton)
}

class LoginRegisterTableViewCell: UITableViewCell {
    
    var delegate: LoginRegisterTableViewCellDelegate?

    //Cell Identifier
    let reuseIdentifierLogin: String = "SimplifiedLoginUICollectionViewCell"
    let reuseIdentifierRegistration: String = "SimplifiedRegistrationUICollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
        self.registerNibs()
    }

    func initializeViews() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenWidth = screenSize.width
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func registerNibs() {
        var cellNibLogin = UINib(nibName: reuseIdentifierLogin, bundle: nil)
        self.collectionView?.registerNib(cellNibLogin, forCellWithReuseIdentifier: reuseIdentifierLogin)
        
        var cellNibRegistration = UINib(nibName: reuseIdentifierRegistration, bundle: nil)
        self.collectionView?.registerNib(cellNibRegistration, forCellWithReuseIdentifier: reuseIdentifierRegistration)
    }
}

//MARK: - Data Source And Delegate
//MARK: -  Collection View Data Source And Delegate
extension LoginRegisterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: -  UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SimplifiedLoginUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierLogin, forIndexPath: indexPath) as! SimplifiedLoginUICollectionViewCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.screenWidth, height:342)
    }
}

//MARK: -
//MARK: -  Simplified Login UI CollectionViewCell Delegate
extension LoginRegisterTableViewCell: SimplifiedLoginUICollectionViewCellDelegate {
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, textFieldShouldReturn textField: UITextField) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, textFieldShouldReturn: textField)
    }
    
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapForgotPassword forgotPasswordButton: UIButton) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, didTapForgotPassword: forgotPasswordButton)
    }
    
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapSignin signInButton: UIButton) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, didTapSignin: signInButton)
    }
}