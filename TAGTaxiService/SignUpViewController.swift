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
  
        // MARK: Create variable and assign return properties from addDoneButton()
        let toolBarWithDoneButton = addDoneButton()
        
        // MARK: Add toolbar to the keyboard that appears in email and password keyboard
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        phoneTextField.inputAccessoryView = toolBarWithDoneButton
        emailTextField.inputAccessoryView = toolBarWithDoneButton
        passwordTextField.inputAccessoryView = toolBarWithDoneButton
        
    }
    
    // MARK: Function to add toolbar to the Keyboard
    func addDoneButton() -> UIToolbar{
        
        // MARK: Create toolbar with button
        let toolBar = UIToolbar()  // Create toolbar View
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
    
    func setUserName(){
        
        if let user = FIRAuth.auth()?.currentUser{
            AuthService.instance.isLoggedIn = true
            AuthService.instance.riderID = user.uid
            AuthService.instance.riderEmail = user.email
            
            let emailComponents = user.email?.components(separatedBy: "@")
            
            if let userName = emailComponents?[0]{
                AuthService.instance.userName = userName
            }else{
                AuthService.instance.isLoggedIn = false
                AuthService.instance.userName = "UserName Not Available"
            }
        }
       
    }
    
    // MARK: Action
    @IBAction func signUpButton(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        // Variables to store Signup information for new user
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phoneNumber = phoneTextField.text!
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!  
    
        // Check if the field are blank else insert information in Rider profile
     
        if checkFields() {
            
            AuthService.instance.emailSignUp(email: emailText, password: passwordText, Completion: { (success, message) in
                
                if success{
                    
                    self.setUserName()
                    
                    let riderID = AuthService.instance.riderID!             // Variable to Store rider ID
                    let riderEmail = AuthService.instance.riderEmail!   // Variable to Store Email
                    let todayDate = NSDate()                                       // Variable to Store Currrent Date
                    
                    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")     // variable to store Rider Profile Path  firebase
                    
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
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
    }
    
    // Function to check if the  required fields are provided or not
    func checkFields() -> Bool{
        
        var checkFlag = false
   
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let phoneNumber = phoneTextField.text
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        
        if (firstName?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "First Name!", message:  "Please provide First Name..")
            firstNameTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (lastName?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Last Name!", message:  "Please provide Last Name..")
            lastNameTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (phoneNumber?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Phone Number!", message:  "Please provide Phone Number..")
            phoneTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (emailText?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Email ID!", message:  "Please provide Email ID..")
            emailTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        if (passwordText?.characters.count)! == 0{
            checkFlag = false
            self.showAlert(title: "Password!", message:  "Please provide Password..")
            passwordTextField.becomeFirstResponder()
        }else{
            checkFlag = true
        }
        
        return checkFlag
    }
    
    // To move cursore to next available field
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
    // To Dissmiss keyboard once user clicks on screeen
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
