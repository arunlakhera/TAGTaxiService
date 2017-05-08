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
    var permitExpiryCount = 0
    var vehicleFitnessExpiryCount = 0
    
    let dateformatter = DateFormatter()
    let todayDate = Date()
    var today: String?
    var numberOfDaysForInsuranceExpiry: Int?
    var numberOfDaysForPollutionExpiry: Int?
    var numberOfDaysForPermitExpiry: Int?
    var numberOfDaysForVehicleFitnessExpiry: Int?
    
    var insuranceValidTill: String?
    var pollutionValidTill: String?
    var permitValidTill: String?
    var vehicleFitnessValidTill: String?
    
    var insuranceCount = 0
    var pollutionCount = 0
    var permitCount = 0
    var vehicleFitnessCount = 0
    
    var insuranceMessage = ""
    var pollutionMessage = ""
    var permitMessage = ""
    var vehicleFitnessMessage = ""
    var expiryMessage = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        //activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startActivity()
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        tableView.reloadData()
        
        DataService.ds.REF_VEHICLE.observe(.value, with: { snapshot in
            self.vehicleList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
               
                for snap in snapshots{
                    if let vehicleDict = snap.value as? Dictionary<String, String>{
                        
                        let vehicle = Vehicle(vehicleID: snap.key, dictionary: vehicleDict as Dictionary<String, AnyObject>)
                        self.vehicleKey = vehicle.vehicleID!
                        self.vehicleList.append(vehicle)
                   
                        self.insuranceValidTill = (vehicle.insurnaceExpDate != nil ? vehicle.insurnaceExpDate! : "2000-01-01" )
                        self.pollutionValidTill = (vehicle.pollutionCertExpDate != nil ? vehicle.pollutionCertExpDate! : "2000-01-01" )
                        self.permitValidTill = (vehicle.permitExpDate != nil ? vehicle.permitExpDate! : "2000-01-01" )
                        self.vehicleFitnessValidTill = (vehicle.vehicleFitnessExpDate != nil ? vehicle.vehicleFitnessExpDate! : "2000-01-01" )
                        
                        self.today = self.dateformatter.string(from: self.todayDate)
                      
                        self.numberOfDaysForInsuranceExpiry  = Int((self.dateformatter.date(from: self.insuranceValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        self.numberOfDaysForPollutionExpiry  = Int((self.dateformatter.date(from: self.pollutionValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        self.numberOfDaysForPermitExpiry  = Int((self.dateformatter.date(from: self.permitValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        self.numberOfDaysForVehicleFitnessExpiry  = Int((self.dateformatter.date(from: self.vehicleFitnessValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
                        
                        if self.numberOfDaysForInsuranceExpiry! <= 30 {
                            self.insuranceExpiryCount += 1
                            self.insuranceCount += 1
                        }
                       
                        if self.numberOfDaysForPollutionExpiry! <= 30 {
                            self.pollutionExpiryCount += 1
                            self.pollutionCount += 1
                        }
                     
                        if self.numberOfDaysForPermitExpiry! <= 30 {
                            self.permitExpiryCount += 1
                            self.permitCount += 1
                        }
                     
                        if self.numberOfDaysForVehicleFitnessExpiry! <= 30 {
                            self.vehicleFitnessExpiryCount += 1
                            self.vehicleFitnessCount += 1
                        }
                        
                    }
                }
                if self.insuranceCount > 0{
                    self.insuranceMessage = "Insurance Expiring for \(self.insuranceCount) Vehicles \n"
                }
                if self.pollutionCount > 0 {
                    self.pollutionMessage = "Pollution Certificate Expiring for \(self.pollutionCount) Vehicles \n"
                }
                if self.permitCount > 0{
                    self.permitMessage = "Permit Expiring for \(self.permitCount) Vehicles \n"
                }
                if self.vehicleFitnessCount > 0{
                    self.vehicleFitnessMessage = "Vehicle Fitness Expiring for \(self.vehicleFitnessCount) Vehicles \n"
                }
                
                self.expiryMessage = self.insuranceMessage + self.pollutionMessage + self.permitMessage + self.vehicleFitnessMessage
                
                if self.expiryMessage.characters.count > 0 {
                    self.showAlert(title: "Alert", message: self.expiryMessage)
                }
                // end
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
        
        cell?.companyNameLabel.text = vehicle.companyName!.capitalized + " " + vehicle.modelName!.capitalized
        cell?.carNumberLabel.text = vehicle.vehicleNumber?.capitalized
        cell?.insuranceExpiryDateLabel.text = vehicle.insurnaceExpDate
        cell?.pollutionExpiryDateLabel.text = vehicle.pollutionCertExpDate
        cell?.permitExpiryDateLabel.text = vehicle.permitExpDate
        cell?.vehicleFitnessExpiryDateLabel.text = vehicle.vehicleFitnessExpDate
        
        self.today = self.dateformatter.string(from: self.todayDate)
        
        self.insuranceValidTill = (vehicle.insurnaceExpDate != nil ? vehicle.insurnaceExpDate! : "2000-01-01" )
        self.pollutionValidTill = (vehicle.pollutionCertExpDate != nil ? vehicle.pollutionCertExpDate! : "2000-01-01" )
        
        self.permitValidTill = (vehicle.permitExpDate != nil ? vehicle.permitExpDate! : "2000-01-01" )
        self.vehicleFitnessValidTill = (vehicle.vehicleFitnessExpDate != nil ? vehicle.vehicleFitnessExpDate! : "2000-01-01" )
        
        self.numberOfDaysForInsuranceExpiry = Int((self.dateformatter.date(from: self.insuranceValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
       
        self.numberOfDaysForPollutionExpiry = Int((self.dateformatter.date(from: self.pollutionValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
        
        self.numberOfDaysForPermitExpiry = Int((self.dateformatter.date(from: self.permitValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
        
        self.numberOfDaysForVehicleFitnessExpiry = Int((self.dateformatter.date(from: self.vehicleFitnessValidTill!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
        
        if (self.numberOfDaysForInsuranceExpiry! <= 30 && self.numberOfDaysForInsuranceExpiry! >= 15 ){
            cell?.insuranceExpiryDateLabel.textColor = UIColor.yellow
            // Blink the Text
            cell?.insuranceExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
            {
                    cell?.insuranceExpiryDateLabel.alpha = 0
            }, completion: nil)
        }else if (self.numberOfDaysForInsuranceExpiry! < 15){
             cell?.insuranceExpiryDateLabel.textColor = UIColor.red
            // Blink the Text
            cell?.insuranceExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
            {
                cell?.insuranceExpiryDateLabel.alpha = 0
            }, completion: nil)
        }

        if (self.numberOfDaysForPollutionExpiry! <= 30 && self.numberOfDaysForPollutionExpiry! >= 15 ){
            cell?.pollutionExpiryDateLabel.textColor = UIColor.yellow
            
            // Blink the Text
            cell?.pollutionExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.pollutionExpiryDateLabel.alpha = 0
            }, completion: nil)
            
            
        }else if (self.numberOfDaysForPollutionExpiry! < 15){
            cell?.pollutionExpiryDateLabel.textColor = UIColor.red
            // Blink the Text
            cell?.pollutionExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.pollutionExpiryDateLabel.alpha = 0
            }, completion: nil)
        }

        if (self.numberOfDaysForPermitExpiry! <= 30 && self.numberOfDaysForPermitExpiry! >= 15 ){
            cell?.permitExpiryDateLabel.textColor = UIColor.yellow
            
            // Blink the Text
            cell?.permitExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.permitExpiryDateLabel.alpha = 0
            }, completion: nil)
            
            
        }else if (self.numberOfDaysForPermitExpiry! < 15){
            cell?.permitExpiryDateLabel.textColor = UIColor.red
            // Blink the Text
            cell?.permitExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.permitExpiryDateLabel.alpha = 0
            }, completion: nil)
        }
        
        if (self.numberOfDaysForVehicleFitnessExpiry! <= 30 && self.numberOfDaysForVehicleFitnessExpiry! >= 15 ){
            cell?.vehicleFitnessExpiryDateLabel.textColor = UIColor.yellow
            
            // Blink the Text
            cell?.vehicleFitnessExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.vehicleFitnessExpiryDateLabel.alpha = 0
            }, completion: nil)
            
            
        }else if (self.numberOfDaysForVehicleFitnessExpiry! < 15){
            cell?.vehicleFitnessExpiryDateLabel.textColor = UIColor.red
            // Blink the Text
            cell?.vehicleFitnessExpiryDateLabel.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    cell?.vehicleFitnessExpiryDateLabel.alpha = 0
            }, completion: nil)
        }
        self.stopActivity()
        return cell!
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editVehicleSegue"{
            if let destinationVC = segue.destination as? EditVehicleViewController{
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
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
                
                destinationVC.permitExpiryDate = vehicle.permitExpDate != nil ? vehicle.permitExpDate! : "Not Available"
                destinationVC.vehicleFitnessExpiryDate = vehicle.vehicleFitnessExpDate != nil ? vehicle.vehicleFitnessExpDate! :  "Not Available"
                
                destinationVC.mileage = vehicle.mileage != nil ? vehicle.mileage! : "Not Available"
                destinationVC.lastServiceDate = vehicle.lastServiceDate != nil ? vehicle.lastServiceDate! : "Not Available"
                destinationVC.active = vehicle.isActiveFlag != nil ? vehicle.isActiveFlag! : "Not Available"
               
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
