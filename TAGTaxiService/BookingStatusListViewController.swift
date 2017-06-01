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
    @IBOutlet weak var statusSegment: UISegmentedControl!
    
    // MARK: Variables
   
   // var TAGRiderBooking = DataService.ds.REF_RIDER.child(riderID).child("Booking")
    var TAGRiderBooking = DataService.ds.REF_RIDER.child(AuthService.instance.riderID!).child("Booking")
    
    var bookings = [RideBooking]()
    var riderName = AuthService.instance.userName!
    var riderEmail = AuthService.instance.riderEmail!
    var riderPhone = ""
    
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
        startActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            tableView.delegate = self
            tableView.dataSource = self
            
            statusSegment.setTitle("Current", forSegmentAt: 0)
            statusSegment.setTitle("History", forSegmentAt: 1)
            statusSegment.selectedSegmentIndex = 0
            
            self.startActivity()
            
            loadData(status: "Current")
            self.stopActivity()
        
        }else{
           
            let alert = UIAlertController(title: "Failure!!", message: "Internet Connection not available! Connect to Internet", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            let callUs1 = UIAlertAction(title: "Call Tag Taxi - Phone 1", style: .default, handler: { (callAction) in
                
                if let phoneCallURL:URL = URL(string: "tel:\(MessageComposer.instance.callNumber1)") {
                    
                    let application:UIApplication = UIApplication.shared
                    
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }else{
                        self.showAlert(title: "Error", message: "Not able to make Phone Call!")
                    }
                    
                }else{
                    self.showAlert(title: "Error", message: "Not able to make Phone Call!")
                }
                
            })
            let callUs2 = UIAlertAction(title: "Call Tag Taxi - Phone 2", style: .default, handler: { (callAction) in
                
                if let phoneCallURL:URL = URL(string: "tel:\(MessageComposer.instance.callNumber2)") {
                    
                    let application:UIApplication = UIApplication.shared
                    
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }else{
                        self.showAlert(title: "Error", message: "Not able to make Phone Call!")
                    }
                    
                }else{
                    self.showAlert(title: "Error", message: "Not able to make Phone Call!")
                }
                
            })
            
            alert.addAction(okButton)
            alert.addAction(callUs1)
            alert.addAction(callUs2)
            present(alert, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func statusSegementSelected(_ sender: UISegmentedControl) {
        
        if statusSegment.selectedSegmentIndex == 0{
            loadData(status: "Current")
        }else if statusSegment.selectedSegmentIndex == 1{
            loadData(status: "History")
        }
    }
  
    
    
    func loadData(status: String){
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
                                        //self.bookings.append(book)
                                        // Changed
                                        if status == "History"{
                                            if book.status == "Completed" || book.status == "Declined" || book.status == "Cancelled"{
                                                self.bookings.append(book)
                                            }
                                        }else if status == "Current"{
                                                if book.status == "Pending" || book.status == "Quoted" || book.status == "Accepted" {
                                                    self.bookings.append(book)
                                                }
                                        }
                                        //
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookListCell", for: indexPath) as? BookListTableViewCell
        let book = bookings.reversed()[indexPath.row]
        let rideFrom = String(book.rideFrom!)
        let rideTo = String(book.rideTo!)
        
        if (rideFrom?.characters.count)! > 35{
            let indexFrom = rideFrom?.index((rideFrom!.startIndex), offsetBy: 35)
            cell?.fromLabel.text = rideFrom!.substring(to: indexFrom!)
        }else{
            cell?.fromLabel.text = rideFrom?.capitalized
        }
       
        if (rideTo?.characters.count)! > 35{
            let indexTo = rideTo?.index((rideTo!.startIndex), offsetBy: 35)
            cell?.toLabel.text = rideTo!.substring(to: indexTo!)
        }else{
            cell?.toLabel.text = rideTo?.capitalized
        }
        
        cell?.TravelDateLabel.text = book.rideBeginDate!
        cell?.statusLabel.text = book.status!

        if book.status! == "Pending"{
            cell?.fromLabel.textColor = UIColor.yellow
            cell?.toLabel.textColor = UIColor.yellow
            cell?.TravelDateLabel.textColor = UIColor.yellow
            cell?.statusLabel.textColor = UIColor.yellow
        }else if book.status! == "Accepted"{
            cell?.fromLabel.textColor = UIColor.green
            cell?.toLabel.textColor = UIColor.green
            cell?.TravelDateLabel.textColor = UIColor.green
            cell?.statusLabel.textColor = UIColor.green
        } else if book.status! == "Declined" || book.status! == "Cancelled"{
          
            cell?.fromLabel.textColor = UIColor.red
            cell?.toLabel.textColor = UIColor.red
            cell?.TravelDateLabel.textColor = UIColor.red
            cell?.statusLabel.textColor = UIColor.red
        }else if book.status! == "Quoted"{
            cell?.fromLabel.textColor = UIColor.cyan
            cell?.toLabel.textColor = UIColor.cyan
            cell?.TravelDateLabel.textColor = UIColor.cyan
            cell?.statusLabel.textColor = UIColor.cyan
        }else if book.status! == "Completed"{
            cell?.fromLabel.textColor = UIColor.white
            cell?.toLabel.textColor = UIColor.white
            cell?.TravelDateLabel.textColor = UIColor.white
            cell?.statusLabel.textColor = UIColor.white
        }
       self.stopActivity()
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
