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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.title = "Country Store"
        self.tableView.registerNib(UINib(nibName: "CountryStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "countryId")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CountryStoreTableViewCell = tableView.dequeueReusableCellWithIdentifier("countryId") as! CountryStoreTableViewCell
        
        cell.flagImageView.sd_setImageWithURL(NSURL(string: flags[indexPath.row]))
        cell.countryLabel.text = countries[indexPath.row]
        
        let random = Int(arc4random_uniform(UInt32(3)))
        
        if random != 1 {
            cell.availableLabel.hidden = false
        }
        
        
        return cell
    }
    
    
    // MARK: - Table View Delegate

}
