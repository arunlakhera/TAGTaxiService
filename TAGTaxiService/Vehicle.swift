//
//  Vehicle.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/4/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation

class Vehicle{
    
    private var _vehicleID: String!
    private var _companyName: String!
    private var _model: String!
    private var _type: String!
    private var _plateNumber: String!
    private var _registrationID: String!
    private var _insuranceNumber: String!
    private var _insuranceExpDate: String!
    private var _pollutionCertExpDate: String!
    private var _permitExpDate: String!
    private var _nextServiceDueDate: String!
    private var _inServiceFlag: String!
    private var _inactiveDate: String!
    
    var vehicleID: String?{ return _vehicleID}
    var companyName: String?{ return _companyName}
    var model: String?{ return _model}
    var type: String?{ return _type}
    var plateNumber: String?{ return _plateNumber}
    var registrationID: String?{ return _registrationID}
    var insuranceNumber: String?{ return _insuranceNumber}
    var insurnaceExpDate : String?{ return _insuranceExpDate}
    var pollutionCertExpDate: String?{ return _pollutionCertExpDate}
    var permitExpDate: String?{ return _permitExpDate}
    var nextServiceDueDate: String?{ return _nextServiceDueDate}
    var inServiceFlag: String?{ return _inServiceFlag}
    var inactiveDate: String?{ return _inactiveDate}
    
    init(vehicleID: String, companyName: String, model: String, type: String, plateNumber: String, registrationID: String, insuranceNumber: String, insurnaceExpDate: String, pollutionCertExpDate: String, permitExpDate: String, nextServiceDueDate: String, inServiceFlag: String, inactiveDate: String) {
        
        self._vehicleID = vehicleID
        self._companyName = companyName
        self._model = model
        self._type = type
        self._plateNumber = plateNumber
        self._registrationID = registrationID
        self._insuranceNumber = insuranceNumber
        self._insuranceExpDate = insurnaceExpDate
        self._pollutionCertExpDate = pollutionCertExpDate
        self._permitExpDate = permitExpDate
        self._nextServiceDueDate = nextServiceDueDate
        self._inServiceFlag = inServiceFlag
        self._inactiveDate = inactiveDate
        
    }
    
    init(vehicleID: String, dictionary: Dictionary<String, AnyObject>) {
        self._vehicleID = vehicleID
        
        if let companyName = dictionary["companyname"] as? String{ self._companyName = companyName }
        if let model = dictionary["model"] as? String{ self._model = model }
        if let type = dictionary["type"] as? String{ self._type = type }
        if let plateNumber = dictionary["platenumber"] as? String{ self._plateNumber = plateNumber }
        if let registrationID = dictionary["registrationID"] as? String{ self._registrationID = registrationID }
        if let insuranceNumber = dictionary["insurancenumber"] as? String{ self._insuranceNumber = insuranceNumber }
        if let insurnaceExpDate = dictionary["insurnaceexpdate"] as? String{ self._insuranceExpDate = insurnaceExpDate }
        if let pollutionCertExpDate = dictionary["pollutionCertExpDate"] as? String{ self._pollutionCertExpDate = pollutionCertExpDate}
        if let permitExpDate = dictionary["permitexpdate"] as? String{ self._permitExpDate = permitExpDate }
        if let nextServiceDueDate = dictionary["nextserviceduedate"] as? String{ self._nextServiceDueDate = nextServiceDueDate }
        if let inServiceFlag = dictionary["inserviceflag"] as? String{ self._inServiceFlag = inServiceFlag }
        if let inactiveDate = dictionary["inactivedate"] as? String{ self._inactiveDate = inactiveDate }
        
    }
    
    
}
