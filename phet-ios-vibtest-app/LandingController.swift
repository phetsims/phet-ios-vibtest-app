//
//  LandingController.swift
//  phet-ios-vibtest-app
//
//  Created by Jesse Greenberg on 4/20/20.
//  Copyright © 2020 phet. All rights reserved.
//

import UIKit
import CoreHaptics
import WebKit
import AudioToolbox.AudioServices

class LandingController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var launchButton: UIButton!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var hapticPicker: UIPickerView!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var idTextField: UITextField!
    
    var simData: [String] = [String]()
    var hapticData: [String] = [String]()
    
    // description of the selected haptic feedback, in case it is useful - commented out
    // for now, we don't want to lead participants
    //var hapticDescriptionMap: [String: String] = [:];
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        // adds a "Done" button to the user ID textView keyboard, which is not dismissable by default (ugh)
        self.addDoneButtonToKeyboard();
        
        // launch button is disabled until id is entered
        self.launchButton.isEnabled = false;
        
//        // textView cannot be changed by user
//        self.textView.isEditable = false;
//
//        // inrease the size a bit
//        self.textView.font = UIFont(name: self.textView.font!.fontName, size: 25);
        
        // connect data for picker delegate
        self.picker.delegate = self;
        self.picker.dataSource = self;
        
        // to override certain functions to limit number of characters
        self.idTextField.delegate = self;
        
        self.picker.tag = 0; // so I can get this UI component in class functions
        
        self.hapticPicker.delegate = self;
        self.hapticPicker.dataSource = self;
        self.hapticPicker.tag = 1; // so I can get this UI component in class functions
        
        simData = [ "John Travoltage", "Balloons and Static Electricity" ];
        hapticData = [ "Objects", "Manipulation", "Interaction Changes", "Results" ];
//        hapticDescriptionMap = [
//            "Objects": "Each important object in the scene is assigned a distinct vibration.",
//            "Manipulation": "Each interactive object is assigned a distinct vibration.",
//            "Interaction Changes": "User interaction with movable objects creates vibrations.",
//            "Results":"Contextual changes resulting from user interactions produce vibrations."
//        ];
    }
    
    // Number of columns of data, true for both pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // Number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ( pickerView.tag == 0 ) {
            return simData.count;
        }
        else if ( pickerView.tag == 1 ) {
            return hapticData.count;
        }
        else {
            return 0;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( pickerView.tag == 0 ) {
            return simData[ row ];
        }
        else if ( pickerView.tag == 1 ) {
            //textView.text = hapticDescriptionMap[ hapticData[ row ] ];
            
            return hapticData[ row ];
        }
        else {
            return "ERROR";
        }
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if let nextViewController = segue.destination as? ViewController {
            nextViewController.simSelection = simData[ picker.selectedRow( inComponent: 0 ) ];
            nextViewController.hapticSelection = hapticData[ hapticPicker.selectedRow( inComponent: 0 ) ]
        }
    }
    
    func addDoneButtonToKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init( x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50 ) );
        doneToolbar.barStyle = .default;
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done];
        doneToolbar.items = items;
        doneToolbar.sizeToFit();

        self.idTextField.inputAccessoryView = doneToolbar;
    }
    
    @objc func doneButtonAction() {
        self.idTextField.resignFirstResponder();
    }
    
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
       replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
    
        // can't launch the simulation unless we have a user ID
        self.launchButton.isEnabled = numberOfChars > 0;
    
        return numberOfChars <= 5 // 5 Limit Value
    }
}
