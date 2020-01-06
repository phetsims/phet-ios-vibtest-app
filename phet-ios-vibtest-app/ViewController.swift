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
        if let url = URL(string: "http://192.168.1.5:8080/phet-ios-vibtest-app/vibtest-embedded.html?test") {
            webView.load(URLRequest(url: url))
        }

        // Testing Haptics
        
        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        if ( supportsHaptics ) {
            // Create and configure a haptic engine.
            do {
                engine = try CHHapticEngine()
            } catch let error {
                fatalError("Engine Creation Error: \(error)")
            }
            
            // The reset handler provides an opportunity to restart the engine.
            engine.resetHandler = {
                
                print("Reset Handler: Restarting the engine.")
                
                do {
                    // Try restarting the engine.
                    try self.engine.start()
                            
                    // Register any custom resources you had registered, using registerAudioResource.
                    // Recreate all haptic pattern players you had created, using createPlayer.

                } catch {
                    fatalError("Failed to restart the engine: \(error)")
                }
            }
            
            // The stopped handler alerts engine stoppage.
            engine.stoppedHandler = { reason in
                print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
                switch reason {
                case .audioSessionInterrupt: print("Audio session interrupt")
                case .applicationSuspended: print("Application suspended")
                case .idleTimeout: print("Idle timeout")
                case .systemError: print("System error")
                @unknown default:
                    print("Unknown error")
                }
            }
            
            let hapticDict = [
                CHHapticPattern.Key.pattern: [
                    [CHHapticPattern.Key.event: [CHHapticPattern.Key.eventType: CHHapticEvent.EventType.hapticTransient,
                          CHHapticPattern.Key.time: 0.001,
                          CHHapticPattern.Key.eventDuration: 1.0] // End of first event
                    ] // End of first dictionary entry in the array
                ] // End of array
            ] // End of haptic dictionary
            
            do {
                let pattern = try CHHapticPattern(dictionary: hapticDict)
                player = try engine.makePlayer(with: pattern)
            } catch {
                fatalError("Failed to create patterns: \(error)")
            }
        }
    }
    
    // Vibrate iPhone7+
    // This old version of haptics works only on iPhone7+.
    // iPhone7+ does not support Corehaptics
    // kSystemSoundID_Vibrate is just a UInt32 with a value of 4095
    // PHONE MUST BE OFF MUTE TO WORK
    func vibratePhone(para: String){
        if (para == "stuff") {
            //print("Wants to vibrate");
            let vibrate = SystemSoundID(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(vibrate);
            
            //Check if vibrated
            AudioServicesPlaySystemSoundWithCompletion(vibrate, {
                print("did vibrate")});
        }
    }


    @IBAction func btn(_ sender: Any) {
        print("HEYO");
        
        if ( supportsHaptics ) {
            engine.start(completionHandler:nil)
            do {
                try player.start(atTime: 0)
            } catch {
                fatalError( "Failed to create patterns: \(error)" )
            }
            
            engine.stop(completionHandler: nil)
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


