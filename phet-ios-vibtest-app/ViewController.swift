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
    let doStuffMessageHandler = "doStuffMessageHandler"
    private var VibrationMan: VibrationManager?

    override func viewDidLoad() {

        // Testing WebView
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration();
        configuration.userContentController.add( self, name: doStuffMessageHandler )
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
        if let url = URL(string: "http://127.0.0.1:8080/john-travoltage/john-travoltage_en.html?brand=phet&ea&sound=disabled") {
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
    if message.name == doStuffMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let param1 = dict["param1"] as? String,
            let param2 = dict["param2"] as? Int else {
                return
        }
        print( param1 );
        print( param2 );

        // Send the message to another func
        vibratePhone(para: param1);
    }



  }
}
