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

class RiderProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var riderPhotoImageView: UIImageView!
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
    
    // Rider Link
    
    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
    let image = UIImagePickerController()
    
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        storageRef = FIRStorage.storage().reference()
        
        // Call Load profile function
        loadProfile()
        // Make Name field as first responder
        firstNameTextField.becomeFirstResponder()
        
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
       
        //Keep the Email id disable as we do not want users to change it.
        //emailIDTextField.isEnabled = false
    }
    
        // Function to load the profile data if it already exists
    func loadProfile(){
        
           riderProfile.observe(.value, with: { snapshot in
            
            // if snapshot does not exists return
            if !snapshot.exists(){ self.errorLogin(errTitle: "ERROR in SNAPSHOT", errMessage: "Snapshot Error") }
            
            print("SNAPSHOT---->>>\(snapshot)")
            
            if let riderProfile = snapshot.value as? Dictionary<String, String>{
                
                let rider = Rider(riderID: riderID, dictionary: riderProfile as Dictionary<String, AnyObject>)

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
        

       enableFields()
        
    }
    
    @IBAction func uploadPhotoButton(_ sender: Any) {
     
       
        image.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.image.sourceType = .camera
                self.present(self.image, animated: true, completion: nil)
            }else{
                self.errorLogin(errTitle: "Camera Alert", errMessage: "Camera is Not Available!")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.image.sourceType = .photoLibrary
                self.present(self.image, animated: true, completion: nil)
            }else{
                self.errorLogin(errTitle: "Photo Library Alert", errMessage: "Photo Library is Not Available!")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            riderPhotoImageView.image = image
            
        }else{
            // Error
            self.errorLogin(errTitle: "Error", errMessage: "Error in presenting the Image")
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if checkFields()
        {
           
            let todayDate = NSDate()
            
            riderProfile.child("FirstName").setValue(firstNameTextField.text)
            riderProfile.child("LastName").setValue(lastNameTextField.text)
            //riderProfile.child("EmailID").setValue(emailIDTextField.text)
            riderProfile.child("PhoneNumber").setValue(phoneTextField.text)
            riderProfile.child("DateOfBirth").setValue(dateOfBirthTextField.text)
            riderProfile.child("Gender").setValue(genderTextField.text)
            riderProfile.child("AddressLine1").setValue(address1TextField.text)
            riderProfile.child("AddressLine2").setValue(address2TextField.text)
            riderProfile.child("City").setValue(cityTextField.text)
            riderProfile.child("State").setValue(stateTextField.text)
            
            riderProfile.child("CreatedOnDate").setValue(String(describing: todayDate))
            riderProfile.child("LastUpdatedOnDate").setValue(String(describing: todayDate))
            riderProfile.child("CreatedBy").setValue(riderEmail)
            riderProfile.child("UpdatedBy").setValue(riderEmail)
            
            guard let imageData = UIImageJPEGRepresentation(riderPhotoImageView.image!, 0.8) else { return }
           
            let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(riderID).jpg"
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath).put(imageData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                       // self.urlTextView.text = "Upload Failed"
                        return
                    }
                    self.uploadSuccess(metadata!, storagePath: imagePath)
            }
            // END OF PHOTO UPLOAD CHANGE--DELETE TILL THIS LINE
        }
        
        self.performSegue(withIdentifier: "riderToMainSegue", sender: nil)
    }
    // Delete this function
    func uploadSuccess(_ metadata: FIRStorageMetadata, storagePath: String) {
       
        print("Upload Succeeded!")
        UserDefaults.standard.set(storagePath, forKey: "storagePath")
        UserDefaults.standard.synchronize()
       
    }
    
    func checkFields() -> Bool{
   
        var checkFlag = false
        
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = firstName! + " " + lastName!
        let addressLine1 = address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLine2 = address2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = addressLine1! + " " + addressLine2!
        let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let state = stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNo = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateOfBirth = dateOfBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let gender = genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailID = emailIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Name.")
            firstNameTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }

        if (address.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Address.")
            address1TextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }

        if (city?.characters.count)! == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your City.")
            cityTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (state?.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your State.")
            stateTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
       
        if (phoneNo?.characters.count)!  != 10{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide Valid Phone Number.")
            phoneTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (dateOfBirth?.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Date Of Birth.")
            dateOfBirthTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (gender?.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Gender.")
            genderTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (emailID?.characters.count) == 0{
            self.errorLogin(errTitle: "Error", errMessage: "Please provide your Email ID.")
            emailIDTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
    return checkFlag
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == firstNameTextField{
            self.lastNameTextField.becomeFirstResponder()
        }else if textField == lastNameTextField{
            self.address1TextField.becomeFirstResponder()
        }else if textField == address1TextField{
            self.address2TextField.becomeFirstResponder()
        }else if textField == address2TextField{
            self.cityTextField.becomeFirstResponder()
        }else if textField == cityTextField{
            self.stateTextField.becomeFirstResponder()
        }else if textField == stateTextField{
            self.phoneTextField.becomeFirstResponder()
        }else if textField == phoneTextField{
            self.firstNameTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
