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
        
        cell?.companyNameLabel.text = vehicle.companyName
        cell?.modelNameLabel.text = vehicle.modelName
        cell?.carNumberLabel.text = vehicle.vehicleNumber
        cell?.modelYearLabel.text = vehicle.modelYear
        
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
