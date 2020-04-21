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

class LandingController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var hapticPicker: UIPickerView!
    
    var simData: [String] = [String]()
    var hapticData: [String] = [String]()
    
    override func viewDidLoad() {
        
        print( "Heyo@" );
        super.viewDidLoad();
        
        // connect data for picker delegate
        self.picker.delegate = self;
        self.picker.dataSource = self;
        self.picker.tag = 0; // so I can get this UI component in class functions
        
        self.hapticPicker.delegate = self;
        self.hapticPicker.dataSource = self;
        self.hapticPicker.tag = 1; // so I can get this UI component in class functions
        
        simData = [ "Balloons and Static Electricity", "John Travolage" ];
        hapticData = [ "Interaction Changes", "Manipulation", "Objects", "Result" ];
        
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
            return hapticData[ row ];
        }
        else {
            return "ERROR";
        }
    }
}
