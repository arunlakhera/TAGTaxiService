//
//  AdminMainBookingViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/15/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

var bookingStatusList = ""

class AdminMainBookingViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var pendingCountButton: UIButton!
    @IBOutlet weak var quotedCountButton: UIButton!
    @IBOutlet weak var acceptedCountButton: UIButton!
    @IBOutlet weak var declinedCountButton: UIButton!
    @IBOutlet weak var cancelledCountButton: UIButton!
    @IBOutlet weak var completedCountButton: UIButton!
    
    // MARK: Variables
    var pendingCount = 0
    var quotedCount = 0
    var acceptedCount = 0
    var declinedCount = 0
    var cancelledCount = 0
    var completedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_RIDEBOOKING.observe(.value, with: { (snapshot) in
       
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in snapshots{
                    
                    if let bookDict = snap.value as? Dictionary<String, String>{
                        let key = snap.key
                        let bookings = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
                    
                        if bookings.status! == "Pending"{
                            self.pendingCount = self.pendingCount + 1
                        }else if bookings.status! == "Quoted"{
                            self.quotedCount = self.quotedCount + 1
                        }else if bookings.status! == "Accepted"{
                            self.acceptedCount = self.acceptedCount + 1
                        }else if bookings.status! == "Declined"{
                            self.declinedCount = self.declinedCount + 1
                        }else if bookings.status! == "Cancelled"{
                            self.cancelledCount = self.cancelledCount + 1
                        }else if bookings.status! == "Completed"{
                            self.completedCount = self.completedCount + 1
                        }
                        
                    
                    }
                }
            }
            
            self.pendingCountButton.setTitle(String(self.pendingCount), for: .normal)
            self.quotedCountButton.setTitle(String(self.quotedCount), for: .normal)
            self.acceptedCountButton.setTitle(String(self.acceptedCount), for: .normal)
            self.declinedCountButton.setTitle(String(self.declinedCount), for: .normal)
            self.cancelledCountButton.setTitle(String(self.cancelledCount), for: .normal)
            self.completedCountButton.setTitle(String(self.completedCount), for: .normal)
            
        
        }) { (error) in
            print("Error Occured while calculating Admin data")
        }
        
    }

    @IBAction func pendingButton(_ sender: UIButton) {
        bookingStatusList = "Pending"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func quotedButton(_ sender: UIButton) {
        bookingStatusList = "Quoted"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func acceptedButton(_ sender: UIButton) {
        bookingStatusList = "Accepted"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func declinedButton(_ sender: UIButton) {
        bookingStatusList = "Declined"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func cancelledButton(_ sender: UIButton) {
        bookingStatusList = "Cancelled"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func completedButton(_ sender: UIButton) {
        bookingStatusList = "Completed"
        self.performSegue(withIdentifier: "adminBookListSegue", sender: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            AuthService.instance.isLoggedIn = false
            self.performSegue(withIdentifier: "adminLogoutSegue", sender: self)
        }catch{
            print("Error While Signing Out")
        }
    }
    
    
}
