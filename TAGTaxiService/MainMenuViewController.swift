//
//  MainMenuViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
var userID = ""
var userEmail = ""

class MainMenuViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get user information
        let user = FIRAuth.auth()?.currentUser
        userID = (user?.uid)!
        userEmail = (user?.email)!
        
        label.text = "UID-> \(userID)---Email ID ->\(userEmail)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookARideButton(_ sender: Any) {
        self.performSegue(withIdentifier: "bookARideSegue", sender: nil)
    }
    

    @IBAction func bookingStatusButton(_ sender: Any) {
    }
    
    
}
