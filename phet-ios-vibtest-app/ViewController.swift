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
    private var VibrationMan: VibrationManager?

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
        let webView = WKWebView( frame: .zero, configuration: configuration )

        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        //Jesse's info
        //if let url = URL(string: "http://127.0.0.1:8080/phet-ios-vibtest-app/vibtest-embedded.html") {

        //Jen's info
//        if let url = URL(string: "http://10.178.13.127:8080//phet-ios-vibtest-app/vibtest-embedded.html?test") {
        if let url = URL(string: "http://10.0.0.253:8080/john-travoltage/john-travoltage_en.html?brand=phet&ea&vibration=objects&zoom=true") {
            webView.load(URLRequest(url: url))
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

            VibrationMan?.vibrateAtFrequencyForever(frequency: 25)
        }
    }


    @IBAction func btn(_ sender: Any) {
        print("HEYO");

        if ( supportsHaptics ) {
            //engine.start(completionHandler:nil)
            VibrationMan?.vibrateAtFrequencyForever(frequency: 25)
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
    
            print("vibrateAtFrequency(duration, frequency): \(duration), \(frequency)")
            VibrationMan?.vibrateAtFrequency(seconds: duration, frequency: frequency)
        }
    
    if message.name == vibrateFrequencyForeverMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let frequency = dict["frequency"] as? Double else {
                return
        }

        print("vibrateAtFrequencyForever(frequency): \(frequency)")
        VibrationMan?.vibrateAtFrequencyForever(frequency: frequency)
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
    
  }
}
