//
//  BookARideViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/6/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class BookARideViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Outlets
    
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var travelFromTextField: UITextField!
    @IBOutlet weak var travelToTextField: UITextField!
    @IBOutlet weak var roundTripLabel: UILabel!
    @IBOutlet weak var roundTripSwitch: UISwitch!
    @IBOutlet weak var travelBeginDateTextField: UITextField!
    @IBOutlet weak var travelEndDateTextField: UITextField!
    @IBOutlet weak var noOfTravellersLabel: UILabel!
    @IBOutlet weak var typeOfVehicleTextField: UITextField!
    
    // MARK: Variables
    var travelFrom = ""
    var noOfTravellers = 1
    var todayDate = NSDate()
    
    // MARK: Picker variable for Vehicle Type Picker View
    var vehicleType = ["SMALL","SEDAN","SUV"]
    var picker = UIPickerView()
    
    // MARK: Picker Variable for Date picker
    var travelBeginDatePicker = UIDatePicker()
    var travelEndDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Mark: Make Name Textfield as first responder and set the no of travellers to 1
        nameTexField.becomeFirstResponder()
        noOfTravellersLabel.text = String(noOfTravellers)
        
        // Set Picker delegate and datasource to self
        picker.delegate = self
        picker.dataSource = self
        
        // Assign vehicle picker to typeOfVehicle field
        typeOfVehicleTextField.inputView = picker
        
        //Assign date picker to travelBeginDate field
        travelBeginDateTextField.inputView = travelBeginDatePicker
        travelEndDateTextField.inputView = travelEndDatePicker
        
        travelBeginDatePicker.addTarget(self, action: #selector(BookARideViewController.travelBeginDatePicker(sender:)), for: .valueChanged)
        travelEndDatePicker.addTarget(self, action: #selector(BookARideViewController.travelEndDatePicker(sender:)), for: .valueChanged)
        
    }
    
    // MARK: Picker View Methods for Type of Vehicle PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicleType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfVehicleTextField.text = vehicleType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicleType[row]
    }
    
    // Function to remove Picker view from screen once the user has selected and touched the screen putside view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Travel Date picker function
    
    func travelBeginDatePicker(sender: UIDatePicker){
    
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-YYYY"
        travelBeginDateTextField.text = formatter.string(from: sender.date)
        
        if sender.date < todayDate as Date{
            self.errorLogin(errTitle: "Error", errMessage: "You have selected Travel Date from Past. Booking can be done only for future Dates")
        }
    }
    
    func travelEndDatePicker(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-YYYY"
        
        travelEndDateTextField.text = formatter.string(from: sender.date)
        
        if  sender.date < formatter.date(from: travelBeginDateTextField.text!)!  {
            self.errorLogin(errTitle: "Error", errMessage: "Your Return date cannot be before Travel Begin Date. Please select another Return Date ")
        }
    }

    // MARK: Actions
    
    @IBAction func addNoOfTravellers(_ sender: Any) {
        if noOfTravellers <= 7{
                noOfTravellers += 1
                noOfTravellersLabel.text = String(noOfTravellers)
        }
    }
    @IBAction func reduceNoOfTravellers(_ sender: Any) {
        if noOfTravellers != 1{
            noOfTravellers -= 1
            noOfTravellersLabel.text = String(noOfTravellers)
        }
    }
    
    @IBAction func roundTrip(_ sender: Any) {
       
        if roundTripSwitch.isOn{
            roundTripLabel.text = "Yes"
            travelEndDateTextField.isEnabled = true
            travelEndDateTextField.isHidden = false
        }else{
            roundTripLabel.text = "No"
            travelEndDateTextField.isEnabled = false
            travelEndDateTextField.isHidden = true
        }
        
    }
    
    @IBAction func askQuoteButton(_ sender: UIButton) {
        
        if checkFields(){
            
            // Get the unique Booking ID
            let rideBookID = DataService.ds.REF_RIDEBOOKING.childByAutoId()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-YYYY"
            
            rideBookID.child("RiderID").setValue(riderID)
            rideBookID.child("VehicleID").setValue("")
            rideBookID.child("DriverID").setValue("")
            rideBookID.child("DateOfBooking").setValue(String(describing: todayDate))
            rideBookID.child("RideFrom").setValue(travelFromTextField.text?.capitalized)
            rideBookID.child("RideTo").setValue(travelToTextField.text?.capitalized)
            rideBookID.child("RideBeginDate").setValue(travelBeginDateTextField.text)
            rideBookID.child("RideEndDate").setValue(travelEndDateTextField.text)
            rideBookID.child("RoundTrip").setValue(roundTripLabel.text?.capitalized)
            rideBookID.child("NoOfTravellers").setValue(noOfTravellersLabel.text)
            rideBookID.child("CreatedOnDate").setValue(String(describing: todayDate))
            rideBookID.child("CreatedBy").setValue(riderID)
            rideBookID.child("LastUpdatedOnDate").setValue(String(describing: todayDate))
            rideBookID.child("UpdatedBy").setValue(riderID)
            
            // Set Default Admin Values
            rideBookID.child("Status").setValue("Pending")
            rideBookID.child("Amount").setValue("Pending")
            rideBookID.child("Vehicle").setValue("Pending")
            
            // Make Entry in Riders Table to know which Rider did the booking
            
            DataService.ds.REF_RIDER.child(riderID).child("Booking").child(rideBookID.key).setValue("True")
            
            // Perform Segue to Booking Status List
            self.performSegue(withIdentifier: "bookingStatusSegue", sender: UIButton())
        }
        
    }
    
    // Function to check required data in fields and making the field with error as the first responder for the user
    
    func checkFields() -> Bool{
        
        var checkFlag = false
        
        // remove any whitespace and special characters
        
        let name = nameTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNo = phoneNoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let travelFrom = travelFromTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let travelTo = travelToTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        if (name?.characters.count)! == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Name.")
            nameTexField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (phoneNo?.characters.count)!  != 10{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide Valid Phone Number.")
            phoneNoTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (travelFrom?.characters.count)! == 0{
            checkFlag = false
            self.errorLogin(errTitle: "Error", errMessage: "Please provide City Name from where you will be travelling.")
            travelFromTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (travelTo?.characters.count)! == 0{
            checkFlag = false
            self.errorLogin(errTitle: "Error", errMessage: "Please provide City Name of your Destination.")
            travelToTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        return checkFlag
    }
    
   
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
