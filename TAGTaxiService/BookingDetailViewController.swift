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
        bookStatus = "Accepted"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
    }
    
    
    // Action when Decline button is pressed
    @IBAction func declineBooking(sender: UIButton) {
        bookStatus = "Declined"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
    }
    
    
    // Action when Cancel button is pressed
    @IBAction func cancelBooking(sender: AnyObject) {
        let bookingCancel = bookingAction(bookingTitle: "Cancel Booking", bookingMessage: "Do you want to Cancel this Booking?")
        if bookingCancel == "Yes"{
            bookStatus = "Cancelled"
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
            viewDidLoad()
        }
    }
    // Action to ask if user really wants to cancel the booking
    func bookingAction(bookingTitle: String, bookingMessage: String) -> String{
        var flag = ""
        let alert = UIAlertController(title: bookingTitle, message: bookingMessage, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
       // present(alert, animated: true, completion: nil)
        present(alert, animated: true) { 
            if alert.title == "Yes"{
                    flag = "Yes"
            }else{
                    flag = "No"
            }
        }
    return flag
}
}
