//
//  EditDriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/29/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class EditDriverViewController: UIViewController {

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
    var bloodGroup = "NA"
    var active = "NA"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isHidden = true
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        dateOfBirthTextField.text = dateOfBirth
        phoneNumberTextField.text = phoneNumber
        address1TextField.text = address1
        address2TextField.text = address2
        cityTextField.text = city
        stateTextField.text = state
        DLNumberTextField.text = DLNumber
        DLValidFromTextField.text = DLValidFrom
        DLValidTillTextField.text = DLValidTill
        policeVerifiedTextField.text = policeVerified
        bloodGroupTextField.text = bloodGroup
        activeLabel.text = active
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                let driver = DataService.ds.REF_DRIVER.child(driverKey)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-YYYY"
                
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
                
                self.performSegue(withIdentifier: "driverListSegue", sender: nil)
                
            }
            
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
        
        
    // Enable Edit Button once changes have been saved 
        editButton.isEnabled = true
        saveButton.isHidden = true
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

    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
