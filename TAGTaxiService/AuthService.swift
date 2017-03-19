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
    
    func emailSignIn(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void ){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                Completion(false, "\((error?.localizedDescription)!)")
            }else{
                Completion(true, "Welcome \(self.userName) !")
            }
        })
    }
    
    func emailSignUp(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                Completion(false, "\((error?.localizedDescription)!)")
            }else{
                Completion(true, "Successfully Created Account")
            }
        })
    }
    
}
