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

        nameLabel.text = bookName
        phoneLabel.text = bookPhone
        travelDateLabel.text = bookTravelDate
        travelFromLabel.text = bookFrom
        travelToLabel.text = bookTo
        roundTripLabel.text = bookRoundTrip
        noOfTravellersLabel.text = bookNoOfTravellers
        
        amountLabel.textColor = UIColor.orange
        amountLabel.text = bookAmount
        
        vehicleLabel.text = bookVehicle
        vehicleLabel.textColor = UIColor.orange
        
        statusLabel.text = bookStatus
        statusLabel.textColor = UIColor.orange
        
        if bookStatus == "Pending"  || bookStatus == "Declined" || bookStatus == "Cancelled" || bookStatus == "Accepted"{
            declineButton.isHidden = true
            acceptButton.isHidden = true
            
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

    @IBAction func acceptBooking(sender: UIButton) {
        bookStatus = "Accepted"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
    }
    
    @IBAction func declineBooking(sender: UIButton) {
        bookStatus = "Declined"
        DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
        viewDidLoad()
    }
    
    @IBAction func cancelBooking(sender: AnyObject) {
            bookStatus = "Cancelled"
            DataService.ds.REF_RIDEBOOKING.child(bookKey).child("Status").setValue(bookStatus)
            viewDidLoad()
        
    }
    /*
    func bookingAction(bookingTitle: String, bookingMessage: String) -> String{
        
        var flag = ""
        let alert = UIAlertController(title: bookingTitle, message: bookingMessage, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true, completion: nil)
        present(alert, animated: true) { 
            if alert.title == "Yes"{
                    flag = "Yes"
            }else{
                    flag = "No"
            }
        }
    return flag
}*/
}
