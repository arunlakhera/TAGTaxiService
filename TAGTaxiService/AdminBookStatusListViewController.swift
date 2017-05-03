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
    @IBOutlet weak var toolBar: UINavigationBar!
    @IBOutlet weak var toolBarTitle: UILabel!
    
    var bookings = [RideBooking]()
    var riderName = ""
    var riderEmail = ""
    var riderPhone = ""
    
    var travelBeginDate: String?
    var upcomingTravelCount = 0
    var numberOfDaysForTravel = 0
    let dateformatter = DateFormatter()
    let todayDate = Date()
    var today: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         riderName = ""
         riderEmail = ""
         riderPhone = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateformatter.dateFormat = "YYYY-MM-dd"

        toolBarTitle.text = "\(bookingStatusList) List"
   
        DataService.ds.REF_RIDEBOOKING.observe(.value, with: { (snapshot) in
            self.bookings = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let bookDict = snap.value as? Dictionary<String, String>{
                        
                        let key = snap.key
                        let booking = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
        
                        if booking.status == bookingStatusList{
                            self.bookings.append(booking)
                            
                        }
                    }
                }
            }
         self.tableView.reloadData()
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
        
        riderProfile.observe(.value, with: { (snapshot) in
           
            let riderProfile = Rider(riderID: book.riderID!, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
           
            if (riderProfile.firstName?.characters.count)! > 0 {
                self.riderName = (riderProfile.firstName)!
            }else{
                self.riderName = ""
            }
            
            if (riderProfile.lastName?.characters.count)! > 0 {
                self.riderName = self.riderName + " " + (riderProfile.lastName)!
            }else{
                self.riderName = self.riderName + "" + ""
            }
            
            if (self.riderName.characters.count) <= 0 {
                self.riderName = String(describing: riderProfile.emailID)
            }
            
            self.riderPhone = riderProfile.phoneNumber!
            cell?.nameLabel.text = self.riderName
            
             print("==INCELL==>>>>>>> \(self.riderName.capitalized)")
            
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
        
        self.travelBeginDate = (book.rideBeginDate != nil ? book.rideBeginDate : "2000-01-01" )
        self.today = self.dateformatter.string(from: self.todayDate)
        
        self.numberOfDaysForTravel = Int((self.dateformatter.date(from: self.travelBeginDate!)!.timeIntervalSince(self.dateformatter.date(from: self.today!)!) ) / ( 24 * 60 * 60))
        
        if (self.numberOfDaysForTravel == 1 && book.status! == "Accepted") {
            cell?.travelDateLabel.textColor = UIColor.red
            cell?.sendCabAlert.isHidden = false
            
            cell?.travelDateLabel.alpha = 1
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse, []], animations:
                {
                    //cell?.travelDateLabel.alpha = 0
                    cell?.sendCabAlert.alpha = 0
                    
            }, completion: nil)
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
                
                destinationVC.riderID = book.riderID!
                /*
                if riderName.characters.count > 0{
                    destinationVC.bookName = riderName.capitalized
                    print("====rider prep segue outside observe>>>>>>> \(riderName.capitalized)")
                }else{
                    destinationVC.bookName = riderEmail.capitalized
                }
                */
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
                //destinationVC.bookVehicleType = book.vehicle
                destinationVC.bookStatus = book.status!
            }
            
        }
    }
}
