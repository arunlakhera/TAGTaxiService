//
//  EditDriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/29/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class EditDriverViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{

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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var activeSegment: UISegmentedControl!
    
    
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
    var numberOfDaysForExpiry: Int?
    
    var activeRecord: String?
    
    // MARK: VARIABLES
    var storage: FIRStorage!
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    let dateDLValidFromPicker = UIDatePicker()
    let dateDLValidTillPicker = UIDatePicker()
    
    // Variable to set States Picker
    var statesArray = ["---","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()
    
    var policeVerfiedArray = ["---","Yes","No"]
    let policeVerifiedPicker = UIPickerView()
    
    var bloodGroupArray = ["---","O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodGroupPicker = UIPickerView()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        disableFields()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
        enableFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.stopActivity()
        self.disableFields()
        self.backButton.isEnabled = true

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storage = FIRStorage.storage()
        
        imagePicker.delegate = self
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
        
      //  activeSegment.isEnabled = false
        
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
        
        dateOfBirthTextField.inputAccessoryView = toolBarWithDoneButton
        stateTextField.inputAccessoryView = toolBarWithDoneButton
        DLValidFromTextField.inputAccessoryView = toolBarWithDoneButton
        DLValidTillTextField.inputAccessoryView = toolBarWithDoneButton
        policeVerifiedTextField.inputAccessoryView = toolBarWithDoneButton
        bloodGroupTextField.inputAccessoryView = toolBarWithDoneButton
        
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
        
        activeRecord = active
     //   print("====Active--\(active)==ActiveRecord---\(activeRecord)===")
        
        if activeRecord == "No"{
            activeSegment.selectedSegmentIndex = 1
        }else{
            activeSegment.selectedSegmentIndex = 0
        }
        
        for bg in bloodGroupArray{
            if bg == driverBloodGroup{
                bloodGroupTextField.text = bg
            }
        }
    
        let driverImageRef = DataService.ds.REF_DRIVER_IMAGE.child("\(String(describing: driverKey))")
        driverImageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if let pic = UIImage(data: data!){
                self.driverImageView.image = pic

            }else{
                self.driverImageView.image = UIImage(named: "PhotoAvatarJPG.jpg")

            }
        })
        
        self.stopActivity()
        
        // END IMAGE LOAD FOR DRIVER
       
       activeSegment.isEnabled = false
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
        let validFrom = dateformatter.date(from: DLValidFrom!)
        if ((sender.date).compare(validFrom!).rawValue > 0){
            DLValidTillTextField.text = dateformatter.string(from: sender.date)
            //self.view.endEditing(true)
        }else{
            self.showAlert(title: "Error", message: "DL Valid Till Date cannot be before DL Valid From Date")
        }
        //self.view.endEditing(true)
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
   
    @IBAction func activeSegmentSelected(_ sender: Any) {
        
        if activeSegment.selectedSegmentIndex == 0{
            activeRecord = "Yes"
        }else if activeSegment.selectedSegmentIndex == 1{
            activeRecord = "No"
        }
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }

    
    @IBAction func editButtonClicked(_ sender: Any) {
        saveButton.isHidden = false
        saveButton.isEnabled = false
       // backButton.isEnabled = false
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
        saveButton.isEnabled = true
        backButton.isEnabled = true
        uploadButton.isEnabled = true
        activeSegment.isEnabled = true
        
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

    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
    
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields(){
                
                startActivity()
                uploadButton.isEnabled = false
                backButton.isEnabled = false
                activeSegment.isEnabled = false
                
                editDriverDetail()
                
                // Enable Edit Button once changes have been saved
                
                saveButton.isHidden = true
                //disableFields()
                
            }
            
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
   
    }
    
    func editDriverDetail(){
        let driver = DataService.ds.REF_DRIVER.child(driverKey)
        
        if let driverImage = driverImageView.image {
            image = driverImage
        }else{
            image = UIImage(named: "PhotoAvatar.png")
        }
        
        let driverIDWithPath = String(describing: driverKey)
        let driverPath = String(describing: DataService.ds.REF_DRIVER)
        let driverImageID = driverIDWithPath.replacingOccurrences(of: driverPath, with: "")
        
        if let imgData = UIImageJPEGRepresentation(image!, 0.2){
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = DataService.ds.REF_DRIVER_IMAGE.child("\(driverImageID)").put(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil{
                    print("Unable to upload image")
                }else{
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    let driverID = DataService.ds.REF_DRIVER.child("\(self.driverKey)")
                    
                    driverID.child("ImageURL").setValue(downloadURL) {(error) in print("Error while Writing Image URL to Database")}
                    driver.child("FirstName").setValue(self.firstNameTextField.text) {(error) in print("Error while Writing First Name to Database")}
                    driver.child("LastName").setValue(self.lastNameTextField.text) {(error) in print("Error while Writing Last Name to Database")}
                    driver.child("PhoneNumber").setValue(self.phoneNumberTextField.text) {(error) in print("Error while Writing Phone Number to Database")}
                    driver.child("DateOfBirth").setValue(self.dateOfBirthTextField.text) {(error) in print("Error while Writing Date Of Birth to Database")}
                    driver.child("Address1").setValue(self.address1TextField.text) {(error) in print("Error while Writing Address 1 to Database")}
                    driver.child("Address2").setValue(self.address2TextField.text) {(error) in print("Error while Writing Address 2 to Database")}
                    driver.child("City").setValue(self.cityTextField.text) {(error) in print("Error while Writing City to Database")}
                    driver.child("State").setValue(self.stateTextField.text) {(error) in print("Error while Writing State to Database")}
                    driver.child("DLNumber").setValue(self.DLNumberTextField.text) {(error) in print("Error while Writing DL Number to Database")}
                    driver.child("DLValidFrom").setValue(self.DLValidFromTextField.text) {(error) in print("Error while Writing DL Valid From to Database")}
                    driver.child("DLValidTill").setValue(self.DLValidTillTextField.text) {(error) in print("Error while Writing DL Valid Till to Database")}
                    driver.child("PoliceVerified").setValue(self.policeVerifiedTextField.text) {(error) in print("Error while Writing Police Verified to Database")}
                    driver.child("BloodGroup").setValue(self.bloodGroupTextField.text) {(error) in print("Error while Writing Blood Group to Database")}
                    driver.child("Active").setValue(self.activeRecord!) {(error) in print("Error while Writing Active to Database")}
                    driverID.child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                    driverID.child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                }
            }
            uploadTask.observe(.success, handler: { (snapshot) in
                self.showAlert(title: "Saved", message: "Record Saved Successfully!")
                self.backButton.isEnabled = true
                self.editButton.isEnabled = true
            })
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
        if state == "---" {
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            
        } else if policeVerified == "---" {
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            
        }else if bloodGroup == "---"{
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            
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
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            self.stopActivity()
            self.disableFields()
            self.backButton.isEnabled = true
           // self.activeSegment.isEnabled = false
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
