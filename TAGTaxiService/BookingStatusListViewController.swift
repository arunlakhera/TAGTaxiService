//
//  BookingStatusListViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/8/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class BookingStatusListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Variables
    var TAGRiderBooking = DataService.ds.REF_RIDER.child(riderID).child("Booking")
    var bookings = [RideBooking]()
    var riderName = ""
    var riderEmail = ""
    var riderPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Load all the bookings of the User
   
        self.tableView.reloadData()
        
        TAGRiderBooking.observe(.value, with: { snapshot in
            
                self.bookings = []
            
            
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    
                    for snap in snapshots{
                        DataService.ds.REF_RIDEBOOKING.observe(.value, with: { bookingSnap in
                           
                            if let bookSnap = bookingSnap.children.allObjects as? [FIRDataSnapshot]{
                                for book in bookSnap {
                                    
                                    if book.key == snap.key{
                                        
                                        if let bookDict = book.value as? Dictionary<String, String>{

                                            let key = book.key
                                            let book = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
                                            self.bookings.append(book)
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            self.tableView.reloadData()
                            
                        }, withCancel: { error in
                            self.errorLogin(errTitle: "ERROR!", errMessage: "Error occured whilte fetching Booking Record -- \(error.localizedDescription)")
                        })
                        
                    }
            }
            
        }) { error in
            self.errorLogin(errTitle: "ERROR!", errMessage: "Not to able to fetch the booking list.")
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookListCell", for: indexPath) as? BookListTableViewCell
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

        //cell?.nameLabel.text =  riderEmail
        cell?.fromToLabel.text = "\(rideFrom!.substring(to: indexFrom!)) - \(rideTo!.substring(to: indexTo!))"
        cell?.TravelDateLabel.text = book.rideBeginDate!
        cell?.statusLabel.text = book.status!

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "bookDetailSegue" {
            
            if let destinationVC = segue.destination as? BookingDetailViewController {
                
                let ip = (self.tableView.indexPathForSelectedRow?.row)!
                let book = bookings.reversed()[ip]
                
                destinationVC.bookKey = book.bookingID!
                
                if self.riderName.characters.count > 0{
                    destinationVC.bookName = self.riderName.capitalized
                }else{
                    destinationVC.bookName = self.riderEmail.capitalized
                }
                
                destinationVC.bookTravelDate = book.rideBeginDate!.capitalized
                destinationVC.bookFrom = book.rideFrom!.capitalized
                destinationVC.bookTo = book.rideTo!.capitalized
                destinationVC.bookPhone =  riderPhone
                destinationVC.bookRoundTrip = book.roundTripFlag!.capitalized
                destinationVC.bookNoOfTravellers = book.noOfTravellers!
                destinationVC.bookAmount = book.amount!
                destinationVC.bookStatus = book.status!.capitalized
                
                
                if book.status! == "Quoted"{
                    destinationVC.bookStatus = "Quote Received"
                }else{
                    destinationVC.bookStatus = book.status!.capitalized
                }
                destinationVC.bookVehicle = book.vehicle!.capitalized
            }
        }
    }
    
    
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
