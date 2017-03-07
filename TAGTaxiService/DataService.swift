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

class DataService{
    
    static let ds = DataService()
  
     private var _REF_RIDER = TAGBase.child("RIDER")
     private var _REF_RIDERBOOKING = TAGBase.child("RIDERBOOKING")
     private var _REF_VEHICLE = TAGBase.child("VEHICLE")
     private var _REF_DRIVER = TAGBase.child("DRIVER")
    
    
    var REF_RIDER: FIRDatabaseReference{
        return _REF_RIDER
    }
    
    var REF_RIDERBOOKING: FIRDatabaseReference{
        return _REF_RIDERBOOKING
    }
    
    var REF_VEHICLE: FIRDatabaseReference{
        return _REF_VEHICLE
    }
    
    var REF_DRIVER: FIRDatabaseReference{
        return _REF_DRIVER
    }
 
}
