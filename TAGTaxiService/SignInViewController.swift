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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       emailTextField.becomeFirstResponder()
    }

  
    @IBAction func forgotPasswordButton(_ sender: Any) {
    
        var userEmail: String?
        
        let alert = UIAlertController(title: "Forgot Password", message: "Please provide your registered Email ID", preferredStyle: .alert)
        let submit = UIAlertAction(title: "Submit", style: .default) { (UIAlertAction) in
            userEmail = alert.textFields![0].text
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: userEmail!) { (error) in
                if error != nil{
                    self.errorLogin(errTitle: "Error in Email Provided", errMessage: (error?.localizedDescription)!)
                }else {
                    self.errorLogin(errTitle: "Password Reset", errMessage: "Password Reset Email is sent!")
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
    
    @IBAction func signInButton(_ sender: Any) {
        
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!
        
        if emailText.characters.count == 0 || passwordText.characters.count == 0{
                self.errorLogin(errTitle: "Sign In Error!!", errMessage: "Please provide valid Email ID and Password!")
        }else{
            
            FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: { user, error in
                
                if error != nil{
                        let err = (error?.localizedDescription)!
                        self.errorLogin(errTitle: "Sign In Error", errMessage: err)
                    
                }else{
                    
                    // Login Successful. Check if User is Admin
                    //////
                    
                    let user = FIRAuth.auth()?.currentUser
                    riderID = (user?.uid)!
                    let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile").child("AdminFlag")
                    
                    riderProfile.observe(.value, with: { (snapshot) in
                        let adminFlag = (snapshot.value)! as? String
                        
                        if adminFlag == "Yes"{
                            self.performSegue(withIdentifier: "adminMainSegue", sender: nil)
                        }else{
                            self.performSegue(withIdentifier: "signInSegue", sender: nil)
                        }
                        
                    }, withCancel: { (error) in
                        print("ERROR IN ADMIN FLAG")
                    })
                    
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
