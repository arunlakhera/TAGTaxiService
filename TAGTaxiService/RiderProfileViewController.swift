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

class RiderProfileViewController: UIViewController, /*UINavigationControllerDelegate, UIImagePickerControllerDelegate,*/UIPickerViewDataSource, UIPickerViewDelegate {

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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Rider Link
    //let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
    let riderID = AuthService.instance.riderID!
    let riderProfile = DataService.ds.REF_RIDER.child(AuthService.instance.riderID!).child("Profile")
    
// Variable to set Gender picker
    var gender = ["Male","Female"]
    let genderPicker = UIPickerView()
    
    // Variable to set States Picker
    var states = ["Andra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()

    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        
        activityIndicator.stopAnimating()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        statesPicker.delegate = self
        statesPicker.dataSource = self
        
        genderTextField.inputView = genderPicker
        stateTextField.inputView = statesPicker
        
        dateOfBirthPicker.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextField.inputView = dateOfBirthPicker
        dateOfBirthPicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
            // Call Load profile function
            self.loadProfile()
        }else{
           
            self.showAlert(title: "Profile", message: "Could not Load Profile as Internet Connection is not Available!") //Show Failure Message
        }
        
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
        
        dateformatter.dateFormat = "dd-MM-YYYY"
        if ((sender.date).compare(NSDate() as Date).rawValue >= 0 ){
            showAlert(title: "Error!", message: "Date of Birth Needs to be corrected")
        }else{
            dateOfBirthTextField.text = dateformatter.string(from: sender.date)
            self.view.endEditing(true)
         
            
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
       
    }
    
        // Function to load the profile data if it already exists
    func loadProfile(){
        
           self.startActivity()
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
                
                // Profile Photo
                
               /* let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(riderID).jpg"
                
                self.storageRef.child(imagePath).data(withMaxSize: 5 * 1024 * 1024, completion: { (data, error) in
                    
                    if error != nil{
                            print("Error occured while downloading image")
                    }else{
                            print("Image Downloaded Successfully")
                            let image = UIImage(data: data!)
                            self.riderPhotoImageView.image = image
                   }
                })
             */
            }
        })
        
        self.stopActivity()
        enableFields()
        
    }
    /*
    @IBAction func uploadPhotoButton(_ sender: Any) {
     
       
        image.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.image.sourceType = .camera
                self.present(self.image, animated: true, completion: nil)
            }else{
                self.showAlert(title: "Camera Alert", message: "Camera is Not Available!")            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.image.sourceType = .photoLibrary
                self.present(self.image, animated: true, completion: nil)
            }else{
                self.showAlert(title: "Photo Library Alert", message: "Photo Library is Not Available!")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
 */
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            riderPhotoImageView.image = image
            
        }else{
            // Error
            self.showAlert(title: "Error", message: "Error in presenting the Image")
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    */
    // Action to save the riders profile in firebase
    @IBAction func saveButton(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if checkFields()
            {
                let todayDate = NSDate()
                riderProfile.child("FirstName").setValue(firstNameTextField.text)
                riderProfile.child("LastName").setValue(lastNameTextField.text)
                riderProfile.child("PhoneNumber").setValue(phoneTextField.text)
                riderProfile.child("DateOfBirth").setValue(dateOfBirthTextField.text)
                riderProfile.child("Gender").setValue(genderTextField.text)
                riderProfile.child("AddressLine1").setValue(address1TextField.text)
                riderProfile.child("AddressLine2").setValue(address2TextField.text)
                riderProfile.child("City").setValue(cityTextField.text)
                riderProfile.child("State").setValue(stateTextField.text)
            
                riderProfile.child("CreatedOnDate").setValue(String(describing: todayDate))
                riderProfile.child("LastUpdatedOnDate").setValue(String(describing: todayDate))
                riderProfile.child("CreatedBy").setValue(AuthService.instance.riderEmail!)
                riderProfile.child("UpdatedBy").setValue(AuthService.instance.riderEmail!)
            
          //  guard let imageData = UIImageJPEGRepresentation(riderPhotoImageView.image!, 0.8) else { return }
           
            //let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(riderID).jpg"
            
            //let metadata = FIRStorageMetadata()
            //metadata.contentType = "image/jpeg"
            //self.storageRef.child(imagePath).put(imageData, metadata: metadata) { (metadata, error) in
              //      if let error = error {
                //        print("Error uploading: \(error)")
                       // self.urlTextView.text = "Upload Failed"
                  //      return
                    //}
                    //self.uploadSuccess(metadata!, storagePath: imagePath)
            //}
            }
        
        self.performSegue(withIdentifier: "riderToMainSegue", sender: nil)
        
        }else{
    
            self.showAlert(title: "Save Profile", message: "Could not Save Profile as Internet Connection is not Available!") //Show Failure Message
        }
    }

    /*
    func uploadSuccess(_ metadata: FIRStorageMetadata, storagePath: String) {
       
        print("Upload Succeeded!")
        UserDefaults.standard.set(storagePath, forKey: "storagePath")
        UserDefaults.standard.synchronize()
       
    }
    */
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
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == dateOfBirthTextField) || (textField == genderTextField)
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 70), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
