//
//  LanguageTranslationTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class LanguageTranslationTableViewController: UITableViewController {
    
    var headerTitles = ["", "Product Name", "Short Description", "Complete Description", "Brand", "Product Group", "Product Variants"]
    
    var hud: MBProgressHUD?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializesViews()
        self.registerNibs()
        self.addBackButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("TRANSLATION_TITLE")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.estimatedRowHeight = 150.0
    }
    
    func registerNibs() {
        var translationImagesNib = UINib(nibName: TranslationImagesTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(translationImagesNib, forCellReuseIdentifier: TranslationImagesTableViewCell.reuseIdentifier)
        
        var translationInputNib = UINib(nibName: TranslationInputTableViewCell.reuseIdetifier, bundle: nil)
        self.tableView.registerNib(translationInputNib, forCellReuseIdentifier: TranslationInputTableViewCell.reuseIdetifier)
        
        var translationProductGroupNib = UINib(nibName: TranslationProductGroupTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.registerNib(translationProductGroupNib, forCellReuseIdentifier: TranslationProductGroupTableViewCell.reuseIdentifier)
    }
    
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - Util Function
    //Loader function
    func showLoader() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return 5 //Product Group Count
        } else if section == 6 {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(TranslationImagesTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! TranslationImagesTableViewCell
            cell.selectionStyle = .None
            return cell
        } else if indexPath.section == 5 {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(TranslationProductGroupTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! TranslationProductGroupTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            return cell
        } else {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(TranslationInputTableViewCell.reuseIdetifier, forIndexPath: indexPath) as! TranslationInputTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 35
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
            headerView.backgroundColor = UIColor.whiteColor()
            
            var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 0, (self.view.bounds.width - 48), 35))
            headerTextLabel.textColor = Constants.Colors.grayText
            headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
            headerTextLabel.text = self.headerTitles[section]
            headerView.addSubview(headerTextLabel)
            
            if section == 6 {
                var headerImageView: UIImageView = UIImageView(frame: CGRectMake((self.view.bounds.width - 32), 8, 16, 20))
                headerImageView.image = UIImage(named: "angle-right")
                headerImageView.contentMode = UIViewContentMode.ScaleAspectFit
                headerImageView.clipsToBounds = true
                headerView.addSubview(headerImageView)
            }
            
            return headerView
        } else {
            return UIView(frame: CGRectZero)
        }
    }
}

extension LanguageTranslationTableViewController: TranslationInputTableViewCellDelegate {
    func translationInputTableViewCell(cell: TranslationInputTableViewCell, onTextChanged textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension LanguageTranslationTableViewController: TranslationProductGroupTableViewCellDelegate {
    func translationProductGroupTableViewCell(cell: TranslationProductGroupTableViewCell, onTextChanged textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
