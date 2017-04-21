//
//  VehicleViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 4/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class VehicleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var vehicleList = [Vehicle]()
    var storage: FIRStorage!
    var vehicleKey = ""
    
    var insuranceExpiryCount = 0
    var pollutionExpiryCount = 0
    
    let dateformatter = DateFormatter()
    let todayDate = Date()
    var today: String?
    var numberOfDaysForInsuranceExpiry: Int?
    var numberOfDaysForPollutionExpiry: Int?
    var insuranceValidTill: String?
    var pollutionValidTill: String?
    
     override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        DataService.ds.REF_VEHICLE.observe(.value, with: { snapshot in
            self.vehicleList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print(snapshot)
                for snap in snapshots{
                    if let vehicleDict = snap.value as? Dictionary<String, String>{
                        
                        let vehicle = Vehicle(vehicleID: snap.key, dictionary: vehicleDict as Dictionary<String, AnyObject>)
                        self.vehicleKey = vehicle.vehicleID!
                        self.vehicleList.append(vehicle)
                   /*
                        self.insuranceValidTill = (vehicle.insurnaceExpDate != nil ? vehicle.insurnaceExpDate : "2000-01-01" )
                        self.pollutionValidTill = (vehicle.pollutionCertExpDate != nil ? vehicle.pollutionCertExpDate : "2000-01-01" )
                        self.today = self.dateformatter.string(from: self.todayDate)
                        
                        self.numberOfDaysForInsuranceExpiry  = Int((self.dateformatter.date(from: self.insuranceValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        
                        self.numberOfDaysForPollutionExpiry  = Int((self.dateformatter.date(from: self.pollutionValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        
                        if self.numberOfDaysForInsuranceExpiry! <= 30 {
                            self.insuranceExpiryCount += 1
                        }
                       
                        if self.numberOfDaysForPollutionExpiry! <= 30 {
                            self.pollutionExpiryCount += 1
                        }
                     */
                        
                    }
                }
                self.tableView.reloadData()
            }
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath) as? VehicleListTableViewCell
        let vehicle = vehicleList[indexPath.row]
        
        cell?.companyNameLabel.text = vehicle.companyName! + " " + vehicle.modelName!
        cell?.carNumberLabel.text = vehicle.vehicleNumber
        cell?.insuranceExpiryDate.text = vehicle.insurnaceExpDate
        cell?.pollutionCertExpiryDate.text = vehicle.pollutionCertExpDate
       /*
        self.today = self.dateformatter.string(from: self.todayDate)
        
        self.insuranceValidTill = (vehicle.insurnaceExpDate != nil ? vehicle.insurnaceExpDate : "2000-01-01" )
        self.pollutionValidTill = (vehicle.pollutionCertExpDate != nil ? vehicle.pollutionCertExpDate : "2000-01-01" )
        
        self.numberOfDaysForInsuranceExpiry = Int((self.dateformatter.date(from: self.insuranceValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
       
        self.pollutionExpiryCount = Int((self.dateformatter.date(from: self.pollutionValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
        
        if (self.numberOfDaysForInsuranceExpiry! <= 30 && self.numberOfDaysForInsuranceExpiry! >= 15 ) || (self.numberOfDaysForPollutionExpiry! <= 30 && self.numberOfDaysForPollutionExpiry! >= 15 ){
            cell?.backgroundColor = UIColor.orange
        }else if (self.numberOfDaysForInsuranceExpiry! < 15) || (self.numberOfDaysForPollutionExpiry! < 15){
            cell?.backgroundColor = UIColor.red
        }
        */
        
        return cell!
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editVehicleSegue"{
            if let destinationVC = segue.destination as? EditVehicleViewController{
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
                print("====ip \(ip)")
                let vehicle = vehicleList[ip]
                
                destinationVC.vehicleKey = vehicle.vehicleID!
                destinationVC.vehicleCompanyName = vehicle.companyName != nil ? vehicle.companyName! : "Not Available"
                destinationVC.vehicleNumber = vehicle.vehicleNumber != nil ? vehicle.vehicleNumber! : "Not Available"
                destinationVC.vehicleRegistrationNumber = vehicle.registrationNumber != nil ? vehicle.registrationNumber! : "Not Available"
                destinationVC.vehicleType1 = vehicle.vehicleType != nil ? vehicle.vehicleType! : "Not Available"
                destinationVC.vehicleModelName = vehicle.modelName != nil ? vehicle.modelName! : "Not Available"
                destinationVC.vehicleModelYear = vehicle.modelYear != nil ? vehicle.modelYear! : "Not Available"
                destinationVC.insuranceNumber = vehicle.insuranceNumber != nil ? vehicle.insuranceNumber! : "Not Available"
                destinationVC.insuranceExpiryDate = vehicle.insurnaceExpDate != nil ? vehicle.insurnaceExpDate! : "Not Available"
                destinationVC.pollutionCertificateNumber = vehicle.pollutionCertNumber != nil ? vehicle.pollutionCertNumber! : "Not Available"
                destinationVC.pollutionCertificateExpiryDate = vehicle.pollutionCertExpDate != nil ? vehicle.pollutionCertExpDate! : "Not Available"
                destinationVC.mileage = vehicle.mileage != nil ? vehicle.mileage! : "Not Available"
                destinationVC.lastServiceDate = vehicle.lastServiceDate != nil ? vehicle.lastServiceDate! : "Not Available"
                destinationVC.active = vehicle.isActiveFlag != nil ? vehicle.isActiveFlag! : "Not Available"
               
            }
        }
        
    }
    

}
