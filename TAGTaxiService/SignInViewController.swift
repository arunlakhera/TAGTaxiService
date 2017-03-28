
//
//  SignInViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Create variable and assign return properties from addDoneButton()
        let toolBarWithDoneButton =  addDoneButton()
        
        // MARK: Add toolbar to the keyboard that appears in email and password keyboard
        emailTextField.inputAccessoryView = toolBarWithDoneButton
        passwordTextField.inputAccessoryView = toolBarWithDoneButton
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        // Call function to Set the username
       setUserName()
       
        // MARK: Check if the user is logged in already and if yes take user to Main screen else ask for sign in
        
        if AuthService.instance.isLoggedIn{
                if AuthService.instance.isLoggedIn{
                    self.performSegue(withIdentifier: "adminMainSegue", sender: nil)
            } else{
                    self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
        
        
     }
    
    // MARK: Function to extract user name from Email id for the user to show in Main Screen
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
    
    // Forgot Password Function BEGIN
    @IBAction func forgotPasswordButton(_ sender: Any) {
        var userEmail: String?
        
        let alert = UIAlertController(title: "Forgot Password", message: "Please provide your registered Email ID", preferredStyle: .alert)
        let submit = UIAlertAction(title: "Submit", style: .default) { (UIAlertAction) in
            userEmail = alert.textFields![0].text
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: userEmail!) { (error) in
                if error != nil{
                    self.showAlert(title: "Error in Email Provided", message: (error?.localizedDescription)!)
                }else {
                    self.showAlert(title: "Password Reset", message: "Password Reset Email is sent!")
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your Registered email"
            
        }
        
        alert.addAction(cancel)
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Forgot Password Function END
    
    // SIGNIN FUNCTION BEGIN
    
    @IBAction func signInButton(_ sender: Any) {
        
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
          
            // Variables to store email and password provided by user
            let email = emailTextField.text!
            let password = passwordTextField.text!
        
            // Function to check if required fields are provided or not
        
            checkFields()
        
            // Call Signin Function emailSignIn function defined in AuthService Class for user email signin
            AuthService.instance.emailSignIn(email: email, password: password) { (success, message) in
                // If login is successfull
                if success{
                    // Set the username
                    self.setUserName()
                    // Get the current user
                    let riderID = AuthService.instance.riderID!
                
                    
                    // Get Admin flag Path from Firebase
                    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile").child("AdminFlag")
                    
                    // Check for Admin flag value and depending on perform segue to Admin or user screen
                    riderProfile.observe(.value, with: { (snapshot) in
                        
                        let adminFlag = ((snapshot.value)! as! String)
                       
                        if adminFlag == "true"{
                            AuthService.instance.isAdmin = true   // Set the Admin flag to true
                            AuthService.instance.isLoggedIn = true
                            self.performSegue(withIdentifier: "adminMainSegue", sender: nil)
                         
                        }else{
                            AuthService.instance.isLoggedIn = true
                            self.performSegue(withIdentifier: "signInSegue", sender: nil)
                        }
                    }, withCancel: { (error) in
                        print("Sign In Error")
                    })
                
                
                }else{
                    self.showAlert(title: "Failure", message: message) //Show Failure Message
                }
            } // Auth Service End
        }
        else
        {
            //self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
             let alert = UIAlertController(title: "Failure!!", message: "Internet Connection not available! Connect to Internet", preferredStyle: .alert)
             let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
             let callUs = UIAlertAction(title: "Call Tag Taxi", style: .default, handler: { (callAction) in
               
                let callNumber = "8979743264"
             
                if let phoneCallURL:URL = URL(string: "tel:\(callNumber)") {
                    let application:UIApplication = UIApplication.shared
                
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }else{
                        print("Cannot Make Phone Call")
                    }
                
                }else{
                    print("Cannot open Call URL")
                }
                
             })
            
            alert.addAction(okButton)
            alert.addAction(callUs)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    //Function to check for required fields
    
    func checkFields(){
        guard  let email = emailTextField.text,  let password = passwordTextField.text else{
            showAlert(title: "Error!", message: "Please provide Email ID and Password")
            return
        }
        
        guard email != "", password != "" else {
            showAlert(title: "Error", message: "Please provde Email ID and Password")
            return
        }
    }
    
    // Alert function to show messages
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Function to make next available field as responder once data has been entered in the current field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField{
            self.passwordTextField.becomeFirstResponder()
        }else{
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    // Function to close the Keyboard once user touches anywhere on screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
