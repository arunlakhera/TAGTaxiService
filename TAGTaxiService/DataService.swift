//
//  DataService.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation
import Firebase

let TAGBase = FIRDatabase.database().reference()
let TAGStorageBase = FIRStorage.storage().reference()

class DataService{
    
    static let ds = DataService()
  
    private var _REF_RIDER = TAGBase.child("RIDER")
    private var _REF_RIDEBOOKING = TAGBase.child("RIDEBOOKING")
    private var _REF_VEHICLE = TAGBase.child("VEHICLE")
    private var _REF_DRIVER_IMAGE = TAGStorageBase.child("driverPics")
    private var _REF_DRIVER = TAGBase.child("DRIVER")
    private var _REF_VEHICLE_IMAGE = TAGStorageBase.child("vehiclePics")
    
    var REF_RIDER: FIRDatabaseReference{
        return _REF_RIDER
    }
    
    var REF_RIDEBOOKING: FIRDatabaseReference{
        return _REF_RIDEBOOKING
    }
    
    var REF_VEHICLE: FIRDatabaseReference{
        return _REF_VEHICLE
    }
    
    var REF_DRIVER: FIRDatabaseReference{
        return _REF_DRIVER
    }
    var REF_DRIVER_IMAGE: FIRStorageReference{
        return _REF_DRIVER_IMAGE
    }
    var REF_VEHICLE_IMAGE: FIRStorageReference{
        return _REF_VEHICLE_IMAGE
    }
    
}
