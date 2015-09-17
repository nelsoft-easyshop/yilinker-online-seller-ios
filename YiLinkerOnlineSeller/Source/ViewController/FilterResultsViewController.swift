//
//  FilterResultsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FilterResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , FilterViewControllerDelegate {

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var noResultsLabel: UILabel!
    
    @IBOutlet weak var searchFilterCollectionView: UICollectionView!
    
    var filterBySelected: String = ""
    
    var filterBy = ["Old to New", "New to Old", "A Week Ago", "A Month"]
    
    var dimView2: UIView!
    
    var searchModel: SearchModel?
    
    var currentPage: Int = 0
    var nextpage: Int = 0
    
    var allObjectArray: NSMutableArray = []
    var elements: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.separatorInset = UIEdgeInsetsZero
        self.filterTableView.layoutMargins = UIEdgeInsetsZero
        
        self.edgesForExtendedLayout = .None
        dimView2 = UIView(frame: UIScreen.mainScreen().bounds)
        dimView2.backgroundColor=UIColor.blackColor()
        dimView2.alpha = 0.5
        self.navigationController?.view.addSubview(dimView2)
        dimView2.hidden = true
        
        self.dimView.hidden = true
        self.noResultsLabel.hidden = true
        // Do any additional setup after loading the view.
        let tapSort = UITapGestureRecognizer(target: self, action: "sort");
        self.sortView.addGestureRecognizer(tapSort)
        
        let tapFilter = UITapGestureRecognizer(target: self, action: "filter")
        self.filterView.addGestureRecognizer(tapFilter)
        
        let nibFilter = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        self.filterTableView.registerNib(nibFilter, forCellReuseIdentifier: "FilterByTableViewCell")
        
        print("search model \(self.searchModel?.invoiceNumber.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sort() {
        if dimView.hidden {
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.hidden = false
                self.dimView.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.alpha = 0
                }, completion: { finished in
                    self.dimView.hidden = true
            })
        }

    }
    
    func filter(){
        self.showView()
        let filterViewController = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        filterViewController.providesPresentationContextTransitionStyle = true
        filterViewController.definesPresentationContext = true
        filterViewController.delegate = self
        self.tabBarController?.presentViewController(filterViewController, animated: true, completion: nil)
    }
    
    // Mark: - UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCellWithIdentifier("FilterByTableViewCell") as! FilterByTableViewCell
        cell.filterByLabel.text = filterBy[indexPath.row]
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
    }
    
    // Mark: - UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dimView.hidden = true
        let indexPath = tableView.indexPathForSelectedRow;
        filterBySelected = filterBy[indexPath!.row]
        //Add filto call filter collection view and reload
        print(filterBySelected)
    
    }

    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView2.alpha = 0
            }, completion: { finished in
                self.dimView2.hidden = true
        })
    }
    
    func showView(){
        dimView2.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView2.alpha = 0.5
            }, completion: { finished in
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
