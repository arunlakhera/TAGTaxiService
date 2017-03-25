//
//  MainMenuViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

var TravelFromCity = ""

class MainMenuViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Outlets
    @IBOutlet weak var riderMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
 
    // Menu View Outlets
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    // MARK: Variables for Location manager
    let manager = CLLocationManager()
    var menuShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Menu Properties
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        
       // AuthService.instance.riderID = riderID
        //AuthService.instance.riderEmail = riderEmail
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    // Function to find the current location of user.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            // Get latest location of user
            let location = locations[0]
            // zoom to that location of user
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            riderMap.setRegion(region, animated: true)
       
            self.riderMap.showsUserLocation = true
        
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
                if error == nil{
     
                        let placemark = placemark?.first
                        let addDic = placemark?.addressDictionary
     
                        let street =  (addDic!["Street"] != nil ? addDic!["Street"] : "Not Available")!
                        let sublocality = (addDic!["SubLocality"] != nil ? addDic!["SubLocality"] : "Not Available")!
                        let city = (addDic!["City"] != nil ? addDic!["City"] : "Not Available")!
                        TravelFromCity = city as! String
                        let zip = (addDic!["ZIP"] != nil ? addDic!["ZIP"] : "Not Available")!
                        let country = (placemark?.country != nil ? placemark?.country : "Not Available")!
                        let myAddress = "\(street) \n \(sublocality) \n \(city)  \(zip)  \(country)"
     
                        print("My Address--->>> \(myAddress)")
                        self.addressLabel.text = myAddress
                    
                        manager.stopUpdatingLocation()
                    
                }
        }
    }
   
    // Action when Menu button is clicked, Menu slides from left
    @IBAction func menuButton(_ sender: Any) {
        if (menuShow){
            leadingConstraint.constant = 0
            menuNameLabel.text = AuthService.instance.userName
            
        }else{
            leadingConstraint.constant = -170
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        menuShow = !menuShow
    }
    
    // Action when booking Status button is pressed in Menu
    
    @IBAction func menuBookingStatus(_ sender: Any) {
        bookingStatusButton(Any.self)
    }
    
    //  Action when book a Ride button is pressed in Menu
    @IBAction func menuBookARide(_ sender: Any) {
         bookARideButton(Any.self)
    }
    
    // To navigate to Riders Profile Screen
    @IBAction func menuEditProfile(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegue", sender: nil)
    }
    
    // To log out the user
    @IBAction func menuSignOut(_ sender: Any) {
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.riderID = ""
        AuthService.instance.riderEmail = ""
        AuthService.instance.userName = ""
        
        do{
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logOutSegue", sender: self)
        }catch{
            print("Error While Signing Out")
        }
    }
    
    // To navigate to Booking Screen
    @IBAction func bookARideButton(_ sender: Any) {
        self.performSegue(withIdentifier: "bookARideSegue", sender: UIButton())
    }
    
    // To navigate to Status screen
    @IBAction func bookingStatusButton(_ sender: Any) {
      
        self.performSegue(withIdentifier: "mainToStatusSegue", sender: UIButton())

    }
    
    // To slide the menu back call menu button function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menuShow = false
        menuButton(touches)
    }
    
}
  
