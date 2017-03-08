//
//  MainMenuViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
var riderID = ""
var riderEmail = ""

class MainMenuViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get user information
        let user = FIRAuth.auth()?.currentUser
        riderID = (user?.uid)!
        riderEmail = (user?.email)!
        
        label.text = "UID-> \(riderID)---Email ID ->\(riderEmail)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookARideButton(_ sender: Any) {
        self.performSegue(withIdentifier: "bookARideSegue", sender: UIButton())
    }
    

    @IBAction func bookingStatusButton(_ sender: Any) {
        self.performSegue(withIdentifier: "mainToStatusSegue", sender: UIButton())

    }
    
    
    
}
