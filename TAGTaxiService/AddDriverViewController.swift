//
//  AddDriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/28/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
import Photos

class AddDriverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    // MARK: OUTLETS
    
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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var activeSegment: UISegmentedControl!
    
    
    // MARK: VARIABLES

    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    var activeRecord: String?
    
    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    let dateDLValidFromPicker = UIDatePicker()
    let dateDLValidTillPicker = UIDatePicker()

    // Variable to set States Picker
    var states = ["---","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()
    
    var policeVerfied = ["---","Yes","No"]
    let policeVerifiedPicker = UIPickerView()
    
    var bloodGroup = ["---","O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodGroupPicker = UIPickerView()
   
    var completeFlag = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        disableFields()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }
    
    func disableFields(){
        
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
        saveButton.isEnabled = false
        backButton.isEnabled = false
        uploadButton.isEnabled = false
        activeSegment.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeRecord = "Yes"
        
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
        
        imagePicker.delegate = self
        
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
        
        stateTextField.text = states[0]
        policeVerifiedTextField.text = policeVerfied[0]
        bloodGroupTextField.text = bloodGroup[0]
        
        let toolBarWithDoneButton =  addDoneButton()
        
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        phoneNumberTextField.inputAccessoryView = toolBarWithDoneButton
        address1TextField.inputAccessoryView = toolBarWithDoneButton
        address2TextField.inputAccessoryView = toolBarWithDoneButton
        cityTextField.inputAccessoryView = toolBarWithDoneButton
        DLNumberTextField.inputAccessoryView = toolBarWithDoneButton
        
        dateOfBirthTextField.inputAccessoryView = toolBarWithDoneButton
        stateTextField.inputAccessoryView = toolBarWithDoneButton
        DLValidFromTextField.inputAccessoryView = toolBarWithDoneButton
        DLValidTillTextField.inputAccessoryView = toolBarWithDoneButton
        policeVerifiedTextField.inputAccessoryView = toolBarWithDoneButton
        bloodGroupTextField.inputAccessoryView = toolBarWithDoneButton
        
    }
    
    func dateDLValidFromPickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        DLValidFromTextField.text = dateformatter.string(from: sender.date)
         //self.view.endEditing(true)
    }
    
    func dateDLValidTillPickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        let DLValidFrom = DLValidFromTextField.text
        let validFrom = (dateformatter.date(from: DLValidFrom!) != nil ? dateformatter.date(from: DLValidFrom!) : dateformatter.date(from: "2001-01-01"))
        if ((sender.date).compare(validFrom!).rawValue > 0){
            DLValidTillTextField.text = dateformatter.string(from: sender.date)
           // self.view.endEditing(true)
        }else{
            self.showAlert(title: "Error", message: "DL Valid Till Date cannot be before DL Valid From Date")
        }
    }

    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        if ((sender.date).compare(NSDate() as Date).rawValue >= 0 ){
            
            showAlert(title: "Error!", message: "Date of Birth Needs to be corrected")
            
            }else{
            dateOfBirthTextField.text = dateformatter.string(from: sender.date)
            //self.view.endEditing(true)
            
        }
    }
    
    func addDoneButton() -> UIToolbar{
        
        // MARK: Create toolbar with button
        let toolBar = UIToolbar()   // Create toolbar View
        toolBar.sizeToFit()             // calls sizeThatFits: with current view bounds and changes bounds size of toolbar.
        toolBar.backgroundColor = UIColor.orange
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
            rows = states.count
        }else if pickerView == policeVerifiedPicker{
            rows = policeVerfied.count
        }else if pickerView == bloodGroupPicker{
            rows = bloodGroup.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "---"
        if pickerView == statesPicker{
            rowTitle = states[row]
        }else if pickerView == policeVerifiedPicker{
            rowTitle = policeVerfied[row]
        }else if pickerView == bloodGroupPicker{
            rowTitle = bloodGroup[row]
        }
        
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == statesPicker{
            stateTextField.text  = states[row]
        }else if pickerView == policeVerifiedPicker{
            policeVerifiedTextField.text  = policeVerfied[row]
        }else if pickerView == bloodGroupPicker{
            bloodGroupTextField.text  = bloodGroup[row]
        }
        
        self.view.endEditing(true)
    }

    
    // MARK: ACTIONS
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        // Upload Image of Driver
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }else{
                self.showAlert(title: "Camera Alert", message: "Camera is Not Available!")            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.sourceType = .photoLibrary
               
               self.present(self.imagePicker, animated: true, completion: nil)
                
            }else{
                self.showAlert(title: "Photo Library Alert", message: "Photo Library is Not Available!")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let driverImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            driverImageView.image = driverImage
            self.dismiss(animated: true, completion: nil)
            
        }else{
            //Error
            self.showAlert(title: "Image Error", message: "Error in presenting the Image")
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activeSegmentSelected(_ sender: Any) {
        
        if activeSegment.selectedSegmentIndex == 0{
            activeRecord = "Yes"
        }else if activeSegment.selectedSegmentIndex == 1{
            activeRecord = "No"
        }
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields(){
            
                self.startActivity()
                
                saveButton.isEnabled = false
                saveButton.isHidden = true
                uploadButton.isEnabled = false
                backButton.isEnabled = false
                
                completeFlag = addDriverDetails()
               
                if completeFlag {
                    self.performSegue(withIdentifier: "driverListSegue", sender: nil)
                    self.stopActivity()
                    self.disableFields()
                }
            }
        
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
        
        
    }
    
    func addDriverDetails() -> Bool{
        
        let driverID = DataService.ds.REF_DRIVER.childByAutoId()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let driverIDWithPath = String(describing: driverID)
        let driverPath = String(describing: DataService.ds.REF_DRIVER)
        let driverImageID = driverIDWithPath.replacingOccurrences(of: driverPath, with: "")
        
        if let driverImage = driverImageView.image {
            image = driverImage
            
        }else{
            image = UIImage(named: "PhotoAvatarJPG.jpg")
            
        }
        
        if let imgData = UIImageJPEGRepresentation(image!, 0.2) {
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = DataService.ds.REF_DRIVER_IMAGE.child("\(driverImageID)").put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil{
                    print("Unable to upload image")
                }else{
                    print("Successfully Uploaded image")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    driverID.child("ImageURL").setValue(downloadURL) {(error) in print("Error while Writing Image URL to Database")}
                    driverID.child("FirstName").setValue(self.firstNameTextField.text) {(error) in print("Error while Writing First Name to Database")}
                    driverID.child("LastName").setValue(self.lastNameTextField.text) {(error) in print("Error while Writing Last Name to Database")}
                    driverID.child("PhoneNumber").setValue(self.phoneNumberTextField.text) {(error) in print("Error while Writing Phone Number to Database")}
                    driverID.child("DateOfBirth").setValue(self.dateOfBirthTextField.text) {(error) in print("Error while Writing Date of Birth to Database")}
                    driverID.child("Address1").setValue(self.address1TextField.text) {(error) in print("Error while Writing Address 1 to Database")}
                    driverID.child("Address2").setValue(self.address2TextField.text) {(error) in print("Error while Writing Address 2 to Database")}
                    driverID.child("City").setValue(self.cityTextField.text) {(error) in print("Error while Writing Cty to Database")}
                    driverID.child("State").setValue(self.stateTextField.text) {(error) in print("Error while Writing State to Database")}
                    driverID.child("DLNumber").setValue(self.DLNumberTextField.text) {(error) in print("Error while Writing DLNumber to Database")}
                    driverID.child("DLValidFrom").setValue(self.DLValidFromTextField.text) {(error) in print("Error while Writing DL Valid From to Database")}
                    driverID.child("DLValidTill").setValue(self.DLValidTillTextField.text) {(error) in print("Error while Writing DL Valid Till to Database")}
                    driverID.child("PoliceVerified").setValue(self.policeVerifiedTextField.text) {(error) in print("Error while Writing DL Valid From to Database")}
                    driverID.child("BloodGroup").setValue(self.bloodGroupTextField.text) {(error) in print("Error while Writing Blood Group to Database")}
                    driverID.child("Active").setValue(self.activeRecord!) {(error) in print("Error while Writing Active to Database")}
                    
                    driverID.child("CreatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Created on Date to Database")}
                    driverID.child("CreatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Created By to Database")}
                    driverID.child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                    driverID.child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                    
                }
            }
            uploadTask.observe(.success, handler: { (snapshot) in
                
                self.showAlert(title: "Saved", message: "Record Saved Successfully!")
                self.completeFlag = true
                
            })
            
        }
        
        return completeFlag
    }
    
    
    func checkFields() -> Bool{
       
        var checkFlag = true
       
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let dateOfBirth = dateOfBirthTextField.text ,
            let phoneNumber = phoneNumberTextField.text,
            let address1 = address1TextField.text,
            let address2 = address2TextField.text,
            let city = cityTextField.text,
            let state = stateTextField.text,
            let  DLNumber = DLNumberTextField.text,
            let DLValidFrom = DLValidFromTextField.text,
            let DLValidTill = DLValidTillTextField.text,
            let policeVerified = policeVerifiedTextField.text,
            let bloodGroup = bloodGroupTextField.text
            else {
                checkFlag = false
                showAlert(title: "Error", message: "Please povide all the fields!!")
                return checkFlag
            }
        
        guard firstName != "", lastName != "", dateOfBirth != "", phoneNumber != "", address1 != "", address2 != "", city != "", state != "", DLNumber != "", DLValidFrom != "", DLValidTill != "", policeVerified != "", bloodGroup != "" else {
            checkFlag = false
             showAlert(title: "Error", message: "Please povide all the fields!!")
            return checkFlag
        }
        
        if state == "---" {
            checkFlag = false
            showAlert(title: "Error", message: "Please povide State Name!!")

        } else if policeVerified == "---" {
            checkFlag = false
            showAlert(title: "Error", message: "Please povide detail if Driver is Police Verified!!")

        }else if bloodGroup == "---"{
            checkFlag = false
            showAlert(title: "Error", message: "Please povide Blood Group of Driver!")

        }
        
        return checkFlag
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("====>>>TOCHES BEGAN===")
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        var yValue = 0
        
        if (textField == cityTextField) || (textField == stateTextField)
        {
            yValue = 75
        }
        if  (textField == DLNumberTextField) || (textField == DLValidFromTextField) || (textField == DLValidTillTextField)
        {
            yValue = 85
        }
        if (textField == policeVerifiedTextField) || (textField == bloodGroupTextField)
        {
            yValue = 125
        }
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: yValue), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
       // self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.stopActivity()
            //self.disableFields()
            self.backButton.isEnabled = true
           // self.activeSegment.isEnabled = false
            
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    

}
