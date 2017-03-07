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
    private var _address: String!
    private var _city: String!
    private var _state: String!
    private var _pinCode: String!
    private var _phoneNumber: String!
    private var _drivingLicenseNo: String!
    private var _drivingLicenseExpDate: String!
    private var _policeVerifiedFlag: String!
    private var _isActiveFlag: String!
    private var _inactiveDate: String!
    
    var driverID: String?{ return _driverID }
    var firstName: String?{ return _firstName }
    var lastName: String?{ return _lastName }
    var address: String?{ return _address }
    var city: String?{ return _city }
    var state: String?{ return _state }
    var pinCode: String?{ return _pinCode }
    var phoneNumber: String?{ return _phoneNumber }
    var drivingLicenseNo: String?{ return _drivingLicenseNo }
    var drivingLicenseExpDate: String?{ return _drivingLicenseExpDate }
    var policeVerifiedFlag: String?{ return _policeVerifiedFlag }
    var isActiveFlag: String?{ return _isActiveFlag }
    var inactiveDate: String?{ return _inactiveDate }
    
    init(driverID: String, firstName: String, lastName: String, address: String, city: String, state: String, pinCode: String, phoneNumber: String, drivingLicenseNo: String, drivingLicenseExpDate: String, policeVerifiedFlag: String, isActiveFlag: String, inactiveDate: String) {
       
        self._driverID = driverID
        self._firstName = firstName
        self._lastName = lastName
        self._address = address
        self._city = city
        self._state = state
        self._pinCode = pinCode
        self._phoneNumber = phoneNumber
        self._drivingLicenseNo = drivingLicenseNo
        self._drivingLicenseExpDate = drivingLicenseExpDate
        self._policeVerifiedFlag = policeVerifiedFlag
        self._isActiveFlag = isActiveFlag
        self._inactiveDate = inactiveDate
    
    }
    
    init(driverID: String, dictionary: Dictionary<String, AnyObject>) {
        self._driverID = driverID
        
        if let firstName = dictionary["firstname"] as? String{ self._firstName = firstName}
        if let lastName = dictionary["lastName"] as? String{ self._lastName  = lastName}
        if let address = dictionary["address"] as? String{ self._address = address}
        if let city = dictionary["city"] as? String{ self._city = city}
        if let state = dictionary["state"] as? String{ self._state = state}
        if let pinCode = dictionary["pincode"] as? String{ self._pinCode = pinCode}
        if let phoneNumber = dictionary["phonenumber"] as? String{ self._phoneNumber = phoneNumber}
        if let drivingLicenseNo = dictionary["drivinglicenseno"] as? String{ self._drivingLicenseNo = drivingLicenseNo}
        if let drivingLicenseExpDate = dictionary["drivinglicenseexpdate"] as? String{ self._drivingLicenseExpDate = drivingLicenseExpDate}
        if let policeVerifiedFlag = dictionary["policeverifiedflag"] as? String{ self._policeVerifiedFlag = policeVerifiedFlag}
        if let isActiveFlag = dictionary["isactiveflag"] as? String{ self._isActiveFlag = isActiveFlag}
        if let inactiveDate = dictionary["inactivedate"] as? String{ self._inactiveDate = inactiveDate}
        
    }
    
}
