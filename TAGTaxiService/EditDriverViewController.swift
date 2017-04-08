//
//  EditDriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/29/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class EditDriverViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var DLNumberTextField: UITextField!
    @IBOutlet weak var DLValidFromTextField: UITextField!
    @IBOutlet weak var DLValidTillTextField: UITextField!
    @IBOutlet weak var policeVerifiedTextField: UITextField!
    @IBOutlet weak var bloodGroupTextField: UITextField!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    var driverKey = ""
    var firstName = "NA"
    var lastName = "NA"
    var dateOfBirth = "NA"
    var phoneNumber = "NA"
    var address1 = "NA"
    var address2 = "NA"
    var city = "NA"
    var state = "NA"
    var DLNumber = "NA"
    var DLValidFrom = "NA"
    var DLValidTill = "NA"
    var policeVerified = "NA"
    var driverBloodGroup = "NA"
    var active = "NA"
    
    // MARK: VARIABLES
    
    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    let dateDLValidFromPicker = UIDatePicker()
    let dateDLValidTillPicker = UIDatePicker()
    
    // Variable to set States Picker
    var statesArray = ["Andra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()
    
    var policeVerfiedArray = ["Yes","No"]
    let policeVerifiedPicker = UIPickerView()
    
    var bloodGroupArray = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodGroupPicker = UIPickerView()
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        
        activityIndicator.stopAnimating()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        phoneNumberTextField.delegate = self
        address1TextField.delegate = self
        address2TextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        DLNumberTextField.delegate = self
        DLValidFromTextField.delegate = self
        DLValidTillTextField.delegate = self
        policeVerifiedTextField.delegate = self
        bloodGroupTextField.delegate = self
        
        dateOfBirthPicker.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextField.inputView = dateOfBirthPicker
        dateOfBirthPicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        
        dateDLValidFromPicker.datePickerMode = UIDatePickerMode.date
        DLValidFromTextField.inputView = dateDLValidFromPicker
        dateDLValidFromPicker.addTarget(self, action: #selector(self.dateDLValidFromPickerValueChanged), for: .valueChanged)
        
        dateDLValidTillPicker.datePickerMode = UIDatePickerMode.date
        DLValidTillTextField.inputView = dateDLValidTillPicker
        dateDLValidTillPicker.addTarget(self, action: #selector(self.dateDLValidTillPickerValueChanged), for: .valueChanged)
        
        statesPicker.delegate = self
        statesPicker.dataSource = self
        
        policeVerifiedPicker.delegate = self
        policeVerifiedPicker.dataSource = self
        
        bloodGroupPicker.delegate = self
        bloodGroupPicker.dataSource = self
        
        stateTextField.inputView = statesPicker
        policeVerifiedTextField.inputView = policeVerifiedPicker
        bloodGroupTextField.inputView = bloodGroupPicker
        
        let toolBarWithDoneButton =  addDoneButton()
        
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        phoneNumberTextField.inputAccessoryView = toolBarWithDoneButton
        address1TextField.inputAccessoryView = toolBarWithDoneButton
        address2TextField.inputAccessoryView = toolBarWithDoneButton
        cityTextField.inputAccessoryView = toolBarWithDoneButton
        DLNumberTextField.inputAccessoryView = toolBarWithDoneButton
        
        saveButton.isHidden = true
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        dateOfBirthTextField.text = dateOfBirth
        phoneNumberTextField.text = phoneNumber
        address1TextField.text = address1
        address2TextField.text = address2
        cityTextField.text = city
        DLNumberTextField.text = DLNumber
        DLValidFromTextField.text = DLValidFrom
        DLValidTillTextField.text = DLValidTill
       
        for s in statesArray{
            if s == state{
                stateTextField.text = s
            }
        }
        
        for pv in policeVerfiedArray{
            if pv == policeVerified{
                policeVerifiedTextField.text = pv
            }
        }
        
        activeLabel.text = active
     
        for bg in bloodGroupArray{
            if bg == driverBloodGroup{
                bloodGroupTextField.text = bg
            }
        }
        
        // Disable all fields
        
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        dateOfBirthTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        address1TextField.isEnabled = false
        address2TextField.isEnabled = false
        cityTextField.isEnabled = false
        stateTextField.isEnabled = false
        DLNumberTextField.isEnabled = false
        DLValidFromTextField.isEnabled = false
        DLValidTillTextField.isEnabled = false
        policeVerifiedTextField.isEnabled = false
        bloodGroupTextField.isEnabled = false
        activeLabel.isEnabled = false
        activeSwitch.isEnabled = false
        
    }

    func dateDLValidFromPickerValueChanged(_ sender: UIDatePicker){
      let dateformatter = DateFormatter()
     dateformatter.dateFormat = "dd-MM-YYYY"
        
        DLValidFromTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
    }
    
    func dateDLValidTillPickerValueChanged(_ sender: UIDatePicker){
       let dateformatter = DateFormatter()
       dateformatter.dateFormat = "dd-MM-YYYY"
        
        DLValidTillTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "dd-MM-YYYY"
        if ((sender.date).compare(NSDate() as Date).rawValue >= 0 ){
            
            showAlert(title: "Error!", message: "Date of Birth Needs to be corrected")
            
        }else{
            dateOfBirthTextField.text = dateformatter.string(from: sender.date)
            self.view.endEditing(true)
            
        }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        
        if pickerView == statesPicker{
            rows = statesArray.count
        }else if pickerView == policeVerifiedPicker{
            rows = policeVerfiedArray.count
        }else if pickerView == bloodGroupPicker{
            rows = bloodGroupArray.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "--"
        if pickerView == statesPicker{
            rowTitle = statesArray[row]
        }else if pickerView == policeVerifiedPicker{
            rowTitle = policeVerfiedArray[row]
        }else if pickerView == bloodGroupPicker{
            rowTitle = bloodGroupArray[row]
        }
        
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == statesPicker{
            stateTextField.text  = statesArray[row]
        }else if pickerView == policeVerifiedPicker{
            policeVerifiedTextField.text  = policeVerfiedArray[row]
        }else if pickerView == bloodGroupPicker{
            bloodGroupTextField.text  = bloodGroupArray[row]
        }
        
        self.view.endEditing(true)
    }
   
    @IBAction func activeSwitchClicked(_ sender: UISwitch) {
        if activeSwitch.isOn{
            activeLabel.text = "Yes"
        }else{
            activeLabel.text = "No"
        }
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        saveButton.isHidden = false
        editButton.isEnabled = false
        
        enableFields()
    }
    
    func enableFields(){
        
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        dateOfBirthTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        address1TextField.isEnabled = true
        address2TextField.isEnabled = true
        cityTextField.isEnabled = true
        stateTextField.isEnabled = true
        DLNumberTextField.isEnabled = true
        DLValidFromTextField.isEnabled = true
        DLValidTillTextField.isEnabled = true
        policeVerifiedTextField.isEnabled = true
        bloodGroupTextField.isEnabled = true
        activeLabel.isEnabled = true
        activeSwitch.isEnabled = true
    }
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
    
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields(){
                startActivity()
                let driver = DataService.ds.REF_DRIVER.child(driverKey)
                
                driver.child("FirstName").setValue(firstNameTextField.text)
                driver.child("LastName").setValue(lastNameTextField.text)
                driver.child("PhoneNumber").setValue(phoneNumberTextField.text)
                driver.child("DateOfBirth").setValue(dateOfBirthTextField.text)
                driver.child("Address1").setValue(address1TextField.text)
                driver.child("Address2").setValue(address2TextField.text)
                driver.child("City").setValue(cityTextField.text)
                driver.child("State").setValue(stateTextField.text)
                driver.child("DLNumber").setValue(DLNumberTextField.text)
                driver.child("DLValidFrom").setValue(DLValidFromTextField.text)
                driver.child("DLValidTill").setValue(DLValidTillTextField.text)
                driver.child("PoliceVerified").setValue(policeVerifiedTextField.text)
                driver.child("BloodGroup").setValue(bloodGroupTextField.text)
                driver.child("Active").setValue(activeLabel.text)
                
                // Enable Edit Button once changes have been saved
                editButton.isEnabled = true
                saveButton.isHidden = true
                stopActivity()
                self.performSegue(withIdentifier: "driverListSegue", sender: nil)
                
            }
            
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
   
    }
    
    func checkFields() -> Bool{
        
        var checkFlag = true
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let dateOfBirth = dateOfBirthTextField.text , let phoneNumber = phoneNumberTextField.text, let address1 = address1TextField.text, let address2 = address2TextField.text, let city = cityTextField.text, let state = stateTextField.text, let  DLNumber = DLNumberTextField.text, let DLValidFrom = DLValidFromTextField.text, let DLValidTill = DLValidTillTextField.text, let policeVerified = policeVerifiedTextField.text, let bloodGroup = bloodGroupTextField.text else {
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            return checkFlag
        }
        
        guard firstName != "", lastName != "", dateOfBirth != "", phoneNumber != "", address1 != "", address2 != "", city != "", state != "", DLNumber != "", DLValidFrom != "", DLValidTill != "", policeVerified != "", bloodGroup != "" else {
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
        if (textField == DLNumberTextField) || (textField == DLValidFromTextField) || (textField == DLValidTillTextField) || (textField == policeVerifiedTextField) || (textField == bloodGroupTextField)
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
