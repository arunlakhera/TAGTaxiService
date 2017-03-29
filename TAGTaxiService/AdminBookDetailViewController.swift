//
//  AdminBookDetailViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/16/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit

class AdminBookDetailViewController: UIViewController, UITextFieldDelegate {

    var bookName = "NA"
    var bookTravelDate = "NA"
    var bookFrom = "NA"
    var bookTo = "NA"
    var bookNoOfTravellers = "NA"
    var bookPhone = "NA"
    var bookRoundTrip = "NA"
    var bookAmount = "NA"
    var bookStatus = "NA"
    var bookVehicle = ""
    var bookVehicleType = ""
    
    var bookKey = ""
    var bStatus = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var travelDateLabel: UILabel!
    @IBOutlet weak var travelFromLabel: UILabel!
    @IBOutlet weak var travelToLabel: UILabel!
    @IBOutlet weak var roundTripLabel: UILabel!
    @IBOutlet weak var noOfTravellersLabel: UILabel!
    
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var vehicleText: UITextField!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var statusText: UITextField!
    
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        amountText.delegate = self
        vehicleText.delegate = self
        statusText.delegate = self
        
        nameLabel.text = bookName
        phoneLabel.text = bookPhone
        travelDateLabel.text = bookTravelDate
        travelFromLabel.text = bookFrom
        travelToLabel.text = bookTo
        roundTripLabel.text = bookRoundTrip
        noOfTravellersLabel.text = bookNoOfTravellers
        statusText.text = bookStatus
        amountText.text = bookAmount
        vehicleText.text = "\(bookVehicleType)->\(bookVehicle)"
        
        statusText.isEnabled = false
        
        if statusText.text == "Pending" {
            amountText.isEnabled = true
            vehicleText.isEnabled = true
            send.isEnabled = true
        }else{
            amountText.isEnabled = false
            vehicleText.isEnabled = false
            send.isEnabled = false
            send.isHidden = true
        }

    
    }

    @IBAction func sendButton(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
        if amountText.text == "" || amountText.text == "Pending" {
            let alert = UIAlertController(title: "Error!", message: "Please Enter Amount.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if let _ = Double(amountText.text!){
            bookStatus = "Quoted"
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Amount").setValue(amountText.text!)
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Vehicle").setValue(vehicleText.text!)
            
        } else{
            let alert = UIAlertController(title: "Error!", message: "Please Enter Valid Amount.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
            // Sending Message Begin
            
            // Make sure the device can send text messages
            if (messageComposer.canSendText()) {
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                
                // Present the configured MFMessageComposeViewController instance
                present(messageComposeVC, animated: true, completion: nil)
            } else {
                // Let the user know if his/her device isn't able to send text messages
                let alert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            }
        
            // Sending Message End
            
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
    
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == amountText) || (textField == vehicleText){
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
