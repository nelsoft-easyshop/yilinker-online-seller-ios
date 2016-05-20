//
//  CountryStoreViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/20/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountryStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let countries = ["China", "Cambodia", "Indonesia", "Malaysia", "Philippines", "Thailand", "Viewtnam"]
    let flags = ["http://wiki.erepublik.com/images/thumb/2/21/Flag-China.jpg/50px-Flag-China.jpg",
        "http://media.worldflags101.com/i/flags/cambodia.gif",
        "http://www.utazaselott.hu/userfiles/image/indonesian%20flag.jpg",
        "https://jeetkunedomalaysia.files.wordpress.com/2014/10/jeet-kune-do-jkd-malaysia-flag.gif",
        "http://images-mediawiki-sites.thefullwiki.org/04/3/7/0/95484361858573992.png",
        "http://www.thailanguagehut.com/wp-content/uploads/2010/04/Thai-Flag.gif",
        "http://www.therecycler.com/wp-content/uploads/2013/03/Vietnam-flag.jpg"]
    
    var countryListModel: [CountryListModel] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fireGetCountries()
        setupNavigationBar()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.registerNib(UINib(nibName: "CountryStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "countryId")
    }

    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Country Store"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
    }

    func populateData() {
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Requests
    
    func fireGetCountries() {
        
        println(APIAtlas.getCountrySetupDetails)
        println(SessionManager.accessToken())
        
        let url = "http://dev.seller.online.api.easydeal.ph/api/v3/ph/en/auth/country-setup/country-store?access_token=NTg3M2NjOGUxMmYwNjI0NTNhYzNkOTIyNjgzNjZjZjdiZThiNDE0ZDE2ZjIzM2Y0OWZkNGIxNGEwZDlmZDljMg"
        // APIAtlas.getCountrySetupDetails + SessionManager.accessToken()
        
        WebServiceManager.fireGetListOfCountries(url, productId: "964", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            if successful {
                
//                println(responseObject)
                
                var responseList: NSArray = (responseObject["data"] as? NSArray)!

                self.countryListModel = []
                
                if responseList.count != 0 {
                    
                    for response in responseList {
                        self.countryListModel.append(CountryListModel.parseDataWithDictionary(response))
                    }
                    
                } else {
                    println("No countries.")
                }
                
                self.populateData()
//                println(countryListModel.count)
                
            } else {
                println("Failed")
            }
            
        })
        
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.countryListModel.count != 0 {
            return self.countryListModel.count
        }
        
        return countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CountryStoreTableViewCell = tableView.dequeueReusableCellWithIdentifier("countryId") as! CountryStoreTableViewCell
        cell.selectionStyle = .None
        
        if self.countryListModel.count != 0 {
            cell.flagImageView.sd_setImageWithURL(NSURL(string: self.countryListModel[indexPath.row].flag))
            cell.countryLabel.text = self.countryListModel[indexPath.row].name
            if self.countryListModel[indexPath.row].isAvailable {
                cell.availableLabel.hidden = false
            }
        } else {
            cell.flagImageView.sd_setImageWithURL(NSURL(string: flags[indexPath.row]))
            cell.countryLabel.text = countries[indexPath.row]
            
            let random = Int(arc4random_uniform(UInt32(3)))
            
            if random != 1 {
                cell.availableLabel.hidden = false
            }
        }
        
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let countryStoreSetup: CountryStoreSetupViewController = CountryStoreSetupViewController(nibName: "CountryStoreSetupViewController", bundle: nil)
        countryStoreSetup.countryStoreModel = self.countryListModel[indexPath.row]
        self.navigationController?.pushViewController(countryStoreSetup, animated: true)
        
    }

}
