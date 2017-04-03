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
    
    
    @IBOutlet weak var driverButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    
    // MARK: Variables
    var pendingCount = 0
    var quotedCount = 0
    var acceptedCount = 0
    var declinedCount = 0
    var cancelledCount = 0
    var completedCount = 0
    
    var driverButtonCenter: CGPoint!
    var bookingButtonCenter: CGPoint!
    var vehicleButtonCenter: CGPoint!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startActivity(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        driverButtonCenter = driverButton.center
        bookingButtonCenter = bookingButton.center
        vehicleButtonCenter = vehicleButton.center
        
        driverButton.center = moreButton.center
        bookingButton.center = moreButton.center
        vehicleButton.center = moreButton.center

        toggleButtonImage(button: bookingButton, onImage: #imageLiteral(resourceName: "BookingsButtonOn"), offImage: #imageLiteral(resourceName: "BookingsButtonOff"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivity()
        
        
        DataService.ds.REF_RIDEBOOKING.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in snapshots{
                    
                    if let bookDict = snap.value as? Dictionary<String, String>{
                        let key = snap.key
                        let bookings = RideBooking(bookingID: key, dictionary: bookDict as Dictionary<String, AnyObject>)
                    
                        if bookings.status == "Pending"{
                            self.pendingCount = self.pendingCount + 1
                        }else if bookings.status == "Quoted"{
                            self.quotedCount = self.quotedCount + 1
                        }else if bookings.status == "Accepted"{
                            self.acceptedCount = self.acceptedCount + 1
                        }else if bookings.status == "Declined"{
                            self.declinedCount = self.declinedCount + 1
                        }else if bookings.status == "Cancelled"{
                            self.cancelledCount = self.cancelledCount + 1
                        }else if bookings.status == "Completed"{
                            self.completedCount = self.completedCount + 1
                        }
                    
                    }
                }
            } else{
                print("No Records Fetched...")
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
    
        self.stopActivity()
        
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
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.isAdmin = false
        AuthService.instance.riderID = ""
        AuthService.instance.riderEmail = ""
        AuthService.instance.userName = ""
        
        do{
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "adminLogoutSegue", sender: self)
        }catch{
            print("Error While Signing Out")
        }
    }
    
    /// More Button Outlets
    
    @IBAction func moreButtonClicked(_ sender: UIButton) {
        
        if moreButton.currentImage == #imageLiteral(resourceName: "MoreButtonOff"){
            UIView.animate(withDuration: 0.3, animations: {
                // animations here
                
                self.driverButton.alpha = 1
                self.bookingButton.alpha = 1
                self.vehicleButton.alpha = 1
                
                self.driverButton.center = self.driverButtonCenter
                self.bookingButton.center = self.bookingButtonCenter
                self.vehicleButton.center = self.vehicleButtonCenter
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.driverButton.alpha = 0
                self.bookingButton.alpha = 0
                self.vehicleButton.alpha = 0
                
                self.driverButton.center = self.moreButton.center
                self.bookingButton.center = self.moreButton.center
                self.vehicleButton.center = self.moreButton.center
            })
        }
        
        toggleButtonImage(button: moreButton, onImage: #imageLiteral(resourceName: "MoreButtonOn"), offImage: #imageLiteral(resourceName: "MoreButtonOff"))
    }
    
    @IBAction func driverButtonClicked(_ sender: UIButton) {
        toggleButtonImage(button: driverButton , onImage: #imageLiteral(resourceName: "DriverButtonOn"), offImage: #imageLiteral(resourceName: "DriverButtonOff"))
        
        if bookingButton.currentImage == #imageLiteral(resourceName: "BookingsButtonOn"){
        toggleButtonImage(button: bookingButton, onImage: #imageLiteral(resourceName: "BookingsButtonOn"), offImage: #imageLiteral(resourceName: "BookingsButtonOff"))
        }
        if vehicleButton.currentImage == #imageLiteral(resourceName: "VehicleButtonOn"){
            toggleButtonImage(button: vehicleButton, onImage: #imageLiteral(resourceName: "VehicleButtonOn"), offImage: #imageLiteral(resourceName: "VehicleButtonOff"))
        }
        
        
    }
    
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        toggleButtonImage(button: bookingButton, onImage: #imageLiteral(resourceName: "BookingsButtonOn"), offImage: #imageLiteral(resourceName: "BookingsButtonOff"))
        
        if driverButton.currentImage == #imageLiteral(resourceName: "DriverButtonOn"){
            toggleButtonImage(button: driverButton , onImage: #imageLiteral(resourceName: "DriverButtonOn"), offImage: #imageLiteral(resourceName: "DriverButtonOff"))
        }
        if vehicleButton.currentImage == #imageLiteral(resourceName: "VehicleButtonOn"){
            toggleButtonImage(button: vehicleButton, onImage: #imageLiteral(resourceName: "VehicleButtonOn"), offImage: #imageLiteral(resourceName: "VehicleButtonOff"))
        }

        
    }
    
    @IBAction func vehicleButtonClicked(_ sender: UIButton) {
        toggleButtonImage(button: vehicleButton, onImage: #imageLiteral(resourceName: "VehicleButtonOn"), offImage: #imageLiteral(resourceName: "VehicleButtonOff"))
        
        if driverButton.currentImage == #imageLiteral(resourceName: "DriverButtonOn"){
            toggleButtonImage(button: driverButton , onImage: #imageLiteral(resourceName: "DriverButtonOn"), offImage: #imageLiteral(resourceName: "DriverButtonOff"))
        }
        if bookingButton.currentImage == #imageLiteral(resourceName: "BookingsButtonOn"){
            toggleButtonImage(button: bookingButton, onImage: #imageLiteral(resourceName: "BookingsButtonOn"), offImage: #imageLiteral(resourceName: "BookingsButtonOff"))
        }
        
    }
    

    func toggleButtonImage(button: UIButton, onImage: UIImage, offImage: UIImage){
        
        if button.currentImage == offImage{
            button.setImage(onImage, for: .normal)
        }else{
            button.setImage(offImage, for: .normal)
        }
    }
    
    
}
