//
//  RiderBooking.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation

class RideBooking{
    
    private var _bookingID: String!
    private var _riderID: String!
    private var _vehicleID: String!
    private var _driverID: String!
    private var _dateOfBooking: String!
    private var _rideFrom: String!
    private var _rideTo: String!
    private var _rideBeginDate: String!
    private var _rideEndDate: String!
    private var _roundTripFlag: String!
    private var _noOfTravellers: String!
    private var _status: String!
    private var _amount: String!
    private var _vehicle: String!
    
    
    var bookingID: String?{ return _bookingID}
    var riderID: String?{ return _riderID}
    var vehicleID: String?{ return _vehicleID}
    var driverID: String?{ return _driverID}
    var dateOfBooking: String?{ return _dateOfBooking}
    var rideFrom: String?{ return _rideFrom}
    var rideTo: String?{ return _rideTo}
    var rideBeginDate: String?{ return _rideBeginDate}
    var rideEndDate: String?{ return _rideEndDate}
    var roundTripFlag: String?{ return _roundTripFlag}
    var noOfTravellers: String?{ return _noOfTravellers }
    var status: String?{ return _status }
    var amount: String?{ return _amount }
    var vehicle: String?{ return _vehicle }
    
    
    init(bookingID: String, riderID: String, vehicleID: String, driverID: String, dateOfBooking: String, rideFrom: String, rideTo: String, rideBeginDate: String, rideEndDate: String, roundTripFlag: String, noOfTravellers: String, status: String, amount: String, vehicle: String) {
        
        self._bookingID = bookingID
        self._riderID = riderID
        self._vehicleID = vehicleID
        self._driverID = driverID
        self._dateOfBooking = dateOfBooking
        self._rideFrom = rideFrom
        self._rideTo = rideTo
        self._rideBeginDate = rideBeginDate
        self._rideEndDate = rideEndDate
        self._roundTripFlag = roundTripFlag
        self._noOfTravellers = noOfTravellers
        self._status = status
        self._amount = amount
        self._vehicle = vehicle
    }
    
    init(bookingID: String, dictionary: Dictionary<String, AnyObject>) {
        self._vehicleID = vehicleID
        self._bookingID = bookingID
        //if let bookingID = dictionary["BookingID"] as? String{ self._bookingID = bookingID }
        if let riderID = dictionary["RiderID"] as? String{ self._riderID = riderID }
        if let vehicleID = dictionary["VehicleID"] as? String{ self._vehicleID = vehicleID }
        if let driverID = dictionary["DriverID"] as? String{ self._driverID = driverID }
        if let dateOfBooking = dictionary["DateOfBooking"] as? String{ self._dateOfBooking = dateOfBooking }
        if let rideFrom = dictionary["RideFrom"] as? String{ self._rideFrom = rideFrom }
        if let rideTo = dictionary["RideTo"] as? String{ self._rideTo = rideTo }
        if let rideBeginDate = dictionary["RideBeginDate"] as? String{ self._rideBeginDate = rideBeginDate }
        if let rideEndDate = dictionary["RideEndDate"] as? String{ self._rideEndDate = rideEndDate }
        if let roundTripFlag = dictionary["RoundTrip"] as? String{ self._roundTripFlag = roundTripFlag }
        if let noOfTravellers = dictionary["NoOfTravellers"] as? String{ self._noOfTravellers = noOfTravellers }
        if let status = dictionary["Status"] as? String{ self._status = status }
        if let amount = dictionary["Amount"] as? String{ self._amount = amount }
        if let vehicle = dictionary["Vehicle"] as? String{ self._vehicle = vehicle }
        
    }
    
}
