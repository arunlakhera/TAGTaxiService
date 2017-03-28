//
//  DriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/28/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class DriverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var driverName = ["D1","D2","D3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as? DriverListTableViewCell
        
        cell?.nameLabel.text = driverName[indexPath.row]
        cell?.phoneNumberLabel.text = "123-456-7890"
        cell?.driverImage.image = UIImage(named: "TAG.png")
        return cell!
    }

    
}
