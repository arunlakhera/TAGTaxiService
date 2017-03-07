//
//  BookARideViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/6/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class BookARideViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var travelFromTextField: UITextField!
    @IBOutlet weak var travelToTextField: UITextField!
    @IBOutlet weak var roundTripLabel: UILabel!
    @IBOutlet weak var roundTripSwitch: UISwitch!
    @IBOutlet weak var travelBeginDateTextField: UITextField!
    @IBOutlet weak var travelEndDateTextField: UITextField!
    @IBOutlet weak var noOfTravellers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        nameTexField.becomeFirstResponder()
        
    }
    
    // MARK: Actions
    
    @IBAction func addNoOfTravellers(_ sender: Any) {
        if Int(noOfTravellers.text!)! <= 7{
                noOfTravellers.text = String(Int(noOfTravellers.text!)! + 1)
        }
    }
    @IBAction func reduceNoOfTravellers(_ sender: Any) {
        if Int(noOfTravellers.text!)! != 1{
            noOfTravellers.text = String(Int(noOfTravellers.text!)! - 1)
        }
    }
    
    
    @IBAction func roundTrip(_ sender: Any) {
       
        if roundTripSwitch.isOn{
            roundTripLabel.text = "Yes"
            travelEndDateTextField.isEnabled = true
            travelEndDateTextField.isHidden = false
        }else{
            roundTripLabel.text = "No"
            travelEndDateTextField.isEnabled = false
            travelEndDateTextField.isHidden = true
        }
        
    }
    
    @IBAction func askQuoteButton(_ sender: Any) {
        
        let name = nameTexField.text!
        let phoneNo = phoneNoTextField.text!
        
        if name.characters.count == 0
        {
            self.errorLogin(errTitle: "Error", errMessage: "Name not provided")
            nameTexField.becomeFirstResponder()
        }
        if phoneNo.characters.count == 0 || phoneNo.characters.count != 10{
            self.errorLogin(errTitle: "Phone No Error", errMessage: "Please provide a Valid Phone Number")
            phoneNoTextField.becomeFirstResponder()
        }
        
        let riderBookID = DataService.ds.REF_RIDERBOOKING.childByAutoId()
        riderBookID.child("name").setValue(name)
        riderBookID.child("phone").setValue(phoneNo)
        
        
        
    }
   
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
