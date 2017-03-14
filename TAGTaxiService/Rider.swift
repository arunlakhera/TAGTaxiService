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
  
   
    private var _firstName: String!
    private var _lastName: String!
    private var _address1: String!
    private var _address2: String!
    private var _city: String!
    private var _state: String!
    private var _phoneNumber: String!
    private var _dateOfBirth: String!
    private var _gender: String!
    private var _emailID: String!
    private var _riderID: String!
    
    
    var firstName: String?{ return _firstName }
    var lastName: String?{ return _lastName }
    var address1: String?{ return _address1 }
    var address2: String?{ return _address2 }
    var city: String?{ return _city }
    var state: String?{ return _state }
    var phoneNumber: String?{ return _phoneNumber }
    var dateOfBirth: String?{ return _dateOfBirth }
    var gender: String?{ return _gender }
    var emailID: String?{ return _emailID }
    var riderID: String?{ return _riderID }
 
    init(riderID: String, firstName: String, lastName: String, address1: String, address2: String, city: String, state: String, phoneNumber: String, dateOfBirth: String, gender: String, emailID: String){
        self._riderID = riderID
        self._firstName = firstName
        self._lastName = lastName
        self._address1 = address1
        self._address2 = address2
        self._city = city
        self._state = state
        self._phoneNumber = phoneNumber
        self._dateOfBirth = dateOfBirth
        self._gender = gender
        self._emailID = emailID
    }
    
    init( riderID: String, dictionary: Dictionary<String, AnyObject> )
        {
        self._riderID = riderID
    
        if let firstName = dictionary["FirstName"] as? String{ self._firstName = firstName }
        if let lastName = dictionary["LastName"] as? String{ self._lastName = lastName }
        if let address1 = dictionary["AddressLine1"] as? String{ self._address1 = address1 }
        if let address2 = dictionary["AddressLine2"] as? String{ self._address2 = address2 }
        if let city = dictionary["City"] as? String{ self._city = city }
        if let state = dictionary["State"] as? String{ self._state = state }
        if let phoneNumber = dictionary["PhoneNumber"] as? String{ self._phoneNumber = phoneNumber }
        if let dateOfBirth = dictionary["DateOfBirth"] as? String{ self._dateOfBirth = dateOfBirth }
        if let gender = dictionary["Gender"] as? String{ self._gender = gender }
        if let emailID = dictionary["EmailID"] as? String{ self._emailID = emailID }
        
    }

}
