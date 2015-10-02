//
//  FilterResultsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FilterResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, FilterViewControllerDelegate {

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
        var tapSort = UITapGestureRecognizer(target: self, action: "sort");
        self.sortView.addGestureRecognizer(tapSort)
        
        var tapFilter = UITapGestureRecognizer(target: self, action: "filter")
        self.filterView.addGestureRecognizer(tapFilter)
        
        var nibFilter = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        self.filterTableView.registerNib(nibFilter, forCellReuseIdentifier: "FilterByTableViewCell")
        
        let collectionViewNib: UINib = UINib(nibName: "FilterResultsCollectionViewCellV2", bundle: nil)
        self.searchFilterCollectionView.registerNib(collectionViewNib, forCellWithReuseIdentifier: "FilterResultsCollectionViewCellV2")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if IphoneType.isIphone4()  {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 100, height: 79)
        } else if IphoneType.isIphone5() {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 80, height: 79)
        } else {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        }
        
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.searchFilterCollectionView.frame.size.width, 38)
        searchFilterCollectionView.collectionViewLayout = layout
        searchFilterCollectionView.dataSource = self
        searchFilterCollectionView.delegate = self

        /*
        for var i = 0; i < self.searchModel!.invoiceNumber.count; i++ {
            self.allObjectArray.addObject(i)
        }
        self.elements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(0, 20)))
        */
        
        self.title = "\(self.searchModel!.invoiceNumber.count) Results"
        
        self.backButton()
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
        var filterViewController = FilterViewController(nibName: "FilterViewController", bundle: nil)
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
        let indexPath = tableView.indexPathForSelectedRow();
        filterBySelected = filterBy[indexPath!.row]
        //Add filto call filter collection view and reload
        println(filterBySelected)
    
    }
    
    //MARK: Collection view delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchModel!.invoiceNumber.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : FilterResultsCollectionViewCellV2 = collectionView.dequeueReusableCellWithReuseIdentifier("FilterResultsCollectionViewCellV2", forIndexPath: indexPath) as! FilterResultsCollectionViewCellV2
        
        if self.searchModel != nil {
            cell.transactionIdLabel.text = self.searchModel?.invoiceNumber[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //self.showView()
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.bounds.size.width, CGFloat(139.0))
    }
    
    /*
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        nextpage = elements.count - 5
        if indexPath.row == nextpage {
            currentPage++
            nextpage = elements.count  - 5
            elements.addObjectsFromArray(allObjectArray.subarrayWithRange(NSMakeRange(currentPage, 20)))
            self.searchFilterCollectionView.reloadData()
        }

    }
    */
    
    //MARK: Navigation bar
    func backButton() {
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
