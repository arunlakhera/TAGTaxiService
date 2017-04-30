//
//  BookingDetailViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/9/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class BookingDetailViewController: UIViewController {

    // Variables with default values
    var bookName = "Not Available"
    var bookTravelDate = "Not Available"
    var bookFrom = "Not Available"
    var bookTo = "Not Available"
    var bookNoOfTravellers = "Not Available"
    var bookPhone = "Not Available"
    var bookRoundTrip = "Not Available"
    var bookAmount = "Not Available"
    var bookStatus = "Not Available"
    var bookVehicle = "Not Available"
    
    var bookKey = ""
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var travelDateLabel: UILabel!
    @IBOutlet weak var travelFromLabel: UILabel!
    @IBOutlet weak var travelToLabel: UILabel!
    @IBOutlet weak var roundTripLabel: UILabel!
    @IBOutlet weak var noOfTravellersLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign values to labels for the booking
        nameLabel.text = bookName
        phoneLabel.text = bookPhone
        travelDateLabel.text = bookTravelDate
        travelFromLabel.text = bookFrom
        travelToLabel.text = bookTo
        roundTripLabel.text = bookRoundTrip
        noOfTravellersLabel.text = bookNoOfTravellers
        
        amountLabel.textColor = UIColor.orange  // Change color of amount label text
        amountLabel.text = bookAmount
        
        vehicleLabel.text = bookVehicle
        vehicleLabel.textColor = UIColor.orange  // Change color of vehicle label text
        
        statusLabel.text = bookStatus
        statusLabel.textColor = UIColor.orange   // Change color of status label text
        
        // If booking status is Pending/ Declined/Cancelled/Accepted hide the Accept/Decline buttons
        if bookStatus == "Pending"  || bookStatus == "Declined" || bookStatus == "Cancelled" || bookStatus == "Accepted"{
            declineButton.isHidden = true
            acceptButton.isHidden = true
            // Allow user to Cancel the booking when it is in Pending State
            if (bookAmount == "Pending" && bookStatus == "Pending") {
                cancelButton.isEnabled = true
            }else{
                cancelButton.isEnabled = false
            }
            
        } else{
            declineButton.isHidden = false
            acceptButton.isHidden = false
            cancelButton.isEnabled = true
        }
        
    }

    // Action when Accept button is pressed
    @IBAction func acceptBooking(sender: UIButton) {
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
            
        bookStatus = "Accepted"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
            
        }

    }
    
    
    // Action when Decline button is pressed
    @IBAction func declineBooking(sender: UIButton) {
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
        bookStatus = "Declined"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
        }else{
            self.showAlert(title: "Failure", message: "Internet Connection not Available!") //Show Failure Message
            
        }

    }
    
    @IBAction func cancelBooking(_ sender: UIBarButtonItem) {
        // Check if internet connection is available
        if Reachability.isConnectedToNetwork() == true
        {
            let alert = UIAlertController(title: "Cancel Booking", message: "Do you want to Cancel this Booking?", preferredStyle: .alert)
            //let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.bookStatus = "Cancelled"
                DataService.ds.REF_RIDEBOOKING.child(self.bookKey).child("Status").setValue(self.bookStatus)
                self.viewDidLoad()
            })
            //let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
            let actionNo = UIAlertAction(title: "No", style: .default, handler: { (action) in
                print("=======NO PRESSED=====")
            })
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
