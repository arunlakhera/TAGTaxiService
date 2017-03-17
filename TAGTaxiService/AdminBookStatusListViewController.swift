//
//  AdminBookStatusListViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/15/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class AdminBookStatusListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
 
    var bookings = [RideBooking]()
    var riderName = ""
    var riderEmail = ""
    var riderPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        DataService.ds.REF_RIDEBOOKING.observe(.value, with: { (snapshot) in
            self.bookings = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let bookDict = snap.value as? Dictionary<String, String>{
                        
                        let key = snap.key
                        let booking = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
        
                        if booking.status == bookingStatusList{
                            self.bookings.append(booking)
                            //self.statuslabel.text = self.statuslabel.text! + booking.bookingID! + "-" + booking.rideFrom! + "\n"
                        }
                    }
                }
            }
         //self.tableView.reloadData()
        }) { (error) in
            self.errorLogin(errTitle: "ERROR!", errMessage: "Error occured whilte fetching Booking Record -- \(error.localizedDescription)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "adminStatusListCell") as? AdminBookListTableViewCell
        let book = bookings.reversed()[indexPath.row]
        
        let rideFrom = String(book.rideFrom!)
        let rideTo = String(book.rideTo!)
        
        let indexFrom = rideFrom?.index((rideFrom!.startIndex), offsetBy: 3)
        let indexTo = rideTo?.index((rideTo!.startIndex), offsetBy: 3)
        
        let riderProfile = DataService.ds.REF_RIDER.child(book.riderID!).child("Profile")
        
        riderProfile.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.riderName = "\(value?["FirstName"] as? String ?? "")  \(value?["LastName"] as? String ?? "")"
            self.riderEmail = value?["EmailID"] as? String ?? ""
            self.riderPhone = value?["PhoneNumber"] as? String ?? ""
            
            if self.riderName.characters.count > 0{
                cell?.nameLabel.text = self.riderName
            }else{
                cell?.nameLabel.text = self.riderEmail
            }
            
        })
 
        cell?.fromToLabel.text = "\(rideFrom!.substring(to: indexFrom!)) - \(rideTo!.substring(to: indexTo!))".capitalized
        cell?.travelDateLabel.text = book.rideBeginDate!.capitalized
        cell?.statusLabel.text = book.status!.capitalized
        
        if book.status! == "Pending"{
            cell?.statusLabel.textColor = UIColor.yellow
        }else if book.status! == "Accepted"{
            cell?.statusLabel.textColor = UIColor.green
        } else if book.status! == "Declined" || book.status! == "Cancelled"{
            cell?.statusLabel.textColor = UIColor.red
        }else if book.status! == "Quoted"{
            cell?.statusLabel.textColor = UIColor.orange
        }else if book.status! == "Completed"{
            cell?.statusLabel.textColor = UIColor.white
        }
        return cell!
    }
    
    
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "adminBookDetailSegue"{
            
            if let destinationVC = segue.destination as? AdminBookDetailViewController{
                
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
                let book = bookings.reversed()[ip]
                
                destinationVC.bookKey = book.bookingID!
                
                if self.riderName.characters.count > 0{
                    destinationVC.bookName = self.riderName.capitalized
                }else{
                    destinationVC.bookName = self.riderEmail.capitalized
                }

                
                //destinationVC.bookName = riderEmail
                destinationVC.bookPhone = riderPhone
                destinationVC.bookTravelDate = book.rideBeginDate!
                destinationVC.bookFrom = book.rideFrom!.capitalized
                destinationVC.bookTo = book.rideTo!.capitalized
                destinationVC.bookNoOfTravellers = book.noOfTravellers!
                destinationVC.bookRoundTrip = book.roundTripFlag!.capitalized
                
                if book.status == "Quoted"{
                    destinationVC.bookStatus = "Quote Sent"
                }else{
                    destinationVC.bookStatus = book.status!
                }
                destinationVC.bookAmount = book.amount!
                destinationVC.bookVehicle = book.vehicle!
                
                destinationVC.bookStatus = book.status!
            }
            
        }
    }
}
