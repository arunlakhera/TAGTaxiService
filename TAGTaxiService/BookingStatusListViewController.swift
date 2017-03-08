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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Load all the bookings of the User
   
        TAGRiderBooking.observe(.value, with: { snapshot in
            
            print("---> ALL BOOKINGS OF USER ---\(riderEmail)--->> \(snapshot.children.allObjects)")
            
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
        let book = bookings[indexPath.row]
        
        cell?.nameLabel.text = riderEmail
        cell?.fromToLabel.text = "\(book.rideFrom!) - \(book.rideTo!)"
        cell?.TravelDateLabel.text = book.rideBeginDate!
        cell?.statusLabel.text = book.status!
        
        return cell!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func errorLogin(errTitle: String, errMessage: String){
        
        let alert = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
