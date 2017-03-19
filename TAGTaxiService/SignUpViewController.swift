//
//  SignUpViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.becomeFirstResponder()
        
        let toolBar = addDoneButton()
        
        firstNameTextField.inputAccessoryView = toolBar
        lastNameTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        
    }
    
    func addDoneButton() -> UIToolbar{
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        return toolBar
        
    }
    
    func doneClicked(){
        self.view.endEditing(true)
    }
    
    // MARK: Action
    @IBAction func signUpButton(_ sender: Any) {
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phoneNumber = phoneTextField.text!
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!  
    
        // Check if the field are blank
        if (firstName.characters.count == 0  || lastName.characters.count == 0) || emailText.characters.count == 0 || passwordText.characters.count == 0 || phoneNumber.characters.count == 0{
            
            self.showAlert(title: "Sign Up Error", message: "Please fill the required details!")
            
        }else {
            
            AuthService.instance.emailSignUp(email: emailText, password: passwordText, Completion: { (success, message) in
                
                if success{
                    
                    // Get user information
                    riderID = (FIRAuth.auth()?.currentUser?.uid)!
                    riderEmail = (FIRAuth.auth()?.currentUser?.email)!
                    
                    let todayDate = NSDate()
                    
                    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
                    
                    riderProfile.child("FirstName").setValue(firstName)
                    riderProfile.child("LastName").setValue(lastName)
                    riderProfile.child("PhoneNumber").setValue(phoneNumber)
                    riderProfile.child("EmailID").setValue(riderEmail)
                    riderProfile.child("CreatedOnDate").setValue(String(describing: todayDate))
                    riderProfile.child("LastUpdatedOnDate").setValue(String(describing: todayDate))
                    riderProfile.child("CreatedBy").setValue(riderEmail)
                    riderProfile.child("UpdatedBy").setValue(riderEmail)
                    riderProfile.child("AdminFlag").setValue("No")
                    
                    AuthService.instance.isLoggedIn = true
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                
                    
                }else{
                    self.showAlert(title: "Sign Up Error", message: message)
                }
                
                
            })
          
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == firstNameTextField{
            self.lastNameTextField.becomeFirstResponder()
        }else if textField == lastNameTextField{
            self.phoneTextField.becomeFirstResponder()
        }else if textField == phoneTextField{
            self.emailTextField.becomeFirstResponder()
        } else if textField == emailTextField{
            self.passwordTextField.becomeFirstResponder()
        }else{
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Alert function to show messages
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
