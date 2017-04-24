//
//  AuthService.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/18/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    
    static let instance = AuthService()
    
    var userName: String?
    var isLoggedIn = false
    var isAdmin = false
    var riderID: String?
    var riderEmail: String?
    var riderPhone: String?
    var errorMessage: String?
    
    func emailSignIn(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void ){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code ){
                    
                    switch errorCode{
                    case .errorCodeInvalidEmail:
                        self.errorMessage = "Please provide Valid Email ID!"
                    case .errorCodeUserNotFound :
                        self.errorMessage = "Could not find User information. Please create account before Sign In"
                    case .errorCodeWrongPassword:
                        self.errorMessage = "Please provide Correct Email ID and Password"
                    case .errorCodeNetworkError:
                        self.errorMessage = "Network Error Occured while trying to Sign In"
                    default:
                        self.errorMessage = "Error Occured. Please try again later."
                        print((error?.localizedDescription)!)
                    }
                    
                }
                
                Completion(false, self.errorMessage!)
            }else{
                
                self.riderID = FIRAuth.auth()?.currentUser?.uid
                self.riderEmail = (FIRAuth.auth()?.currentUser?.email)!
          
                Completion(true, "Welcome \(String(describing: self.userName)) !")
                
            }
        })
    }
    
    func emailSignUp(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code ){
                    
                    switch errorCode{
                    case .errorCodeInvalidEmail:
                        self.errorMessage = "Please provide Valid Email ID!"
                    case .errorCodeEmailAlreadyInUse :
                        self.errorMessage = "User account with this Email ID already Exists. Please provide different Email ID"
                    case .errorCodeWeakPassword:
                        self.errorMessage = "Password is too weak. Please provide Strong Password."
                    case .errorCodeNetworkError:
                        self.errorMessage = "Network Error Occured while trying to Sign In"
                    default:
                        self.errorMessage = "Error Occured. Please try again later."
                        print((error?.localizedDescription)!)
                    }
                    
                }
                
                Completion(false, self.errorMessage!)
            }else{
          
                self.riderID = FIRAuth.auth()?.currentUser?.uid
                self.riderEmail = (FIRAuth.auth()?.currentUser?.email)!
                
                Completion(true, "Successfully Created Account")
            }
        })
    }
    
}
