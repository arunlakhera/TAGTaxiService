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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
        
    }
    
    // MARK: Action
    @IBAction func signUpButton(_ sender: Any) {
        
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!  
    
        // Check if the field are blank
        if emailText.characters.count == 0 || passwordText.characters.count == 0{
            
            self.errorLogin(errTitle: "Sign Up Error", errMessage: "Please provide valid email and password!")
            
        }else {
            
            FIRAuth.auth()?.createUser(withEmail: emailText, password: passwordText, completion: { user, error in
                
                if error != nil{
                
                    // Error occured while sign up
                    let err = (error?.localizedDescription)!
                    self.errorLogin(errTitle: "Sign Up ERROR!!!", errMessage: err)
                
                }else{
                    
                    // Sign up was successfull so we signin with the sign up information
                    
                    // Get user information
                    let user = FIRAuth.auth()?.currentUser
                    riderID = (user?.uid)!
                    riderEmail = (user?.email)!
                    
                    let todayDate = NSDate()
                    
                    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
                    
                    riderProfile.child("EmailID").setValue(riderEmail)
                    riderProfile.child("CreatedOnDate").setValue(String(describing: todayDate))
                    riderProfile.child("LastUpdatedOnDate").setValue(String(describing: todayDate))
                    riderProfile.child("CreatedBy").setValue(riderEmail)
                    riderProfile.child("UpdatedBy").setValue(riderEmail)
                    
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                }
            
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField{
            self.passwordTextField.becomeFirstResponder()
        }else{
            self.passwordTextField.resignFirstResponder()
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
