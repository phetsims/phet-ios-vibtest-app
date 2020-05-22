//
//  ViewController.swift
//  phet-ios-vibtest-app
//
//  Created by Jesse Greenberg on 12/6/19.
//  Copyright © 2019 phet. All rights reserved.
//

import UIKit
import CoreHaptics
import WebKit
import AudioToolbox.AudioServices

class ViewController: UIViewController, WKUIDelegate {

    var engine: CHHapticEngine!
    var player: CHHapticPatternPlayer!
    var supportsHaptics: Bool = false
    var webView: WKWebView!
    let vibrateMessageHandler = "vibrateMessageHandler"
    let vibrateForeverMessageHandler = "vibrateForeverMessageHandler"
    let vibrateFrequencyMessageHandler = "vibrateFrequencyMessageHandler"
    let vibrateFrequencyForeverMessageHandler = "vibrateFrequencyForeverMessageHandler"
    let stopMessageHandler = "stopMessageHandler"
    let vibrateWithCustomPatternMessageHandler = "vibrateWithCustomPatternMessageHandler"
    let vibrateWithCustomPatternForeverMessageHandler = "vibrateWithCustomPatternForeverMessageHandler"
    let vibrateWithCustomPatternDurationMessageHandler = "vibrateWithCustomPatternDurationMessageHandler"
    let vibrationIntensityMessageHandler = "vibrationIntensityMessageHandler"
    let debugMessageHandler = "debugMessageHandler"
    private var VibrationMan: VibrationManager?
    
    // selections for sim and haptic output, set by user selection from previous scene
    public var simSelection: String!;
    public var hapticSelection: String!;
    
    // maps selected value from teh UIPickerView to the sim name for the url
    // TODO: This will eventually map directly to a url presumably
    let simSelectionMap = [
        "Balloons and Static Electricity": "balloons-and-static-electricity",
        "John Travoltage": "john-travoltage"
    ];
    
    // maps the selected value from the UIPickerView to the query parameter for the url to select
    // haptic feedback
    let hapticSelectionMap = [
        "Interaction Changes": "interaction-changes",
        "Objects": "objects",
        "Manipulation": "manipulation",
        "Results": "result"
    ];

    override func viewDidLoad() {

        // Testing WebView
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration();
        configuration.userContentController.add( self, name: vibrateMessageHandler )
        configuration.userContentController.add( self, name: vibrateForeverMessageHandler )
        configuration.userContentController.add( self, name: vibrateFrequencyMessageHandler )
        configuration.userContentController.add( self, name: vibrateFrequencyForeverMessageHandler )
        configuration.userContentController.add( self, name: vibrateWithCustomPatternMessageHandler )
        configuration.userContentController.add( self, name: vibrateWithCustomPatternForeverMessageHandler )
        configuration.userContentController.add( self, name: vibrateWithCustomPatternDurationMessageHandler )
        configuration.userContentController.add( self, name: stopMessageHandler )
        configuration.userContentController.add( self, name: debugMessageHandler );
        configuration.userContentController.add( self, name: vibrationIntensityMessageHandler );
        let webView = WKWebView( frame: .zero, configuration: configuration )

        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        // assemble the URL for the simulation from user selections
        let localAddress = "10.0.0.198:8080";
        let simRepoName = self.simSelectionMap[ self.simSelection ] ?? "";
        var queryParameters = "vibration=\(self.hapticSelectionMap[ self.hapticSelection ]!)&brand=phet&ea";
        
        // special additional query parameter for BASE, hide the button that adds another balloon for simplicity
        if ( simRepoName == "balloons-and-static-electricity" ) {
            queryParameters = "\(queryParameters)&hideBalloonSwitch";
        }
        
        let urlString = "http://\(localAddress)/\(simRepoName)/\(simRepoName)_en.html?\(queryParameters)";

        if let url = URL( string: urlString ) {
            webView.load(URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData ) )
        }

        // Testing Haptics

        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics

        // Core haptics
        if supportsHaptics {
            VibrationMan = VibrationManager()
        }
    }

    // Vibrate iPhone8+
    // PHONE MUST BE OFF MUTE TO WORK
    func vibratePhone(para: String){
        if (para == "stuff") {

            VibrationMan?.vibrateAtFrequencyForever(frequency: 25, intensity: 1.0)
        }
    }


    @IBAction func btn(_ sender: Any) {
        print("HEYO");

        if ( supportsHaptics ) {
            //engine.start(completionHandler:nil)
            VibrationMan?.vibrateAtFrequencyForever(frequency: 25, intensity: 1.0)
        }
    }
}

// Communicate with javascript through Webkit
// Obtains a message sent from javascript and records it
extension ViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == vibrateMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let duration = dict["duration"] as? Double else {
                return
        }
        print("vibrate(duration): \(duration)")
        
        VibrationMan?.vibrate(seconds: duration)
        
    }
    
    if message.name == vibrateForeverMessageHandler {
        VibrationMan?.vibrateForever()
        print("vibrateForever(): OK")
        }
    
    if message.name == vibrateFrequencyMessageHandler {
            guard let dict = message.body as? [String: AnyObject],
                let frequency = dict["frequency"] as? Double,
                let duration = dict["duration"] as? Double else {
                    return
            }
    
            print("vibrateAtFrequency(on, frequency): \(duration), \(frequency)")
        VibrationMan?.vibrateAtFrequency(seconds: duration, frequency: frequency, intensity: 1.0)
        }
    
    if message.name == vibrateFrequencyForeverMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let intensity = dict["intensity"] as? Double,
            let frequency = dict["frequency"] as? Double else {
                return
        }

        print("vibrateAtFrequencyForever(frequency, intensity): \(frequency)" + ", \(intensity)");
        VibrationMan?.vibrateAtFrequencyForever(frequency: frequency, intensity: intensity)
    }

    if message.name == stopMessageHandler {
        print("stop(): OK")
        VibrationMan?.stop()
    }
    
    if message.name == vibrateWithCustomPatternMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let vibrationPattern = dict["vibrationPattern"] as? [Double],
            let duration = dict["duration"] as? Double,
            let loopForever = dict["loopForever"] as? Bool else {
                return
            }
        
        print("vibrateWithCustomPattern(vibrationPattern, duration, loopForever)")
        VibrationMan?.vibrateWithCustomPattern(vibrationPattern: vibrationPattern, seconds: duration, loopForever: loopForever);
    }
    
    if message.name == vibrateWithCustomPatternDurationMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let vibrationPattern = dict["vibrationPattern"] as? [Double],
            let duration = dict["duration"] as? Double else {
                return
            }
        
        print("vibrateWithCustomPattern(vibrationPattern, duration)")
        VibrationMan?.vibrateWithCustomPattern(vibrationPattern: vibrationPattern, seconds: duration );
    }
    
    if message.name == vibrateWithCustomPatternForeverMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let vibrationPattern = dict["vibrationPattern"] as? [Double] else {
                return
            }
        
        print("vibrateWithCustomPatternForever(vibrationPattern)")
        VibrationMan?.vibrateWithCustomPatternForever( vibrationPattern: vibrationPattern );
    }
    
    if message.name == vibrationIntensityMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let intensity = dict["intensity"] as? Double else {
                return
        }
        
        VibrationMan?.setVibrationIntensity(intensity: intensity);
        
    }
    
    if message.name == debugMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let debugString = dict["debugString"] as? String else {
                return
            }

        print( "debug string: ", debugString );
    }
  }
}
