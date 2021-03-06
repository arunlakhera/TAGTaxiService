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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = view.center
        //activityIndicator.activityIndicatorViewStyle = .gray
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         riderName = ""
         riderEmail = ""
         //riderPhone = []()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateformatter.dateFormat = "YYYY-MM-dd"
        self.toolBar.topItem?.title =  "\(bookingStatusList) List"
        
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
        if bookings.count == 0{
            self.stopActivity()
        }
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
           
            let riderData = Rider(riderID: book.riderID!, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
           
            if (riderData.firstName?.characters.count)! > 0 {
                self.riderName = (riderData.firstName)!
            }else{
                self.riderName = ""
            }
            
            if (riderData.lastName?.characters.count)! > 0 {
                self.riderName = self.riderName + " " + (riderData.lastName)!
            }else{
                self.riderName = self.riderName + "" + ""
            }
            
            if (self.riderName.characters.count) <= 0 {
                self.riderName = String(describing: riderData.emailID)
            }
            
            cell?.nameLabel.text = self.riderName.capitalized
            
        })
        
        cell?.fromToLabel.text = "\(rideFrom!.substring(to: indexFrom!)) - \(rideTo!.substring(to: indexTo!))".capitalized
        cell?.travelDateLabel.text = book.rideBeginDate!.capitalized
        cell?.statusLabel.text = book.status!.capitalized
        
        if book.status! == "Pending"{
            cell?.statusLabel.textColor = UIColor.yellow
            cell?.fromToLabel.textColor = UIColor.yellow
            cell?.travelDateLabel.textColor = UIColor.yellow
            cell?.nameLabel.textColor = UIColor.yellow
        }else if book.status! == "Accepted"{
            cell?.statusLabel.textColor = UIColor.green
            cell?.fromToLabel.textColor = UIColor.green
            cell?.travelDateLabel.textColor = UIColor.green
            cell?.nameLabel.textColor = UIColor.green            
        } else if book.status! == "Declined" || book.status! == "Cancelled"{
            cell?.statusLabel.textColor = UIColor.red
            cell?.fromToLabel.textColor = UIColor.red
            cell?.travelDateLabel.textColor = UIColor.red
            cell?.nameLabel.textColor = UIColor.red
        }else if book.status! == "Quoted"{
            cell?.statusLabel.textColor = UIColor.cyan
            cell?.fromToLabel.textColor = UIColor.cyan
            cell?.travelDateLabel.textColor = UIColor.cyan
            cell?.nameLabel.textColor = UIColor.cyan
        }else if book.status! == "Completed"{
            cell?.statusLabel.textColor = UIColor.white
            cell?.fromToLabel.textColor = UIColor.white
            cell?.travelDateLabel.textColor = UIColor.white
            cell?.nameLabel.textColor = UIColor.white
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
                     cell?.sendCabAlert.alpha = 0
                    
            }, completion: nil)
        }else{
            cell?.sendCabAlert.isHidden = true
            cell?.travelDateLabel.alpha = 1
        }
        self.stopActivity()
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
                let selectedBooking = bookings.reversed()[ip]
                
                destinationVC.bookKey = selectedBooking.bookingID!
                destinationVC.riderID = selectedBooking.riderID!
               // destinationVC.bookPhone =  riderPhone
                destinationVC.bookTravelDate = selectedBooking.rideBeginDate!
                destinationVC.bookFrom = selectedBooking.rideFrom!.capitalized
                destinationVC.bookTo = selectedBooking.rideTo!.capitalized
                destinationVC.bookNoOfTravellers = selectedBooking.noOfTravellers!
                destinationVC.bookRoundTrip = selectedBooking.roundTripFlag!.capitalized
                
                if selectedBooking.status == "Quoted"{
                    destinationVC.bookStatus = "Quote Sent"
                }else{
                    destinationVC.bookStatus = selectedBooking.status!
                }
                destinationVC.bookAmount = selectedBooking.amount!
                destinationVC.bookVehicle = selectedBooking.vehicle!
                destinationVC.bookStatus = selectedBooking.status!
            }
            
        }
    }
}
