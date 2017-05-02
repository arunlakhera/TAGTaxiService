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
   
   // var TAGRiderBooking = DataService.ds.REF_RIDER.child(riderID).child("Booking")
    var TAGRiderBooking = DataService.ds.REF_RIDER.child(AuthService.instance.riderID!).child("Booking")
    
    var bookings = [RideBooking]()
    var riderName = AuthService.instance.userName!
    var riderEmail = AuthService.instance.riderEmail!
    var riderPhone = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        
        activityIndicator.stopAnimating()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.startActivity()
        
       self.tableView.reloadData()
        
       DataService.ds.REF_RIDEBOOKING.observe(.value, with: { (bookingSnapshot) in
        self.bookings = []
        if let bookSnap = bookingSnapshot.children.allObjects as? [FIRDataSnapshot]{
            for book in bookSnap{
                self.TAGRiderBooking.observe(.value, with: { (snapshots) in
                    
                    if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]{
                        for snap in snapshot{
                            
                            if book.key == snap.key{
                                if let bookDict = book.value as? Dictionary<String, String>{
                                    let key = book.key
                                    let book = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
                                    self.bookings.append(book)
                                   
                                    let riderProfile = DataService.ds.REF_RIDER.child(book.riderID!).child("Profile")
                                    riderProfile.observeSingleEvent(of: .value, with: { (snapshot) in
                                        let value = snapshot.value as? NSDictionary
                                        self.riderName = "\(value?["FirstName"] as? String ?? "")  \(value?["LastName"] as? String ?? "")"
                                        self.riderEmail = value?["EmailID"] as? String ?? ""
                                        self.riderPhone = value?["PhoneNumber"] as? String ?? ""
                                        self.tableView.reloadData() // no
                                    })
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }, withCancel: { (error) in
                    print("Error Occured while fetching Rider Bookings...\(error.localizedDescription)")
                })
            }
        }
        
        self.tableView.reloadData()
       }) { (error) in
            print("Error Occured while checking Bookings.. \(error.localizedDescription)")
        }
        //self.tableView.reloadData()
        self.stopActivity()
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
        
        if (rideFrom?.characters.count)! > 10{
            let indexFrom = rideFrom?.index((rideFrom!.startIndex), offsetBy: 10)
            cell?.fromLabel.text = rideFrom!.substring(to: indexFrom!)
        }else{
            cell?.fromLabel.text = rideFrom
        }
       
        if (rideTo?.characters.count)! > 10{
            let indexTo = rideTo?.index((rideTo!.startIndex), offsetBy: 10)
            cell?.toLabel.text = rideTo!.substring(to: indexTo!)
        }else{
            cell?.toLabel.text = rideTo
        }
        
        
      /*
        if self.riderName.characters.count > 0{
            cell?.nameLabel.text = self.riderName
        }else{
            cell?.nameLabel.text = self.riderEmail
        }
      */
        //cell?.fromToLabel.text = "\(rideFrom!.substring(to: indexFrom!)) - \(rideTo!.substring(to: indexTo!))"
        
        
        cell?.TravelDateLabel.text = book.rideBeginDate!
        cell?.statusLabel.text = book.status!

        if book.status! == "Pending"{
            //cell?.nameLabel.textColor = UIColor.yellow
            cell?.fromLabel.textColor = UIColor.yellow
            cell?.toLabel.textColor = UIColor.yellow
            //cell?.fromToLabel.textColor = UIColor.yellow
            cell?.TravelDateLabel.textColor = UIColor.yellow
            cell?.statusLabel.textColor = UIColor.yellow
        }else if book.status! == "Accepted"{
            //cell?.nameLabel.textColor = UIColor.green
            //cell?.fromToLabel.textColor = UIColor.green
            cell?.fromLabel.textColor = UIColor.green
            cell?.toLabel.textColor = UIColor.green
            cell?.TravelDateLabel.textColor = UIColor.green
            cell?.statusLabel.textColor = UIColor.green
        } else if book.status! == "Declined" || book.status! == "Cancelled"{
            //cell?.nameLabel.textColor = UIColor.red
            //cell?.fromToLabel.textColor = UIColor.red
            cell?.fromLabel.textColor = UIColor.red
            cell?.toLabel.textColor = UIColor.red
            cell?.TravelDateLabel.textColor = UIColor.red
            cell?.statusLabel.textColor = UIColor.red
        }else if book.status! == "Quoted"{
            //cell?.nameLabel.textColor = UIColor.orange
            //cell?.fromToLabel.textColor = UIColor.orange
            cell?.fromLabel.textColor = UIColor.cyan
            cell?.toLabel.textColor = UIColor.cyan
            cell?.TravelDateLabel.textColor = UIColor.cyan
            cell?.statusLabel.textColor = UIColor.cyan
        }else if book.status! == "Completed"{
            //cell?.nameLabel.textColor = UIColor.white
            //cell?.fromToLabel.textColor = UIColor.white
            cell?.fromLabel.textColor = UIColor.white
            cell?.toLabel.textColor = UIColor.white
            cell?.TravelDateLabel.textColor = UIColor.white
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
    
    
    // Alert function to show messages
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
