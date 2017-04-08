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
    
    var driverList = [Driver]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        DataService.ds.REF_DRIVER.observe(.value, with: { snapshot in
                self.driverList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print(snapshot)
                for snap in snapshots{
                    if let driverDict = snap.value as? Dictionary<String, String>{
                        
                        let driver = Driver(driverID: snap.key, dictionary: driverDict as Dictionary<String, AnyObject>)
                        self.driverList.append(driver)
                    }
                }
             self.tableView.reloadData()
            }
        })
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as? DriverListTableViewCell
        let driver = driverList[indexPath.row]
        
        cell?.nameLabel.text = driver.firstName! + " " + driver.lastName!
        cell?.phoneNumberLabel.text = driver.phoneNumber
        cell?.driverImage.image = UIImage(named: "TAG.png")
        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverEditSegue"{
            if let destinationVC = segue.destination as? EditDriverViewController{
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
                let driver = driverList[ip]
                
                destinationVC.driverKey = driver.driverID!
                destinationVC.firstName = driver.firstName!
                destinationVC.lastName = driver.lastName!
                destinationVC.phoneNumber = driver.phoneNumber!
                destinationVC.dateOfBirth = driver.dateOfBirth!
                destinationVC.address1 = driver.address1!
                destinationVC.address2 = driver.address2!
                destinationVC.city = driver.city!
                destinationVC.state = driver.state!
                destinationVC.DLNumber = driver.drivingLicenseNo!
                destinationVC.DLValidFrom = driver.drivingLicenseValidFrom!
                destinationVC.DLValidTill = driver.drivingLicenseValidTill!
                destinationVC.driverBloodGroup = driver.bloodGroup!
                destinationVC.policeVerified = driver.policeVerified!
                destinationVC.active = driver.active!
                
            }
        }
    
    }
}
