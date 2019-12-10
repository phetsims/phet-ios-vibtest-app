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
    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Testing WebView
//        super.viewDidLoad()
        
        // this URL can be your local testing url like
        // http://10.0.0.253:8080
//        let myURL = URL(string:"https://phet-dev.colorado.edu/html/energy-skate-park/1.0.0-dev.5/phet/energy-skate-park_en_phet.html")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load( myRequest )

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
        
        // This old version of haptics works on iPhone7 plus.
        // iPhone7 plus may not support Corehaptics
        // kSystemSoundID_Vibrate is just a UInt32 with a value of 4095
        let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(vibrate)
    }
}

