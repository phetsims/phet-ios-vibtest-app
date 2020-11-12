//
//  Constants.swift
//  phet-ios-vibtest-app
//
//  Created by Jesse Greenberg on 11/11/20.
//  Copyright © 2020 phet. All rights reserved.
//

import Foundation

struct Constants {
    static let paradigmSelection = [
        ParadigmSelection( paradigmName: "Int 0.6, inc sharpness", paradigmNumber: "1" ),
        ParadigmSelection( paradigmName: "Int 0.6, dec sharpness", paradigmNumber: "2" ),
        ParadigmSelection( paradigmName: "Int 0.3, inc sharpness", paradigmNumber: "3" ),
        ParadigmSelection( paradigmName: "Inc int, inc sharpness", paradigmNumber: "4" ),
        ParadigmSelection( paradigmName: "Inc int, dec sharpness", paradigmNumber: "5" ),
        ParadigmSelection( paradigmName: "Mass controls indicate force", paradigmNumber: "6" ),
        ParadigmSelection( paradigmName: "Exponential int, linear sharpness", paradigmNumber: "7" )
    ];
}

struct ParadigmSelection {
    var paradigmName = " ";
    var paradigmNumber = "0";
}
