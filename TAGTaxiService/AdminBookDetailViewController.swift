//
//  AdminBookDetailViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/16/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class AdminBookDetailViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var bookName = "NA"
    var bookTravelDate = "NA"
    var bookFrom = "NA"
    var bookTo = "NA"
    var bookNoOfTravellers = "NA"
    var bookPhone = ""
    var bookRoundTrip = "NA"
    var bookAmount = "NA"
    var bookStatus = "NA"
    var bookVehicle = ""
    var bookVehicleType = ""
    
    var bookKey = ""
    var riderID = ""
    var bStatus = ""
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.startActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.stopActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        amountText.delegate = self
        vehicleText.delegate = self
        
        let riderProfile = DataService.ds.REF_RIDER.child(riderID).child("Profile")
        riderProfile.observe(.value, with: { (snapshot) in
            let riderData = Rider(riderID: self.riderID, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
                self.phoneLabel.text = riderData.phoneNumber!
        })
       
        let toolBarWithDoneButton =  addDoneButton()
        
        nameLabel.text = bookName.capitalized
        travelDateLabel.text = bookTravelDate
        travelFromLabel.text = bookFrom.capitalized
        travelToLabel.text = bookTo.capitalized
        roundTripLabel.text = bookRoundTrip.capitalized
        noOfTravellersLabel.text = bookNoOfTravellers
        statusText.text = bookStatus.capitalized
        amountText.text = bookAmount
        vehicleText.text = "\(bookVehicle.trimmingCharacters(in: .whitespacesAndNewlines).capitalized) \(bookVehicleType.trimmingCharacters(in: .whitespacesAndNewlines).capitalized) "
        
        if (statusText.text == "Cancelled" || statusText.text == "Declined" || statusText.text == "Completed"){
            cancelButton.isEnabled = false
        }
        
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
        
        let riderInfo = DataService.ds.REF_RIDER.child("\(riderID)").child("Profile")
        
        riderInfo.observe(.value, with: { (snapshot) in
            
            let riderProfile = Rider(riderID: self.riderID, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
            
            if (riderProfile.firstName?.characters.count)! > 0 {
                self.bookName = (riderProfile.firstName)!
            }else{
                self.bookName = ""
            }
            
            if (riderProfile.lastName?.characters.count)! > 0 {
                self.bookName = self.bookName + " " + (riderProfile.lastName)!
            }else{
                self.bookName = self.bookName + "" + ""
            }
            
            if (self.bookName.characters.count) <= 0 {
                self.bookName = String(describing: riderProfile.emailID)
            }
            
            self.nameLabel.text = self.bookName.capitalized
            
        })
        
        // If status is ACCEPTED only then show the Completed button so Admin can mark the journey as completed
        
        if bookingStatusList == "Accepted"{
            send.isHidden = false
            send.isEnabled = true
            send.setTitle("Completed", for: .normal)
        }
        
        if bookingStatusList == "Pending"{
            
            nameLabel.textColor = UIColor.yellow
            phoneLabel.textColor = UIColor.yellow
            travelDateLabel.textColor = UIColor.yellow
            travelFromLabel.textColor = UIColor.yellow
            travelToLabel.textColor = UIColor.yellow
            roundTripLabel.textColor = UIColor.yellow
            noOfTravellersLabel.textColor = UIColor.yellow
            amountText.textColor = UIColor.yellow
            vehicleText.textColor = UIColor.yellow
            statusText.textColor = UIColor.yellow
            
        }else if bookingStatusList == "Accepted"{
            
            nameLabel.textColor = UIColor.green
            phoneLabel.textColor = UIColor.green
            travelDateLabel.textColor = UIColor.green
            travelFromLabel.textColor = UIColor.green
            travelToLabel.textColor = UIColor.green
            roundTripLabel.textColor = UIColor.green
            noOfTravellersLabel.textColor = UIColor.green
            amountText.textColor = UIColor.green
            vehicleText.textColor = UIColor.green
            statusText.textColor = UIColor.green
            
            
        } else if bookingStatusList == "Declined" || bookStatus == "Cancelled"{
            
            nameLabel.textColor = UIColor.red
            phoneLabel.textColor = UIColor.red
            travelDateLabel.textColor = UIColor.red
            travelFromLabel.textColor = UIColor.red
            travelToLabel.textColor = UIColor.red
            roundTripLabel.textColor = UIColor.red
            noOfTravellersLabel.textColor = UIColor.red
            amountText.textColor = UIColor.red
            vehicleText.textColor = UIColor.red
            statusText.textColor = UIColor.red
            
            
        }else if bookingStatusList == "Quoted"{
            
            nameLabel.textColor = UIColor.cyan
            phoneLabel.textColor = UIColor.cyan
            travelDateLabel.textColor = UIColor.cyan
            travelFromLabel.textColor = UIColor.cyan
            travelToLabel.textColor = UIColor.cyan
            roundTripLabel.textColor = UIColor.cyan
            noOfTravellersLabel.textColor = UIColor.cyan
            amountText.textColor = UIColor.cyan
            vehicleText.textColor = UIColor.cyan
            statusText.textColor = UIColor.cyan
            
            
        }else if bookingStatusList == "Completed"{
            
            nameLabel.textColor = UIColor.white
            phoneLabel.textColor = UIColor.white
            travelDateLabel.textColor = UIColor.white
            travelFromLabel.textColor = UIColor.white
            travelToLabel.textColor = UIColor.white
            roundTripLabel.textColor = UIColor.white
            noOfTravellersLabel.textColor = UIColor.white
            amountText.textColor = UIColor.white
            vehicleText.textColor = UIColor.white
            statusText.textColor = UIColor.white
            
        }
        self.stopActivity()
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
            self.startActivity()
            
            if amountText.text == "" || amountText.text == "Pending" {
        
                let alert = UIAlertController(title: "Error!", message: "Please Enter Amount.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
            }else if let _ = Double(amountText.text!){
            
                if send.title(for: .normal) == "Completed"{
            
                    self.bookStatus = "Completed"
                    DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus){(error) in print("Error while Writing Status to Database")}
                    showAlert(title: "Completed", message: "You have Marked the Booking as Completed")
               
                    DataService.ds.REF_RIDEBOOKING.child(bookKey).child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                    DataService.ds.REF_RIDEBOOKING.child(bookKey).child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                
                    statusText.text = "Completed"
                    send.isHidden = true
                    send.isEnabled = false
                
                    self.stopActivity()
                }else{
            
                self.bookStatus = "Quoted"
                
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Amount").setValue(amountText.text!.trimmingCharacters(in: .whitespacesAndNewlines)){(error) in print("Error while Writing Amount to Database")}
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus){(error) in print("Error while Writing Status to Database")}
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Vehicle").setValue(vehicleText.text!.trimmingCharacters(in: .whitespacesAndNewlines)){(error) in print("Error while Writing Vehicle to Database")}
            
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                DataService.ds.REF_RIDEBOOKING.child(bookKey).child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                
                statusText.text = bookStatus
                send.isHidden = true
                self.stopActivity()
            
                }
            }else{
            
                let alert = UIAlertController(title: "Error!", message: "Please Enter Valid Amount.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
        
                }
            
            if bookStatus == "Quoted"{
                sendMessage()
            }
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
        }
    
    }
    
    func sendMessage(){
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            
            let textMessage = "TAG Taxi Service \n Booking Name: \(bookName) \n  \(bookFrom) - \(bookTo) \n Date: \(bookTravelDate) \n Amount: Rs.\(String(describing: amountText.text!)) \n Booking Status: \(bookStatus) \n"
            
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(textMessage: textMessage, textMessageRecipients: [bookPhone])
       
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
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        // Check if internet connection is available
        
        if Reachability.isConnectedToNetwork() == true
        {
            if (self.bookStatus == "Pending" || self.bookStatus == "Quoted" || self.bookStatus == "Accepted"){
                let alert = UIAlertController(title: "Cancel Booking", message: "Do you want to Cancel this Booking?", preferredStyle: .alert)
                let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                    self.bookStatus = "Cancelled"
                    DataService.ds.REF_RIDEBOOKING.child(self.bookKey).child("Status").setValue(self.bookStatus)
                
                    DataService.ds.REF_RIDEBOOKING.child(self.bookKey).child("LastUpdatedOnDate").setValue(String(describing: NSDate())){(error) in print("Error while Writing Last Updated On Date to Database")}
                    DataService.ds.REF_RIDEBOOKING.child(self.bookKey).child("UpdatedBy").setValue(AuthService.instance.riderID!){(error) in print("Error while Writing Updated By to Database")}
                
                self.viewDidLoad()
            })
            
                let actionNo = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    print("=======NO PRESSED=====")
                })
                alert.addAction(actionYes)
                alert.addAction(actionNo)
                present(alert, animated: true, completion: nil)
                cancelButton.isEnabled = false
            }else{
                cancelButton.isEnabled = false
            }
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not available! Connect to Internet")
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
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 130), animated: true)
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
