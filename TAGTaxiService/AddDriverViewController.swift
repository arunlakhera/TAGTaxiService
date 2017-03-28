//
//  AddDriverViewController.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/28/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase

class AddDriverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: OUTLETS
    
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var DLNumberTextField: UITextField!
    @IBOutlet weak var DLValidFromTextField: UITextField!
    @IBOutlet weak var DLValidTillTextField: UITextField!
    @IBOutlet weak var policeVerifiedTextField: UITextField!
    @IBOutlet weak var bloodGroupTextField: UITextField!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    // MARK: VARIABLES

    // Variable for Date of Birth picker
    let dateOfBirthPicker = UIDatePicker()

    // Variable to set States Picker
    var states = ["Andra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    let statesPicker = UIPickerView()
    
    var policeVerfied = ["Yes","No"]
    let policeVerifiedPicker = UIPickerView()
    
    var bloodGroup = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodGroupPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateOfBirthPicker.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextField.inputView = dateOfBirthPicker
        dateOfBirthPicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)

        statesPicker.delegate = self
        statesPicker.dataSource = self

        policeVerifiedPicker.delegate = self
        policeVerifiedPicker.dataSource = self

        bloodGroupPicker.delegate = self
        bloodGroupPicker.dataSource = self

        stateTextField.inputView = statesPicker
        policeVerifiedTextField.inputView = policeVerifiedPicker
        bloodGroupTextField.inputView = bloodGroupPicker
        
        let toolBarWithDoneButton =  addDoneButton()
        
        firstNameTextField.inputAccessoryView = toolBarWithDoneButton
        lastNameTextField.inputAccessoryView = toolBarWithDoneButton
        phoneNumberTextField.inputAccessoryView = toolBarWithDoneButton
        address1TextField.inputAccessoryView = toolBarWithDoneButton
        address2TextField.inputAccessoryView = toolBarWithDoneButton
        cityTextField.inputAccessoryView = toolBarWithDoneButton
        DLNumberTextField.inputAccessoryView = toolBarWithDoneButton
        
    }

    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "dd-MM-YYYY"
        if ((sender.date).compare(NSDate() as Date).rawValue >= 0 ){
            
            showAlert(title: "Error!", message: "Date of Birth Needs to be corrected")
            
            }else{
            dateOfBirthTextField.text = dateformatter.string(from: sender.date)
            self.view.endEditing(true)
            
        }
    }
    
    func addDoneButton() -> UIToolbar{
        
        // MARK: Create toolbar with button
        let toolBar = UIToolbar()   // Create toolbar View
        toolBar.sizeToFit()             // calls sizeThatFits: with current view bounds and changes bounds size of toolbar.
        
        // Adds space on toolbar so that Done Button appears on right side of the toolbar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        // Adds Done button to the toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        // Adds Space and Done button to the Toolbar
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        return toolBar
        
    }
    
    // Function to Dismiss keyboards once Done button is clicked
    func doneClicked(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        
        if pickerView == statesPicker{
            rows = states.count
        }else if pickerView == policeVerifiedPicker{
            rows = policeVerfied.count
        }else if pickerView == bloodGroupPicker{
            rows = bloodGroup.count
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = "--"
        if pickerView == statesPicker{
            rowTitle = states[row]
        }else if pickerView == policeVerifiedPicker{
            rowTitle = policeVerfied[row]
        }else if pickerView == bloodGroupPicker{
            rowTitle = bloodGroup[row]
        }
        
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == statesPicker{
            stateTextField.text  = states[row]
        }else if pickerView == policeVerifiedPicker{
            policeVerifiedTextField.text  = policeVerfied[row]
        }else if pickerView == bloodGroupPicker{
            bloodGroupTextField.text  = bloodGroup[row]
        }
        
        self.view.endEditing(true)
    }

    
    // MARK: ACTIONS
    
    @IBAction func uploadButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func activeSwitchClicked(_ sender: Any) {
        if activeSwitch.isOn{
            activeLabel.text = "Yes"
        }else{
            activeLabel.text = "No"
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    

}
