//
//  EditVehicleViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 4/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class EditVehicleViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    @IBOutlet weak var permitExpiryDateTextField: UITextField!
    @IBOutlet weak var vehicleFitnessExpiryDateTextField: UITextField!
    
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var lastServiceDateTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!

    //MARK: Variables
    
    var vehicleKey = ""
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
    var permitExpiryDate = ""
    var vehicleFitnessExpiryDate = ""
    var mileage = ""
    var lastServiceDate = ""
    var active = ""
    
    // Variable for Date picker
    let vehicleModelYearPicker = UIDatePicker()
    let insuranceExpiryDatePicker = UIDatePicker()
    let pollutionCertificateExpiryDatePicker = UIDatePicker()
    let permitExpiryDatePicker = UIDatePicker()
    let vehicleFitnessExpiryDatePicker = UIDatePicker()
    let lastServiceDatePicker = UIDatePicker()
    
    var storage: FIRStorage!
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?

    
    // Variables for Vehicle Company Name & Type Picker
    var vehicleCompany = ["---","Maruti","Toyota","Mahindra","Tata","Chevrolet","Honda","Mercedes","BMW","Audi","Nissan","Datsun","Skoda"]
    let vehicleCompanyPicker = UIPickerView()
    
    var vehicleType = ["---","Small","Sedan","SUV"]
    let vehicleTypePicker = UIPickerView()
    
    var activityIndicator: UIActivityIndicatorView!
    
    func startActivity(){
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 150, y: 330, width: 100, height: 100)
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.color = UIColor.yellow
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
      
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func stopActivity(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = FIRStorage.storage()
        
        imagePicker.delegate = self
        vehicleCompanyNameTextField.delegate = self
        vehicleModelNameTextField.delegate = self
        vehicleNumberTextField.delegate = self
        vehicleTypeTextField.delegate = self
        vehicleRegistrationNumberTextField.delegate = self
        vehicleModelYearTextField.delegate = self
        insuranceNumberTextField.delegate = self
        pollutionCertificateNumberTextField.delegate = self
        pollutionCertificateExpiryDateTextField.delegate = self
        permitExpiryDateTextField.delegate = self
        vehicleFitnessExpiryDateTextField.delegate = self
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
        
        permitExpiryDatePicker.datePickerMode = UIDatePickerMode.date
        permitExpiryDateTextField.inputView = permitExpiryDatePicker
        permitExpiryDatePicker.addTarget(self, action: #selector(self.permitExpiryDatePickerValueChanged), for: .valueChanged)
        
        vehicleFitnessExpiryDatePicker.datePickerMode = UIDatePickerMode.date
        vehicleFitnessExpiryDateTextField.inputView = vehicleFitnessExpiryDatePicker
        vehicleFitnessExpiryDatePicker.addTarget(self, action: #selector(self.vehicleFitnessExpiryDatePickerValueChanged), for: .valueChanged)
        
        lastServiceDatePicker.datePickerMode = UIDatePickerMode.date
        lastServiceDateTextField.inputView = lastServiceDatePicker
        lastServiceDatePicker.addTarget(self, action: #selector(self.lastServiceDatePickerValueChanged), for: .valueChanged)
        
        // Add Done button to Keyboard
        
        let toolBarWithDoneButton =  addDoneButton()
        vehicleModelNameTextField.inputAccessoryView = toolBarWithDoneButton
        vehicleNumberTextField.inputAccessoryView = toolBarWithDoneButton
        insuranceNumberTextField.inputAccessoryView = toolBarWithDoneButton
        vehicleRegistrationNumberTextField.inputAccessoryView = toolBarWithDoneButton
        pollutionCertificateNumberTextField.inputAccessoryView = toolBarWithDoneButton
        mileageTextField.inputAccessoryView = toolBarWithDoneButton

        saveButton.isHidden = true
       
        self.startActivity()
        
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
        permitExpiryDateTextField.text = permitExpiryDate
        vehicleFitnessExpiryDateTextField.text = vehicleFitnessExpiryDate
        mileageTextField.text = mileage
        lastServiceDateTextField.text = lastServiceDate
        activeLabel.text = active
        
        if active == "No"{
            activeSwitch.isOn = false
        }else{
            activeSwitch.isOn = true
        }
        
        let vehicleImageRef = DataService.ds.REF_VEHICLE_IMAGE.child("\(String(describing: vehicleKey))")
        vehicleImageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if let pic = UIImage(data: data!){
                self.vehicleImageView.image = pic
                
            }else{
                self.vehicleImageView.image = UIImage(named: "PhotoAvatarJPG.jpg")
                
            }
        })

        self.stopActivity()
        
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
        permitExpiryDateTextField.isEnabled = false
        vehicleFitnessExpiryDateTextField.isEnabled = false
        mileageTextField.isEnabled = false
        lastServiceDateTextField.isEnabled = false
        uploadButton.isEnabled = false
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
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        insuranceExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func pollutionExpiryDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        pollutionCertificateExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func permitExpiryDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        permitExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func vehicleFitnessExpiryDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        vehicleFitnessExpiryDateTextField.text = dateformatter.string(from: sender.date)
        self.view.endEditing(true)
        
    }
    
    func lastServiceDatePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
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
        backButton.isEnabled = false
        saveButton.isHidden = false
        editButton.isEnabled = false
        
        enableFields()
    }
    
    @IBAction func uploadButtonClicked(_ sender: UIButton) {
        
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
        
        if let vehicleImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            vehicleImageView.image = vehicleImage
            self.dismiss(animated: true, completion: nil)
            
        }else{
            //Error
            self.showAlert(title: "Image Error", message: "Error in presenting the Image")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
        permitExpiryDateTextField.isEnabled = true
        vehicleFitnessExpiryDateTextField.isEnabled = true
        mileageTextField.isEnabled = true
        lastServiceDateTextField.isEnabled = true
        uploadButton.isEnabled = true
        activeSwitch.isEnabled = true
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if checkfield(){
        
                uploadButton.isEnabled = false
                activeSwitch.isEnabled = false
                
                let vehicleID = DataService.ds.REF_VEHICLE.child("\(self.vehicleKey)")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd"
                
                if let vehicleImage = vehicleImageView.image {
                    image = vehicleImage
                }else{
                    image = UIImage(named: "PhotoAvatarJPG.jpg")
                }
                
                let vehicleIDWithPath = String(describing: vehicleKey)
                let vehiclePath = String(describing: DataService.ds.REF_VEHICLE)
                let vehicleImageID = vehicleIDWithPath.replacingOccurrences(of: vehiclePath, with: "")
                
                if let imgData = UIImageJPEGRepresentation(image!, 0.2){
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    let uploadTask = DataService.ds.REF_VEHICLE_IMAGE.child("\(vehicleImageID)").put(imgData, metadata: metadata) { (metadata, error) in
                        
                        if error != nil{
                            print("Unable to upload image")
                        }else{
                            print("Successfully Uploaded image")
                            let downloadURL = metadata?.downloadURL()?.absoluteString
                            
                            vehicleID.child("ImageURL").setValue(downloadURL) {(error) in print("Error while Writing Image URL to Database")}
                            vehicleID.child("CompanyName").setValue(self.vehicleCompanyNameTextField.text) {(error) in print("Error while Writing Company Name to Database")}
                            vehicleID.child("ModelName").setValue(self.vehicleModelNameTextField.text) {(error) in print("Error while Writing Model Name to Database")}
                            vehicleID.child("VehicleNumber").setValue(self.vehicleNumberTextField.text) {(error) in print("Error while Writing Vehicle Number to Database")}
                            vehicleID.child("VehicleType").setValue(self.vehicleTypeTextField.text) {(error) in print("Error while Writing First Name to Database")}
                            vehicleID.child("RegistrationNumber").setValue(self.vehicleRegistrationNumberTextField.text) {(error) in print("Error while Writing Registration Number to Database")}
                            vehicleID.child("ModelYear").setValue(self.vehicleModelYearTextField.text) {(error) in print("Error while Writing Model Year to Database")}
                            vehicleID.child("InsuranceNumber").setValue(self.insuranceNumberTextField.text) {(error) in print("Error while Writing Insurance Number to Database")}
                            vehicleID.child("InsuranceExpiryDate").setValue(self.insuranceExpiryDateTextField.text) {(error) in print("Error while Writing Insurance Expiry Date to Database")}
                            vehicleID.child("PollutionCertificateNumber").setValue(self.pollutionCertificateNumberTextField.text) {(error) in print("Error while Writing Pollution Certificate Number to Database")}
                            vehicleID.child("PollutionCertificateExpiryDate").setValue(self.pollutionCertificateExpiryDateTextField.text) {(error) in print("Error while Writing Pollution Certificate Expiry Date to Database")}
                          
                            vehicleID.child("PermitExpiryDate").setValue(self.permitExpiryDateTextField.text){(error) in print("Error while Writing Permit Expiry Date to Database")}
                            vehicleID.child("VehicleFitnessExpiryDate").setValue(self.vehicleFitnessExpiryDateTextField.text){(error) in print("Error while Writing Vehicle Fitness Expiry Date to Database")}
                            
                            vehicleID.child("Mileage").setValue(self.mileageTextField.text) {(error) in print("Error while Writing First Name to Database")}
                            vehicleID.child("LastServiceDate").setValue(self.lastServiceDateTextField.text) {(error) in print("Error while Writing Mileage to Database")}
                            vehicleID.child("Active").setValue(self.activeLabel.text) {(error) in print("Error while Writing Active to Database")}

                            self.backButton.isEnabled = true
                            self.editButton.isEnabled = true

                        }
                    }
                    uploadTask.observe(.success, handler: { (snapshot) in
                        
                        self.showAlert(title: "Saved", message: "Record Saved Successfully!")
                        
                    })

                }
                
                saveButton.isHidden = true
                stopActivity()
                
            }else{
                showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
                
            }
        }
    
    }
    
    func checkfield() -> Bool{
        
        var checkFlag = true
        guard let vehicleName = vehicleCompanyNameTextField.text, let modelName = vehicleModelNameTextField.text, let vehicleNumber = vehicleNumberTextField.text , let vehicleType = vehicleTypeTextField.text, let registrationNumber = vehicleRegistrationNumberTextField.text, let modelYear = vehicleModelYearTextField.text, let insuranceNumber = insuranceNumberTextField.text, let pollutionCertificateNumber = pollutionCertificateNumberTextField.text, let pollutionCertificateExpiryDate = pollutionCertificateExpiryDateTextField.text, let permitExpiryDate = permitExpiryDateTextField.text,let vehicleFitnessExpiryDate = vehicleFitnessExpiryDateTextField.text, let mileage = mileageTextField.text, let lastServiceDate = lastServiceDateTextField.text else {
            
            checkFlag = false
            showAlert(title: "Error", message: "Please povide all the fields!!")
            return checkFlag
        }
        
        guard  vehicleName != "", modelName != "", vehicleNumber != "" , vehicleType != "", registrationNumber != "", modelYear != "", insuranceNumber != "", pollutionCertificateNumber != "", pollutionCertificateExpiryDate != "",permitExpiryDate != "",vehicleFitnessExpiryDate != "", mileage != "", lastServiceDate != "" else {
            
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
   
        var yValue = 0
        
        if (textField == vehicleRegistrationNumberTextField) || (textField == vehicleModelYearTextField)
        {
            yValue = 60
        }
        if (textField == insuranceNumberTextField) || (textField == insuranceExpiryDateTextField)
        {
            yValue = 75
        }
        if  (textField == pollutionCertificateNumberTextField) || (textField == pollutionCertificateExpiryDateTextField)
        {
            yValue = 100
        }
        if  (textField == permitExpiryDateTextField) || (textField == vehicleFitnessExpiryDateTextField)
        {
            yValue = 120
        }
        
        if (textField == mileageTextField) || (textField == lastServiceDateTextField)
        {
            yValue = 140
        }
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: yValue), animated: true)
        
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
