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
    var  riderEmail: String?
    
    func emailSignIn(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void ){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                Completion(false, "\((error?.localizedDescription)!)")
            }else{
                
                self.riderID = FIRAuth.auth()?.currentUser?.uid
                self.riderEmail = (FIRAuth.auth()?.currentUser?.email)!
          
                Completion(true, "Welcome \(self.userName) !")
                
            }
        })
    }
    
    func emailSignUp(email: String, password: String, Completion: @escaping(_ success: Bool, _ message: String) -> Void){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                Completion(false, "\((error?.localizedDescription)!)")
            }else{
          
                self.riderID = FIRAuth.auth()?.currentUser?.uid
                self.riderEmail = (FIRAuth.auth()?.currentUser?.email)!
                
                Completion(true, "Successfully Created Account")
            }
        })
    }
    
}
