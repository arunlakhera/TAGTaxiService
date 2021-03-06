//
//  RiderProfileViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/13/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
import Photos

class RiderProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {

    // MARK: Outlets
    //@IBOutlet weak var riderPhotoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Rider Link
    //let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
    let riderID = AuthService.instance.riderID!
    let riderProfile = DataService.ds.REF_RIDER.child(AuthService.instance.riderID!).child("Profile")
    
// Variable to set Gender picker
    var gender = ["---","Male","Female"]
    let genderPicker = UIPickerView()
    
    // Variable to set States Picker
    var states = ["---","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    
    let statesPicker = UIPickerView()

    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        //activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        disableFields()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
        enableFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startActivity()
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
            // Call Load profile function
            self.loadProfile()
        }else{
            
            self.showAlert(title: "Profile", message: "Could not Load Profile as Internet Connection is not Available!") //Show Failure Message
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        statesPicker.delegate = self
        statesPicker.dataSource = self
        
        cityTextField.delegate = self
        stateTextField.delegate = self
        phoneTextField.delegate = self
        dateOfBirthTextField.delegate = self
        genderTextField.delegate = self
        
        genderTextField.inputView = genderPicker
        stateTextField.inputView = statesPicker
        
        dateOfBirthPicker.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextField.inputView = dateOfBirthPicker
        dateOfBirthPicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        
        // MARK: Create variable and assign return properties from addDoneButton()
        let toolBarWithDoneButton =  addDoneButton()
      
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        address1TextField.inputAccessoryView = toolBarWithDoneButton
        address2TextField.inputAccessoryView = toolBarWithDoneButton
        cityTextField.inputAccessoryView = toolBarWithDoneButton
        phoneTextField.inputAccessoryView = toolBarWithDoneButton
      
    }
    
    
    // MARK: Function to add toolbar to the Keyboard
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

    
    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        if ((sender.date).compare(NSDate() as Date).rawValue >= 0 ){
            showAlert(title: "Error!", message: "Date of Birth Needs to be corrected")
        }else{
            dateOfBirthTextField.text = dateformatter.string(from: sender.date)
           // self.view.endEditing(true)
         
            
        }
    }
    
    // Gender Picker Begin
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        if pickerView == genderPicker{
             rows = gender.count
        }else if pickerView == statesPicker{
            rows = states.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "--"
        if pickerView == genderPicker{
            rowTitle = gender[row]
        }else if pickerView == statesPicker{
            rowTitle = states[row]
        }
        
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == genderPicker{
            genderTextField.text  = gender[row]
        }else if pickerView == statesPicker{
            stateTextField.text  = states[row]
        }

        //genderTextField.text = gender[row]
        self.view.endEditing(true)
    }

    
        // Function to load the profile data if it already exists
    func loadProfile(){
        
           riderProfile.observe(.value, with: { snapshot in
            
            // if snapshot does not exists return
            if !snapshot.exists(){ self.showAlert(title: "ERROR in SNAPSHOT", message: "Snapshot Error")}
            
            if let riderProfile = snapshot.value as? Dictionary<String, String>{
                
                let rider = Rider(riderID: self.riderID, dictionary: riderProfile as Dictionary<String, AnyObject>)

                if let firstName = rider.firstName { self.firstNameTextField.text = firstName}
                if let lastName = rider.lastName { self.lastNameTextField.text = lastName}
                if let address1 = rider.address1 { self.address1TextField.text = address1}
                if let address2 = rider.address2 { self.address2TextField.text = address2}
                if let city = rider.city { self.cityTextField.text = city}
                if let state = rider.state { self.stateTextField.text = state}
                if let phone = rider.phoneNumber { self.phoneTextField.text = phone}
                if let dateOfBirth = rider.dateOfBirth { self.dateOfBirthTextField.text = dateOfBirth}
                if let gender = rider.gender { self.genderTextField.text = gender}
                if let emailID = rider.emailID { self.emailIDTextField.text = emailID}
                
           
            }
        })
        
        self.stopActivity()
        enableFields()
        
    }
       // Action to save the riders profile in firebase
    @IBAction func saveButton(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields()
            {
                self.startActivity()
                backButton.isEnabled = false
                saveButton.isEnabled = false
                saveButton.isHidden = true
                
                let todayDate = NSDate()
                riderProfile.child("FirstName").setValue(firstNameTextField.text){(error) in print("Error while Writing First Name to Database")}
                riderProfile.child("LastName").setValue(lastNameTextField.text){(error) in print("Error while Writing Last Name to Database")}
                riderProfile.child("PhoneNumber").setValue(phoneTextField.text){(error) in print("Error while Writing Phone Number to Database")}
                riderProfile.child("DateOfBirth").setValue(dateOfBirthTextField.text){(error) in print("Error while Writing Date Of Birth to Database")}
                riderProfile.child("Gender").setValue(genderTextField.text){(error) in print("Error while Writing Gender to Database")}
                riderProfile.child("AddressLine1").setValue(address1TextField.text){(error) in print("Error while Writing Address Line 1 to Database")}
                riderProfile.child("AddressLine2").setValue(address2TextField.text){(error) in print("Error while Writing Address Line 2 to Database")}
                riderProfile.child("City").setValue(cityTextField.text){(error) in print("Error while Writing City to Database")}
                riderProfile.child("State").setValue(stateTextField.text){(error) in print("Error while Writing State to Database")}
            
                riderProfile.child("CreatedOnDate").setValue(String(describing: todayDate)){(error) in print("Error while Writing Created On Date to Database")}
                riderProfile.child("LastUpdatedOnDate").setValue(String(describing: todayDate)){(error) in print("Error while Writing Last Updated On Date to Database")}
                riderProfile.child("CreatedBy").setValue(AuthService.instance.riderEmail!){(error) in print("Error while Writing Created By to Database")}
                riderProfile.child("UpdatedBy").setValue(AuthService.instance.riderEmail!){(error) in print("Error while Writing Updated By to Database")}
            
                self.showAlert(title: "Saved", message: "Record Saved Successfully")
                
                //self.performSegue(withIdentifier: "riderToMainSegue", sender: nil)
                backButton.isEnabled = true
            }
        
        }else{
    
            self.showAlert(title: "Save Profile", message: "Could not Save Profile as Internet Connection is not Available!") //Show Failure Message
        }
    }

    func checkFields() -> Bool{
   
        var checkFlag = false
        
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = firstName! + " " + lastName!
        let phoneNo = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name.characters.count) == 0{
            self.showAlert(title: "Error", message: "Please provide your Name.")
            firstNameTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }

        if (phoneNo?.characters.count)!  != 10{
            self.showAlert(title: "Error", message: "Please provide Valid Phone Number.")
            phoneTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
          return checkFlag
    }
    

    func enableFields(){
        
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        address1TextField.isEnabled = true
        address2TextField.isEnabled = true
        cityTextField.isEnabled = true
        stateTextField.isEnabled = true
        phoneTextField.isEnabled = true
        dateOfBirthTextField.isEnabled = true
        genderTextField.isEnabled = true
        emailIDTextField.isEnabled = true
        saveButton.isEnabled = true
        backButton.isEnabled = true
    }
    
    func disableFields(){
        
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        address1TextField.isEnabled = false
        address2TextField.isEnabled = false
        cityTextField.isEnabled = false
        stateTextField.isEnabled = false
        phoneTextField.isEnabled = false
        dateOfBirthTextField.isEnabled = false
        genderTextField.isEnabled = false
        emailIDTextField.isEnabled = false
        saveButton.isEnabled = false
        backButton.isEnabled = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var yValue = 0
        
        if (textField == cityTextField)
        {
            yValue = 80
        }
        if (textField == stateTextField)
        {
            yValue = 90
        }
        if (textField == phoneTextField)
        {
            yValue = 100
        }
        
        if (textField == dateOfBirthTextField)
        {
            yValue = 110
        }
        
        if (textField == genderTextField)
        {
            yValue = 120
        }
        scrollView.setContentOffset(CGPoint.init(x: 0, y: yValue), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       // let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
           self.stopActivity()
            self.disableFields()
            self.backButton.isEnabled = true
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        //self.stopActivity()
    }
    
}
