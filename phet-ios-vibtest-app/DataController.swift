//
//  ViewController.swift
//  ios-data-test
//
//  Created by Jen Tennison on 5/21/20.
//  Copyright © 2020 Jen Tennison. All rights reserved.
//

import UIKit
import MessageUI

class DataController: UIViewController, MFMailComposeViewControllerDelegate {

    var saveDataDict: [Dictionary<String, String>] = [] ;
    var p_id: Int = 0;
    let emailAddress = "Jen.Tennison@SLU.edu";
    let landingController = LandingController();

    override func viewDidLoad() {
        super.viewDidLoad();
        
        p_id = landingController.getID();
        initializeDataDict();

//        // Load background image
//        let background = UIImage(named: "Image");
//        var imageView : UIImageView!;
//
//        // imageView options
//        imageView = UIImageView(frame: view.bounds);
//        imageView.contentMode = UIView.ContentMode.scaleAspectFill;
//        imageView.clipsToBounds = true;
//        imageView.image = background;
//        imageView.center = view.center;
//
//        // Set background to view
//        view.addSubview(imageView);
//        self.view.sendSubviewToBack(imageView);
    }

    @IBAction func save_btn(_ sender: Any) {
        saveCSV(paradigm: 1, sim: "JT");
    }

    // *************************************************************************************//
    // We need:
    // - Finger positions on touch down and moving events
    // - Durations when interacting with important parts of the sim (e.g. moving JT's arm)
    // *************************************************************************************//
    // CSV Format:
    // P# | X | Y | Event (if applicable) | Time Start of Event | Time End of Event
    // *************************************************************************************//

    // *************************************************************************************//
    // Save Data Methods                                                                    //
    // *************************************************************************************//

    // Initialize Header of CSV at top of data array
    func initializeDataDict() {
        let header = [ "pid": "P#",
                       "xval": "X",
                       "yval": "Y",
                       "event": "Event",
                       "time": "Time" ];

        saveDataDict.append(header);
    }

    func storeDatainDict( xyval: CGPoint, event: String, time: Float) {
        let dataPoint = [ "pid": String(p_id),
                          "xval": String(xyval.x.description),
                          "yval": String(xyval.y.description),
                          "event": event,
                          "time": String(time) ]

        saveDataDict.append(dataPoint);
    }

    func configuredMailComposeViewController(saveData: NSData, filename: String) -> MFMailComposeViewController {
        let emailController = MFMailComposeViewController();
        emailController.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate;
        emailController.setSubject(filename + "CSV File");
        emailController.setToRecipients([emailAddress]);
        emailController.setMessageBody("Data from PhET Interviews", isHTML: false);

        // Attaching the .CSV file to the email.
        emailController.addAttachmentData(saveData as Data, mimeType: "text/csv", fileName: filename + ".csv");

        return emailController;
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func saveCSV( paradigm: Int, sim: String) {

        let filename = "p" + String(p_id) + "_paradigm" + String(paradigm) + "_" + sim;
        var stringRow = "";

        // check if file exists, do not overwrite, only append

        for row in saveDataDict{
            stringRow = stringRow.appending("\(String(describing: row["pid"]!)), \(String(describing: row["xval"]!)), \(String(describing: row["yval"]!)), \(String(describing: row["event"]!)), \(String(describing: row["time"]!)) \n");
        }

        // Converting it to NSData.
        let saveData = stringRow.data(using: String.Encoding.utf8, allowLossyConversion: false);

        let emailViewController = configuredMailComposeViewController(saveData: saveData! as NSData, filename: filename);
            if MFMailComposeViewController.canSendMail() {
                self.present(emailViewController, animated: true, completion: nil);
            }
    }


    // *************************************************************************************//
    // Touch Methods                                                                        //
    // *************************************************************************************//

    // Override functions for UIResponder classes
    // Used to record finger positions.
    // Only need Began and Moved, others not relevant.

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first {
            let position = touch.location(in: view);
            print("touch began: {", position.x, ",", position.y, "}");

            // Save this point
            storeDatainDict( xyval: position, event: "stuff", time: 0.00);
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first {
            let position = touch.location(in: view);
            print("touch moved: {", position.x, ",", position.y, "}");

            // Save this point
            storeDatainDict( xyval: position, event: "stuff", time: 0.00);
        }
    }

}
