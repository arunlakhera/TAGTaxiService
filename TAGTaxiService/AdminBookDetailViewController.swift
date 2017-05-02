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

        let toolBarWithDoneButton =  addDoneButton()
        
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
        vehicleText.text = "\(bookVehicle.trimmingCharacters(in: .whitespacesAndNewlines)) \(bookVehicleType.trimmingCharacters(in: .whitespacesAndNewlines)) "
        
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

        amountText.inputAccessoryView = toolBarWithDoneButton
        vehicleText.inputAccessoryView = toolBarWithDoneButton
        
        // If status is ACCEPTED only then show the Completed button so Admin can mark the journey as completed
        
        if bookingStatusList == "Accepted"{
            send.isHidden = false
            send.isEnabled = true
            send.setTitle("Completed", for: .normal)
        }
        
    }
    
    
    // MARK: Function to add toolbar to the Keyboard
    func addDoneButton() -> UIToolbar{
        
        // MARK: Create toolbar with button
        let toolBar = UIToolbar()   // Create toolbar View
        toolBar.sizeToFit()             // calls sizeThatFits: with current view bounds and changes bounds size of toolbar.
        
        // Adds space on toolbar so that Done Button appears on right side of the toolbar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        // Adds Done button to the toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        // Adds Space and Done button to the Toolbar
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        return toolBar
        
    }
    
    // Function to Dismiss keyboards once Done button is clicked
    func doneClicked(){
        self.view.endEditing(true)
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
            //
            if send.title(for: .normal) == "Completed"{
                bookStatus = "Completed"
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child(bookKey).child("Status").setValue(bookStatus){(error) in print("Error while Writing Status to Database")}
                showAlert(title: "Completed", message: "You have Marked the Booking as Completed")
               
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                
                
                statusText.text = "Completed"
                send.isHidden = true
                send.isEnabled = false
            } else{//
            
            bookStatus = "Quoted"
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Amount").setValue(amountText.text!.trimmingCharacters(in: .whitespacesAndNewlines)){(error) in print("Error while Writing Amount to Database")}
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus){(error) in print("Error while Writing Status to Database")}
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Vehicle").setValue(vehicleText.text!.trimmingCharacters(in: .whitespacesAndNewlines)){(error) in print("Error while Writing Vehicle to Database")}
            
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                
                
            statusText.text = bookStatus
            send.isHidden = true
            }
        } else{
            let alert = UIAlertController(title: "Error!", message: "Please Enter Valid Amount.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
            
           // self.showAlert(title: "BOOK STATUS", message: "Book Status-->\(bookStatus)")
            
            if bookStatus == "Quoted"{
                sendMessage()
            }
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
    
    }
    
    func sendMessage(){
        
        // Sending Message Begin
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            
            let textMessage = "TAG Taxi Service \n Booking Name: \(bookName) \n  \(bookFrom) - \(bookTo) \n Date: \(bookTravelDate) \n Amount: Rs.\(bookAmount) \n Booking Status: \(bookStatus) \n"
            
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(textMessage: textMessage)
       
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
    
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == amountText) || (textField == vehicleText){
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 90), animated: true)
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
