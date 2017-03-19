
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
    
    // MARK: Variables to store email and password
    var email = ""
    var password = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make email Text field as first responder when view loads
        emailTextField.becomeFirstResponder()
        
        // ADD Done button to the Keyboard
        let toolBar = addDoneButton()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
       setUserName()
        
        if AuthService.instance.isLoggedIn{
            if AuthService.instance.isAdmin{
                self.performSegue(withIdentifier: "adminMainSegue", sender: nil)
            } else{
                  self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
    
    // MARK: Function to extract user name from Email id for the user
    func setUserName(){
        if let user = FIRAuth.auth()?.currentUser{
            AuthService.instance.isLoggedIn = true
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
        // Function to check if required fields are provided or not
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        checkFields()
        
        AuthService.instance.emailSignIn(email: email, password: password) { (success, message) in
            if success{
                self.setUserName()
                
                let  user = FIRAuth.auth()?.currentUser
                riderID = (user?.uid)!
                let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile").child("AdminFlag")
                
                riderProfile.observe(.value, with: { (snapshot) in
                    let adminFlag = (snapshot.value)! as? String
                    
                    if adminFlag == "Yes"{
                        AuthService.instance.isAdmin = true
                        self.performSegue(withIdentifier: "adminMainSegue", sender: nil)
                    }else{
                        AuthService.instance.isAdmin = false
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                    
                }, withCancel: { (error) in
            })
        }else{
                self.showAlert(title: "Failure", message: message)
            }
        }
    }
    
    //Function to check for required fields
    
    func checkFields(){
        guard  let email = emailTextField.text,  let password = passwordTextField.text else{
            showAlert(title: "Error!", message: "Please provide Email ID and Password")
            return
        }
        
        guard email != "", password != "" else {
            showAlert(title: "Error", message: "Please provde Email ID and PAssword")
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
