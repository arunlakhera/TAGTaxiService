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
    private var _modelName: String!
    private var _vehicleNumber: String!
    private var _vehicleType: String!
    private var _registrationNumber: String!
    private var _modelYear: String!
    private var _insuranceNumber: String!
    private var _insuranceExpDate: String!
    private var _pollutionCertNumber: String!
    private var _pollutionCertExpDate: String!
    private var _mileage: String!
    private var _lastServiceDate: String!
    private var _isActiveFlag: String!
   
    var vehicleID: String?{ return _vehicleID}
    var companyName: String?{ return _companyName}
    var modelName: String?{ return _modelName}
    var vehicleNumber: String?{ return _vehicleNumber}
    var vehicleType: String?{ return _vehicleType}
    var registrationNumber: String?{ return _registrationNumber}
    var modelYear: String?{ return _modelYear}
    var insuranceNumber: String?{ return _insuranceNumber}
    var insurnaceExpDate : String?{ return _insuranceExpDate}
    var pollutionCertNumber: String?{ return _pollutionCertNumber}
    var pollutionCertExpDate: String?{ return _pollutionCertExpDate}
    var mileage: String?{ return _mileage}
    var lastServiceDate: String?{ return _lastServiceDate}
    var isActiveFlag: String?{ return _isActiveFlag}
   
    
    init(vehicleID: String, companyName: String, modelName: String, vehicleNumber: String, vehicleType: String, registrationNumber: String, modelYear: String, insuranceNumber: String, insurnaceExpDate: String, pollutionCertNumber: String, pollutionCertExpDate: String, mileage: String, lastServiceDate: String, isActiveFlag: String) {
        
        self._vehicleID = vehicleID
        self._companyName = companyName
        self._modelName = modelName
        self._vehicleNumber = vehicleNumber
        self._vehicleType = vehicleType
        self._registrationNumber = registrationNumber
        self._modelYear = modelYear
        self._insuranceNumber = insuranceNumber
        self._insuranceExpDate = insurnaceExpDate
        self._pollutionCertNumber = pollutionCertNumber
        self._pollutionCertExpDate = pollutionCertExpDate
        self._mileage = mileage
        self._lastServiceDate = lastServiceDate
        self._isActiveFlag = isActiveFlag
        
    }
    
    init(vehicleID: String, dictionary: Dictionary<String, AnyObject>) {
        self._vehicleID = vehicleID
        
        if let companyName = dictionary["CompanyName"] as? String{ self._companyName = companyName }
        if let modelName = dictionary["ModelName"] as? String{ self._modelName = modelName }
        if let vehicleNumber = dictionary["VehicleNumber"] as? String{ self._vehicleNumber = vehicleNumber }
        if let vehicleType = dictionary["VehicleType"] as? String{ self._vehicleType = vehicleType }
        if let registrationNumber = dictionary["RegistrationNumber"] as? String{ self._registrationNumber = registrationNumber }
        if let modelYear = dictionary["ModelYear"] as? String{ self._modelYear = modelYear }
        if let insuranceNumber = dictionary["InsuranceNumber"] as? String{ self._insuranceNumber = insuranceNumber }
        if let insurnaceExpDate = dictionary["InsuranceExpiryDate"] as? String{ self._insuranceExpDate = insurnaceExpDate }
        if let pollutionCertNumber = dictionary["PollutionCertificateNumber"] as? String{ self._pollutionCertNumber = pollutionCertNumber }
        if let pollutionCertExpDate = dictionary["PollutionCertificateExpiryDate"] as? String{ self._pollutionCertExpDate = pollutionCertExpDate}
        if let mileage = dictionary["Mileage"] as? String{ self._mileage = mileage }
        if let lastServiceDate = dictionary["LastServiceDate"] as? String{ self._lastServiceDate = lastServiceDate }
        if let isActiveFlag = dictionary["Active"] as? String{ self._isActiveFlag = isActiveFlag }
        
    }
    
    
}
