//
//  ProductUploadSearchViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadSearchViewController: UIViewController, UISearchBarDelegate {

    // Table view
    @IBOutlet weak var tableView: UITableView!
    
    // Global variable
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Initialize search bar
    func search() {
        self.view.layoutIfNeeded()
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width - 30, 44))
        self.searchBar!.becomeFirstResponder()
        self.searchBar!.tintColor = UIColor.whiteColor()
        self.searchBar!.placeholder = ProductUploadStrings.searchCategory
        self.searchBar!.showsCancelButton = true
        self.searchBar!.delegate = self
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: searchBar!)
    }
    
    // MARK: Serach bar delegate methods
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
