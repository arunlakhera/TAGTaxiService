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
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: VARIABLES

    let imagePicker = UIImagePickerController()
  
    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    let dateDLValidFromPicker = UIDatePicker()
    let dateDLValidTillPicker = UIDatePicker()

    // Variable to set States Picker
    var states = ["Andra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()
    
    var policeVerfied = ["Yes","No"]
    let policeVerifiedPicker = UIPickerView()
    
    var bloodGroup = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodGroupPicker = UIPickerView()
    
    
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
        
        let toolBarWithDoneButton =  addDoneButton()
        
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        phoneNumberTextField.inputAccessoryView = toolBarWithDoneButton
        address1TextField.inputAccessoryView = toolBarWithDoneButton
        address2TextField.inputAccessoryView = toolBarWithDoneButton
        cityTextField.inputAccessoryView = toolBarWithDoneButton
        DLNumberTextField.inputAccessoryView = toolBarWithDoneButton
        
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
            rows = states.count
        }else if pickerView == policeVerifiedPicker{
            rows = policeVerfied.count
        }else if pickerView == bloodGroupPicker{
            rows = bloodGroup.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "--"
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
            self.dismiss(animated: true, completion: nil)
            
            driverImageView.image = driverImage
            
        }else{
            //Error
            self.showAlert(title: "Image Error", message: "Error in presenting the Image")
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activeSwitchClicked(_ sender: Any) {
        if activeSwitch.isOn{
            activeLabel.text = "Yes"
        }else{
            activeLabel.text = "No"
        }
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        //Save Driver Details
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields(){
                
                let driverID = DataService.ds.REF_DRIVER.childByAutoId()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-YYYY"
                
                driverID.child("FirstName").setValue(firstNameTextField.text)
                driverID.child("LastName").setValue(lastNameTextField.text)
                driverID.child("PhoneNumber").setValue(phoneNumberTextField.text)
                driverID.child("DateOfBirth").setValue(dateOfBirthTextField.text)
                driverID.child("Address1").setValue(address1TextField.text)
                driverID.child("Address2").setValue(address2TextField.text)
                driverID.child("City").setValue(cityTextField.text)
                driverID.child("State").setValue(stateTextField.text)
                driverID.child("DLNumber").setValue(DLNumberTextField.text)
                driverID.child("DLValidFrom").setValue(DLValidFromTextField.text)
                driverID.child("DLValidTill").setValue(DLValidTillTextField.text)
                driverID.child("PoliceVerified").setValue(policeVerifiedTextField.text)
                driverID.child("BloodGroup").setValue(bloodGroupTextField.text)
                driverID.child("Active").setValue(activeLabel.text)
                
                
               guard let image = driverImageView.image else{
                    print("Need to select an image")
                    return
                }
               
                let driverIDWithPath = String(describing: driverID)
                let driverPath = String(describing: DataService.ds.REF_DRIVER)
                let driverImageID = driverIDWithPath.replacingOccurrences(of: driverPath, with: "")
              
                if let imgData = UIImageJPEGRepresentation(image, 0.2){
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    DataService.ds.REF_DRIVER_IMAGE.child("\(driverImageID)").put(imgData, metadata: metadata) { (metadata, error) in
                        
                        if error != nil{
                            print("Unable to upload image")
                        }else{
                            print("Successfully Uploaded image")
                            let downloadURL = metadata?.downloadURL()?.absoluteString
                            driverID.child("ImageURL").setValue(downloadURL)
                        }
                    }
                }
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
