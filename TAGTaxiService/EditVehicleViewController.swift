//
//  EditVehicleViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 4/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class EditVehicleViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var vehicleCompanyNameTextField: UITextField!
    @IBOutlet weak var vehicleModelNameTextField: UITextField!
    @IBOutlet weak var vehicleNumberTextField: UITextField!
    @IBOutlet weak var vehicleTypeTextField: UITextField!
    @IBOutlet weak var vehicleRegistrationNumberTextField: UITextField!
    @IBOutlet weak var vehicleModelYearTextField: UITextField!
    @IBOutlet weak var insuranceNumberTextField: UITextField!
    @IBOutlet weak var insuranceExpiryDateTextField: UITextField!
    @IBOutlet weak var pollutionCertificateNumberTextField: UITextField!
    @IBOutlet weak var pollutionCertificateExpiryDateTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var lastServiceDateTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!

    //MARK: Variables
    
    var vehicleID = ""
    var vehicleCompanyName = ""
    var vehicleModelName = ""
    var vehicleNumber = ""
    var vehicleType1 = ""
    var vehicleRegistrationNumber = ""
    var vehicleModelYear = ""
    var insuranceNumber = ""
    var insuranceExpiryDate = ""
    var pollutionCertificateNumber = ""
    var pollutionCertificateExpiryDate = ""
    var mileage = ""
    var lastServiceDate = ""
    var active = ""
    
    // Variable for Date picker
    let vehicleModelYearPicker = UIDatePicker()
    let insuranceExpiryDatePicker = UIDatePicker()
    let pollutionCertificateExpiryDatePicker = UIDatePicker()
    let lastServiceDatePicker = UIDatePicker()
    
    // Variables for Vehicle Company Name & Type Picker
    var vehicleCompany = ["Maruti","Toyota","Mahindra","Tata","Chevrolet","Honda","Mercedes","BMW","Audi","Nissan","Datsun","Skoda"]
    let vehicleCompanyPicker = UIPickerView()
    
    var vehicleType = ["Small","Sedan","SUV"]
    let vehicleTypePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        vehicleCompanyNameTextField.delegate = self
        vehicleModelNameTextField.delegate = self
        vehicleNumberTextField.delegate = self
        vehicleTypeTextField.delegate = self
        vehicleRegistrationNumberTextField.delegate = self
        vehicleModelYearTextField.delegate = self
        insuranceNumberTextField.delegate = self
        pollutionCertificateNumberTextField.delegate = self
        pollutionCertificateExpiryDateTextField.delegate = self
        mileageTextField.delegate = self
        lastServiceDateTextField.delegate = self
        
        // Vehicle Company and Type Picker delegate / datasource / inputview
        vehicleCompanyPicker.delegate = self
        vehicleCompanyPicker.dataSource = self
        
        vehicleTypePicker.delegate = self
        vehicleTypePicker.dataSource = self
        
        vehicleCompanyNameTextField.inputView = vehicleCompanyPicker
        vehicleTypeTextField.inputView = vehicleTypePicker
        
        //Date Picker
        
        vehicleModelYearPicker.datePickerMode = UIDatePickerMode.date
        vehicleModelYearTextField.inputView = vehicleModelYearPicker
        vehicleModelYearPicker.addTarget(self, action: #selector(self.modelYearPickerValueChanged), for: .valueChanged)
        
        insuranceExpiryDatePicker.datePickerMode = UIDatePickerMode.date
        insuranceExpiryDateTextField.inputView = insuranceExpiryDatePicker
        insuranceExpiryDatePicker.addTarget(self, action: #selector(self.insuranceExpiryDatePickerValueChanged), for: .valueChanged)
        
        pollutionCertificateExpiryDatePicker.datePickerMode = UIDatePickerMode.date
        pollutionCertificateExpiryDateTextField.inputView = pollutionCertificateExpiryDatePicker
        pollutionCertificateExpiryDatePicker.addTarget(self, action: #selector(self.pollutionExpiryDatePickerValueChanged), for: .valueChanged)
        
        lastServiceDatePicker.datePickerMode = UIDatePickerMode.date
        lastServiceDateTextField.inputView = lastServiceDatePicker
        lastServiceDatePicker.addTarget(self, action: #selector(self.lastServiceDatePickerValueChanged), for: .valueChanged)
        
        // Add Done button to Keyboard
        
        let toolBarWithDoneButton =  addDoneButton()
        vehicleModelNameTextField.inputAccessoryView = toolBarWithDoneButton
        vehicleNumberTextField.inputAccessoryView = toolBarWithDoneButton
        vehicleRegistrationNumberTextField.inputAccessoryView = toolBarWithDoneButton
        pollutionCertificateNumberTextField.inputAccessoryView = toolBarWithDoneButton
        mileageTextField.inputAccessoryView = toolBarWithDoneButton

        saveButton.isHidden = true
        vehicleCompanyNameTextField.text = vehicleCompanyName
        vehicleModelNameTextField.text = vehicleModelName
        vehicleNumberTextField.text = vehicleNumber
        vehicleTypeTextField.text = vehicleType1
        vehicleRegistrationNumberTextField.text = vehicleRegistrationNumber
        vehicleModelYearTextField.text = vehicleModelYear
        insuranceNumberTextField.text = insuranceNumber
        insuranceExpiryDateTextField.text = insuranceExpiryDate
        pollutionCertificateNumberTextField.text = pollutionCertificateNumber
        pollutionCertificateExpiryDateTextField.text = pollutionCertificateExpiryDate
        mileageTextField.text = mileage
        lastServiceDateTextField.text = lastServiceDate
        activeLabel.text = active
        
        // Disable Fields
        vehicleCompanyNameTextField.isEnabled = false
        vehicleModelNameTextField.isEnabled = false
        vehicleNumberTextField.isEnabled = false
        vehicleTypeTextField.isEnabled = false
        vehicleRegistrationNumberTextField.isEnabled = false
        vehicleModelYearTextField.isEnabled = false
        insuranceNumberTextField.isEnabled = false
        insuranceExpiryDateTextField.isEnabled = false
        pollutionCertificateNumberTextField.isEnabled = false
        pollutionCertificateExpiryDateTextField.isEnabled = false
        mileageTextField.isEnabled = false
        lastServiceDateTextField.isEnabled = false
        activeSwitch.isEnabled = false
        
    }
    
    func modelYearPickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY"
        
        vehicleModelYearTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func insuranceExpiryDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-YYYY"
        
        insuranceExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func pollutionExpiryDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-YYYY"
        
        pollutionCertificateExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func lastServiceDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-YYYY"
        
        lastServiceDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func addDoneButton() -> UIToolbar{
        
        // MARK: Create toolbar with button
        let toolBar = UIToolbar()   // Create toolbar View
        toolBar.sizeToFit()             // calls sizeThatFits: with current view bounds and changes bounds size of toolbar.
        
        // Adds space on toolbar so that Done Button appears on right side of the toolbar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        // Adds Done button to the toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        // Adds Space and Done button to the Toolbar
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        return toolBar
        
    }
    
    // Function to Dismiss keyboards once Done button is clicked
    func doneClicked(){
        self.view.endEditing(true)
    }
    
    // PIcker Views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        
        if pickerView == vehicleCompanyPicker{
            rows = vehicleCompany.count
        }else if pickerView == vehicleTypePicker{
            rows = vehicleType.count
        }
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "--"
        if pickerView == vehicleCompanyPicker{
            rowTitle = vehicleCompany[row]
        }else if pickerView == vehicleTypePicker{
            rowTitle = vehicleType[row]
        }
        
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == vehicleCompanyPicker{
            vehicleCompanyNameTextField.text  = vehicleCompany[row]
        }else if pickerView == vehicleTypePicker{
            vehicleTypeTextField.text  = vehicleType[row]
        }
        self.view.endEditing(true)
    }
    
    @IBAction func activeSwitchToggled(_ sender: UISwitch) {
        if activeSwitch.isOn{
            activeLabel.text = "Yes"
        }else{
            activeLabel.text = "No"
        }
    }
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        saveButton.isHidden = false
        editButton.isEnabled = false
        
        enableFields()
    }
    
    func enableFields(){
        
        vehicleCompanyNameTextField.isEnabled = true
        vehicleModelNameTextField.isEnabled = true
        vehicleNumberTextField.isEnabled = true
        vehicleTypeTextField.isEnabled = true
        vehicleRegistrationNumberTextField.isEnabled = true
        vehicleModelYearTextField.isEnabled = true
        insuranceNumberTextField.isEnabled = true
        insuranceExpiryDateTextField.isEnabled = true
        pollutionCertificateNumberTextField.isEnabled = true
        pollutionCertificateExpiryDateTextField.isEnabled = true
        mileageTextField.isEnabled = true
        lastServiceDateTextField.isEnabled = true
        activeSwitch.isEnabled = true
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true
        {
            if checkfield(){
                
                let vehicleID = DataService.ds.REF_VEHICLE.child(self.vehicleID)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-YYYY"
                
                vehicleID.child("CompanyName").setValue(vehicleCompanyNameTextField.text)
                vehicleID.child("ModelName").setValue(vehicleModelNameTextField.text)
                vehicleID.child("VehicleNumber").setValue(vehicleNumberTextField.text)
                vehicleID.child("VehicleType").setValue(vehicleTypeTextField.text)
                vehicleID.child("RegistrationNumber").setValue(vehicleRegistrationNumberTextField.text)
                vehicleID.child("ModelYear").setValue(vehicleModelYearTextField.text)
                vehicleID.child("InsuranceNumber").setValue(insuranceNumberTextField.text)
                vehicleID.child("InsuranceExpiryDate").setValue(insuranceExpiryDateTextField.text)
                vehicleID.child("PollutionCertificateNumber").setValue(pollutionCertificateNumberTextField.text)
                vehicleID.child("PollutionCertificateExpiryDate").setValue(pollutionCertificateExpiryDateTextField.text)
                vehicleID.child("Mileage").setValue(mileageTextField.text)
                vehicleID.child("LastServiceDate").setValue(lastServiceDateTextField.text)
                vehicleID.child("Active").setValue(activeLabel.text)
                
                saveButton.isHidden = true
                editButton.isEnabled = true
                
                self.performSegue(withIdentifier: "vehicleListSegue", sender: nil)
            }else{
                showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
                
            }
        }
    
    }
    
    func checkfield() -> Bool{
        
        var checkFlag = true
        guard let vehicleName = vehicleCompanyNameTextField.text, let modelName = vehicleModelNameTextField.text, let vehicleNumber = vehicleNumberTextField.text , let vehicleType = vehicleTypeTextField.text, let registrationNumber = vehicleRegistrationNumberTextField.text, let modelYear = vehicleModelYearTextField.text, let insuranceNumber = insuranceNumberTextField.text, let pollutionCertificateNumber = pollutionCertificateNumberTextField.text, let pollutionCertificateExpiryDate = pollutionCertificateExpiryDateTextField.text, let mileage = mileageTextField.text, let lastServiceDate = lastServiceDateTextField.text else {
            
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            return checkFlag
        }
        
        guard  vehicleName != "", modelName != "", vehicleNumber != "" , vehicleType != "", registrationNumber != "", modelYear != "", insuranceNumber != "", pollutionCertificateNumber != "", pollutionCertificateExpiryDate != "", mileage != "", lastServiceDate != "" else {
            
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            return checkFlag
        }
        
        
        return checkFlag
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == insuranceNumberTextField) || (textField == insuranceExpiryDateTextField) || (textField == pollutionCertificateNumberTextField) || (textField == pollutionCertificateExpiryDateTextField) || (textField == mileageTextField) || (textField == lastServiceDateTextField)
        {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 70), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }

    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
