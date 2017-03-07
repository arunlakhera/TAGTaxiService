//
//  Rider.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//
// RIDER Object


import Foundation

class Rider{
  
    private var _riderID: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _emailID: String!
    private var _phoneNumber: String!
    private var _dateOfBirth: String!
    private var _gender: String!
    private var _address: String!
    private var _city: String!
    private var _state: String!
    private var _pinCode: String!
 
    var riderID: String?{ return _riderID }
    var firstName: String?{ return _firstName }
    var lastName: String?{ return _lastName }
    var emailID: String?{ return _emailID }
    var phoneNumber: String?{ return _phoneNumber }
    var dateOfBirth: String?{ return _dateOfBirth }
    var gender: String?{ return _gender }
    var address: String?{ return _address }
    var city: String?{ return _city }
    var state: String?{ return _state }
    var pinCode: String?{ return _pinCode }
 
    
    init(riderID: String, firstName: String, lastName: String, emailID: String, phoneNumber: String, dateOfBirth: String, gender: String, address: String, city: String, state: String, pinCode: String)
    {
        self._riderID = riderID
        self._firstName = firstName
        self._lastName = lastName
        self._emailID = emailID
        self._phoneNumber = phoneNumber
        self._dateOfBirth = dateOfBirth
        self._gender = gender
        self._address = address
        self._city = city
        self._state = state
        self._pinCode = pinCode
      }
    
    init( riderID: String, dictionary: Dictionary<String, AnyObject> )
        {
        self._riderID = riderID
    
        if let firstName = dictionary["firstname"] as? String{ self._firstName = firstName }
        if let lastName = dictionary["lastname"] as? String{ self._lastName = lastName }
        if let emailID = dictionary["emailID"] as? String{ self._emailID = emailID }
        if let phoneNumber = dictionary["phonenumber"] as? String{ self._phoneNumber = phoneNumber }
        if let dateOfBirth = dictionary["dateOfBirth"] as? String{ self._dateOfBirth = dateOfBirth }
        if let gender = dictionary["gender"] as? String{ self._gender = gender }
        if let address = dictionary["address"] as? String{ self._address = address }
        if let city = dictionary["city"] as? String{ self._city = city }
        if let state = dictionary["state"] as? String{ self._state = state }
        if let pinCode = dictionary["pincode"] as? String{ self._pinCode = pinCode }

    }

}
