//
//  Driver.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation

class Driver{
    
    private var _driverID: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _phoneNumber: String!
    private var _dateOfBirth: String!
    private var _address1: String!
    private var _address2: String!
    private var _city: String!
    private var _state: String!
    private var _drivingLicenseNo: String!
    private var _drivingLicenseValidFrom: String!
    private var _drivingLicenseValidTill: String!
    private var _bloodGroup: String!
    
    private var _policeVerified: String!
    private var _active: String!
    
    var driverID: String?{ return _driverID }
    var firstName: String?{ return _firstName }
    var lastName: String?{ return _lastName }
    var phoneNumber: String?{ return _phoneNumber }
    var dateOfBirth: String?{ return _dateOfBirth }
    var address1: String?{ return _address1 }
    var address2: String?{ return _address2 }
    var city: String?{ return _city }
    var state: String?{ return _state }
    var drivingLicenseNo: String?{ return _drivingLicenseNo }
    var drivingLicenseValidFrom: String?{ return _drivingLicenseValidFrom }
    var drivingLicenseValidTill: String?{ return _drivingLicenseValidTill }
    var bloodGroup: String?{ return _bloodGroup }
    var policeVerified: String?{ return _policeVerified }
    var active: String?{ return _active }
    
    init(driverID: String, firstName: String, lastName: String, phoneNumber: String, dateOfBirth: String, address1: String, address2: String, city: String, state: String, drivingLicenseNo: String, drivingLicenseValidFrom: String, drivingLicenseValidTill: String, bloodGroup: String, policeVerified: String, active: String) {
       
        self._driverID = driverID
        self._firstName = firstName
        self._lastName = lastName
        self._phoneNumber = phoneNumber
        self._dateOfBirth = dateOfBirth
        self._address1 = address1
        self._address2 = address2
        self._city = city
        self._state = state
        self._drivingLicenseNo = drivingLicenseNo
        self._drivingLicenseValidFrom = drivingLicenseValidFrom
        self._drivingLicenseValidTill = drivingLicenseValidTill
        self._bloodGroup = bloodGroup
        self._policeVerified = policeVerified
        self._active = active
    
    }
    
    init(driverID: String, dictionary: Dictionary<String, AnyObject>) {
        self._driverID = driverID
        
        if let firstName = dictionary["FirstName"] as? String{ self._firstName = firstName}
        if let lastName = dictionary["LastName"] as? String{ self._lastName  = lastName}
        if let phoneNumber = dictionary["PhoneNumber"] as? String{ self._phoneNumber = phoneNumber}
        if let dateOfBirth = dictionary["DateOfBirth"] as? String{ self._dateOfBirth = dateOfBirth}
        if let address1 = dictionary["Address1"] as? String{ self._address1 = address1}
        if let address2 = dictionary["Address2"] as? String{ self._address2 = address2}
        if let city = dictionary["City"] as? String{ self._city = city}
        if let state = dictionary["State"] as? String{ self._state = state}
        if let drivingLicenseNo = dictionary["DLNumber"] as? String{ self._drivingLicenseNo = drivingLicenseNo}
        if let drivingLicenseValidFrom = dictionary["DLValidFrom"] as? String{ self._drivingLicenseValidFrom = drivingLicenseValidFrom}
        if let drivingLicenseValidTill = dictionary["DLValidTill"] as? String{ self._drivingLicenseValidTill = drivingLicenseValidTill}
        if let policeVerified = dictionary["PoliceVerified"] as? String{ self._policeVerified = policeVerified}
        if let bloodGroup = dictionary["BloodGroup"] as? String{ self._bloodGroup = bloodGroup}
        if let active = dictionary["Active"] as? String{ self._active = active}
        
    }
    
}
