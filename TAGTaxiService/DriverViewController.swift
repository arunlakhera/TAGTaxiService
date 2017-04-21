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
    
    var driverKey = ""
    var driverList = [Driver]()
    var storage: FIRStorage!
  
    var count = 0
    var dname: String = ""
    let dateformatter = DateFormatter()
    let todayDate = Date()
    var today: String?
    var validTill: String?
    var numberOfDaysForExpiry: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        tableView.reloadData()
        
        DataService.ds.REF_DRIVER.observe(.value, with: { snapshot in
                self.driverList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print(snapshot)
                for snap in snapshots{
                    if let driverDict = snap.value as? Dictionary<String, String>{
                        
                        let driver = Driver(driverID: snap.key, dictionary: driverDict as Dictionary<String, AnyObject>)
                        self.driverKey = driver.driverID!
                        
                        self.driverList.append(driver)
               
                        self.validTill = (driver.drivingLicenseValidTill != nil ? driver.drivingLicenseValidTill : "2000-01-01" )
                        self.today = self.dateformatter.string(from: self.todayDate)
                        
                        self.numberOfDaysForExpiry = Int((self.dateformatter.date(from: self.validTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                   
                        if self.numberOfDaysForExpiry! <= 30 {
                            self.count += 1
                            self.dname = self.dname + "\n" + "\(driver.firstName != nil ? driver.firstName! : "First Name" ) \(driver.lastName != nil ? driver.lastName! : "Last Name" )"
                        }
                        
                    }
                }
                self.showAlert(title: "Alert!!", message: "Driving License Expiring for \(self.count) Drivers: \(self.dname)")
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
     
        let driverImageRef = DataService.ds.REF_DRIVER_IMAGE.child("\(String(describing: driver.driverID!))")
        driverImageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if data != nil{
                if let pic = UIImage(data: data!){
                    cell?.driverImage.image = pic
                }
            }else{
                cell?.driverImage.image = UIImage(named: "PhotoAvatarJPG.jpg")
            }
            cell?.nameLabel.text = (driver.firstName != nil ? driver.firstName! : "First Name"  ) + " " + (driver.lastName != nil ? driver.lastName! : "Last Name"  )
            cell?.phoneNumberLabel.text = driver.phoneNumber
            cell?.DLValidTill.text = driver.drivingLicenseValidTill
            
            self.validTill = (driver.drivingLicenseValidTill != nil ? driver.drivingLicenseValidTill : "2000-01-01" )
            self.today = self.dateformatter.string(from: self.todayDate)

            self.numberOfDaysForExpiry = Int((self.dateformatter.date(from: self.validTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
            
            if (self.numberOfDaysForExpiry! <= 30 && self.numberOfDaysForExpiry! >= 15 ) {
                cell?.backgroundColor = UIColor.orange
            }else if self.numberOfDaysForExpiry! < 15{
                cell?.backgroundColor = UIColor.red
            }
            
        })
        return cell!
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverEditSegue"{
            if let destinationVC = segue.destination as? EditDriverViewController{
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
                let driver = driverList[ip]
                
                destinationVC.driverKey = driver.driverID!
                destinationVC.firstName = driver.firstName != nil ? driver.firstName! : "Not Available"
                destinationVC.lastName = driver.lastName != nil ? driver.lastName! : "Not Available"
                destinationVC.phoneNumber = driver.phoneNumber != nil ? driver.phoneNumber! : "Not Available"
                destinationVC.dateOfBirth = driver.dateOfBirth != nil ? driver.dateOfBirth! : "Not Available"
                destinationVC.address1 = driver.address1 != nil ? driver.address1! : "Not Available"
                destinationVC.address2 = driver.address2 != nil ? driver.address2! : "Not Available"
                destinationVC.city = driver.city != nil ? driver.city! : "Not Available"
                destinationVC.state = driver.state != nil ? driver.state! : "Not Available"
                destinationVC.DLNumber = driver.drivingLicenseNo != nil ? driver.drivingLicenseNo! : "Not Available"
                destinationVC.DLValidFrom = driver.drivingLicenseValidFrom != nil ? driver.drivingLicenseValidFrom! : "Not Available"
                destinationVC.DLValidTill = driver.drivingLicenseValidTill != nil ? driver.drivingLicenseValidTill! : "Not Available"
                destinationVC.driverBloodGroup = driver.bloodGroup  != nil ? driver.bloodGroup! : "Not Available"
                destinationVC.policeVerified = driver.policeVerified != nil ? driver.policeVerified! : "Not Available"
                destinationVC.active = driver.active != nil ? driver.active! : "Not Available"
                
            }
        }
    
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
