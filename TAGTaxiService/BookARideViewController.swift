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
    
    @IBOutlet weak var travelFromTextField: UITextField!
    @IBOutlet weak var travelToTextField: UITextField!
    @IBOutlet weak var roundTripLabel: UILabel!
    @IBOutlet weak var roundTripSwitch: UISwitch!
    @IBOutlet weak var travelBeginDateTextField: UITextField!
    @IBOutlet weak var travelEndDateTextField: UITextField!
    @IBOutlet weak var noOfTravellersLabel: UILabel!
    @IBOutlet weak var typeOfVehicleTextField: UITextField!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var TravelEndDateImageView: UIImageView!
    
    // MARK: Variables
    var travelFrom = ""
    var noOfTravellers = 1
    
    var travelMinDate = NSDate() // Assign current date as minimum travel begin date
    var travelMaxDate: NSDate {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 90, to: Date(), options: [])! as NSDate
    }   // Allows max date to be selected for booking as 90 days from current date
    
    var travelEndMinDate = NSDate() // Travel End date is shown as current date by deafult
    
    let formatter = DateFormatter() // variable for date formatter
    
    // MARK: Picker variable for Vehicle Type Picker View
    var vehicleType = ["SMALL","SEDAN","SUV"]
    var typeOfVehiclePicker = UIPickerView()
    
    // MARK: Picker Variable for Date picker
    var travelBeginDatePicker = UIDatePicker()
    var travelEndDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Show only dates in picker
        travelBeginDatePicker.datePickerMode = UIDatePickerMode.date
        travelEndDatePicker.datePickerMode = UIDatePickerMode.date
        
        // Assign city name from main view if available
        travelFromTextField.text = TravelFromCity
        
        // By default show today date as travel date
       
       // showAlert(title: "Phone Number", message: AuthService.instance)
        
        formatter.dateFormat = "YYYY-MM-dd"
        travelBeginDateTextField.text = formatter.string(from: travelMinDate as Date)
        travelBeginDatePicker.minimumDate = travelMinDate as  Date
        travelBeginDatePicker.maximumDate = travelMaxDate as Date
        
        travelEndDateTextField.text = formatter.string(from: travelMinDate as Date)
        travelEndDatePicker.minimumDate  = travelMinDate as  Date
        travelEndDatePicker.maximumDate = travelMaxDate as Date
        
        // By default show Small
        typeOfVehicleTextField.text = vehicleType[0]
        
        noOfTravellersLabel.text = String(noOfTravellers)
        
        // Set Picker delegate and datasource to self
        typeOfVehiclePicker.delegate = self
        typeOfVehiclePicker.dataSource = self
        
        // Assign vehicle picker to typeOfVehicle field
        typeOfVehicleTextField.inputView = typeOfVehiclePicker
        
        //Assign date picker to travelBeginDate field
        travelBeginDateTextField.inputView = travelBeginDatePicker
        travelEndDateTextField.inputView = travelEndDatePicker
        
        travelBeginDatePicker.addTarget(self, action: #selector(BookARideViewController.travelBeginDatePicker(sender:)), for: .valueChanged)
        travelEndDatePicker.addTarget(self, action: #selector(BookARideViewController.travelEndDatePicker(sender:)), for: .valueChanged)
        
        // Variable to set Toolbar
        let toolBar = addDoneButton()
        
        travelFromTextField.inputAccessoryView = toolBar
        travelToTextField.inputAccessoryView = toolBar
       
        travelBeginDateTextField.inputView = travelBeginDatePicker
        travelEndDateTextField.inputView = travelEndDatePicker
        typeOfVehicleTextField.inputView = typeOfVehiclePicker
        
    }
   
    // Function to add Done Button in toolbar
    
    func addDoneButton() -> UIToolbar{
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        return toolBar
        
    }
    // Action to perform when Done button is clicked
    
    func doneClicked(){
        self.view.endEditing(true)
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
        self.view.endEditing(true)
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
       
        travelBeginDateTextField.text = formatter.string(from: sender.date)
        
        if (sender.date.compare(travelMinDate as Date).rawValue == -1){
           
            self.showAlert(title: "Error!", message: "Please select future date for booking")
            travelBeginDateTextField.becomeFirstResponder()
        }else{
            travelEndMinDate = sender.date as NSDate
            travelEndDateTextField.text = formatter.string(from: sender.date)
            
            self.view.endEditing(true)
            
        }
    }
    
    func travelEndDatePicker(sender: UIDatePicker){
        
        if (sender.date.compare(travelEndMinDate as Date).rawValue) == -1{
            self.showAlert(title: "Error!", message: "You selected Return date that is before your Travel Date. Please select correct Return Date")
            travelEndDateTextField.becomeFirstResponder()
            
        }else{
            travelEndDateTextField.text = formatter.string(from: sender.date)
            self.view.endEditing(true)
        }
}

    // MARK: Actions
    
    // Action when no of travellers buttons are added
    @IBAction func addNoOfTravellers(_ sender: Any) {
        if noOfTravellers <= 7{
                noOfTravellers += 1
                noOfTravellersLabel.text = String(noOfTravellers)
        }
    }
    
    // Action when no of travellers are reduced
    @IBAction func reduceNoOfTravellers(_ sender: Any) {
        if noOfTravellers != 1{
            noOfTravellers -= 1
            noOfTravellersLabel.text = String(noOfTravellers)
        }
    }
    
    // Action when round trip button is selected
    @IBAction func roundTrip(_ sender: Any) {
       
        if roundTripSwitch.isOn{
            roundTripLabel.text = "Yes"
            travelEndDateTextField.isEnabled = true
            travelEndDateTextField.isHidden = false
            returnDateLabel.isHidden = false
            TravelEndDateImageView.isHidden = false
        }else{
            roundTripLabel.text = "No"
            travelEndDateTextField.isEnabled = false
            travelEndDateTextField.isHidden = true
            returnDateLabel.isHidden = true
            TravelEndDateImageView.isHidden = true
        }
        
    }
    
    // Action when Ask Quote button is pressed
    
    @IBAction func askQuoteButton(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        if checkFields(){
            
            // Get the unique Booking ID
            
            let rideBookID = DataService.ds.REF_RIDEBOOKING.childByAutoId()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            
            rideBookID.child("RiderID").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Rider ID to Database")}
            rideBookID.child("VehicleID").setValue(""){(error) in print("Error while Writing Vehicle ID to Database")}
            rideBookID.child("DriverID").setValue(""){(error) in print("Error while Writing Driver ID to Database")}
            rideBookID.child("DateOfBooking").setValue(String(describing: travelMinDate)){(error) in print("Error while Writing Date Of Booking to Database")}
            rideBookID.child("RideFrom").setValue(travelFromTextField.text?.capitalized){(error) in print("Error while Writing Ride From to Database")}
            rideBookID.child("RideTo").setValue(travelToTextField.text?.capitalized){(error) in print("Error while Writing Ride To to Database")}
            rideBookID.child("RideBeginDate").setValue(travelBeginDateTextField.text){(error) in print("Error while Writing Ride Begin Date to Database")}
            rideBookID.child("RideEndDate").setValue(travelEndDateTextField.text){(error) in print("Error while Writing Ride End Date to Database")}
            rideBookID.child("RoundTrip").setValue(roundTripLabel.text?.capitalized){(error) in print("Error while Writing Round Trip to Database")}
            rideBookID.child("NoOfTravellers").setValue(noOfTravellersLabel.text){(error) in print("Error while Writing No of Travellers to Database")}
            rideBookID.child("CreatedOnDate").setValue(String(describing: travelMinDate)){(error) in print("Error while Writing Created on Date to Database")}
            rideBookID.child("CreatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Created By to Database")}
            rideBookID.child("LastUpdatedOnDate").setValue(String(describing: travelMinDate)){(error) in print("Error while Writing Last Updated On Date to Database")}
            rideBookID.child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
            
            // Set Default Admin Values
            rideBookID.child("Status").setValue("Pending"){(error) in print("Error while Writing Status to Database")}
            rideBookID.child("Amount").setValue("Pending"){(error) in print("Error while Writing Amount to Database")}
            rideBookID.child("Vehicle").setValue("Pending"){(error) in print("Error while Writing Vehicle to Database")}
            
            // Make Entry in Riders Table to know which Rider did the booking
            
            //DataService.ds.REF_RIDER.child(riderID).child("Booking").child(rideBookID.key).setValue("True")
            DataService.ds.REF_RIDER.child(AuthService.instance.riderID!).child("Booking").child(rideBookID.key).setValue("True")
            // Perform Segue to Booking Status List
            self.performSegue(withIdentifier: "bookingStatusSegue", sender: UIButton())
        }
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message

        }
    }
    
    // Function to check required data in fields and making the field with error as the first responder for the user
    
    func checkFields() -> Bool{
        
        var checkFlag = false
        
        // remove any whitespace and special characters
        
        let travelFrom = travelFromTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let travelTo = travelToTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        if (travelFrom?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Error!", message:  "Please provide City Name from where you will be travelling.")
            travelFromTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (travelTo?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Error!", message: "Please provide City Name of your Destination.")
            travelToTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        return checkFlag
    }
    
    
   
    // Alert function to show messages
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
