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
import MessageUI

class ViewController: UIViewController, WKUIDelegate, MFMailComposeViewControllerDelegate {

    var engine: CHHapticEngine!
    var player: CHHapticPatternPlayer!
    var supportsHaptics: Bool = false
    var webView: WKWebView!
    
    // messages added to the web view, received from the simulation
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
    let saveDataMessageHandler = "saveDataMessageHandler";
    private var VibrationMan: VibrationManager?
    
    // data from interviews is sent to this address
    //private let emailAddress = "Jen.Tennison@SLU.edu";
    private let emailAddress = "jesse.greenberg@colorado.edu";
    
    // selections for sim and haptic output, set by user selection from previous scene
    public var simSelection: String!;
    public var hapticSelection: String!;
    public var participantId: String!;
    
    
    // maps selected value from teh UIPickerView to the sim name for the url
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
    
    // maps the selected sim to the deployed version to test
    let deployedSimVersionMap = [
        "Balloons and Static Electricity": "1.5.0-dev.17",
        "John Travoltage": "1.6.0-dev.19"
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
        configuration.userContentController.add( self, name: saveDataMessageHandler );
        configuration.userContentController.add( self, name: vibrationIntensityMessageHandler );
        let webView = WKWebView( frame: .zero, configuration: configuration )

        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        // a URL for the sim from user choices pulling from local server, used
        // for development - see function to change localhost address
        let urlString = self.getLocalSimURL();
        
        // a URL for the sim from user selection that will go to a deployed
        // version, for testing
        //let urlString = self.getDeployedSimURL();
        print( urlString );

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
    
    // Get a url to a local sim for testing
    func getLocalSimURL() -> String {
        // assemble the URL for the simulation from user selections
        let localAddress = "10.0.0.198:8080";
        let simRepoName = self.simSelectionMap[ self.simSelection ] ?? "";
        let queryParameters = self.getQueryParameters();
        
        return "http://\(localAddress)/\(simRepoName)/\(simRepoName)_en.html?\(queryParameters)";
    }
    
    // Get a URL to a depoyed sim
    // @param - version of the build (something like 1.6.0-dev.18)
    func getDeployedSimURL() -> String {
        
        // assemble the URL for the simulation from user selections
        let spotAddress = "phet-dev.colorado.edu/html";
        let simRepoName = self.simSelectionMap[ self.simSelection ] ?? "";
        let simVersion = self.deployedSimVersionMap[ self.simSelection ] ?? "";
        let queryParameters = self.getQueryParameters();
        
        return "https://\(spotAddress)/\(simRepoName)/\(simVersion)/phet/\(simRepoName)_en_phet.html?\(queryParameters)";
    }
    
    func saveCSV( dataString: String ) {
        let filename = "p\(String( self.participantId))_\(String( self.hapticSelection))_\(String(self.simSelection))";
        
        var csvString = "";
        
        // header for data
        csvString = csvString.appending( "X,Y,Time (seconds),Event\n");
        
        // the data string componenens are separated by ';'
        let events = dataString.components( separatedBy: ";");
        
        for event in events {
            
            // event data is already comma separated, just add
            // a new line
            csvString = csvString.appending( "\(event)\n" );
        }
        
        // converting it to NSData
        let saveData = csvString.data(using: String.Encoding.utf8, allowLossyConversion: false);
        
        let emailViewController = configuredMailComposeViewController(saveData: saveData! as NSData, filename: filename);
            if MFMailComposeViewController.canSendMail() {
                self.present(emailViewController, animated: true, completion: nil);
            }
        
    }
    
    // creates the email view controller, and sets up the email
    // with address and content
    func configuredMailComposeViewController(saveData: NSData, filename: String) -> MFMailComposeViewController {
        let emailController = MFMailComposeViewController();
        emailController.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate;
        emailController.setSubject(filename + "CSV File");
        emailController.setToRecipients([self.emailAddress]);
        emailController.setMessageBody("Data from PhET Interviews", isHTML: false);

        // Attaching the .CSV file to the email.
        emailController.addAttachmentData(saveData as Data, mimeType: "text/csv", fileName: filename + ".csv");

        return emailController;
    }
    
    // tells the delegate that the user wants to dismiss the composition
    // view
    // overrides
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getQueryParameters() -> String {
        var queryParameters = "vibration=\(self.hapticSelectionMap[ self.hapticSelection ]!)&brand=phet&ea";
        
        // special additional query parameter for BASE, hide the button that adds another balloon for simplicity
        if ( self.simSelection == "Balloons and Static Electricity" ) {
            queryParameters = "\(queryParameters)&hideBalloonSwitch";
        }
        
        return queryParameters;
    }

    // Vibrate iPhone8+
    // PHONE MUST BE OFF MUTE TO WORK
    func vibratePhone(para: String){
        if (para == "stuff") {

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
    
    if message.name == saveDataMessageHandler {
        guard let dict = message.body as? [String: AnyObject],
            let dataString = dict["dataString"] as? String else {
                return
            }
        
        // do something with the data string
        self.saveCSV(dataString: dataString);
    }
  }
}
