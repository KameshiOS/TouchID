//
//  AuthenticationViewController.swift
//  TouchID
//
//  Created by Lalithbabu Logeshwarrao on 29/06/2017.
//  Copyright © 2017 Payzak Financial Service. All rights reserved.
//

import UIKit
import LocalAuthentication
import QuartzCore
import AVFoundation

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TouchIDButtonAction(_ sender: Any) {
        let authenticationContext = LAContext()
        var error: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Touch ID, Navigate to Success VC, Handling errors
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Only Humans allowed, Sorry no dogs", reply: { (success, error1) in
                if success {
                    // Navigate to Success VC
                    self.performSegue(withIdentifier: "successVC", sender: nil)
                } else {
                    if let Error = error1 as? NSError {
                        // Display Error Alert
                        let msg = self.errorMessageForLAErrorCode(errorCode: Error.code)
                        self.alert(alertMsg: msg)
                    }
                }
            })
        } else {
            let alert = UIAlertController.init(title: "Alert!", message: "This device donot have touch id", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Register", style: .default, handler: { (UIAlertAction) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /* DispatchQueue.main.async {
    if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
 */
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        
        case LAError.authenticationFailed.rawValue:
            message = "The User failed to provide valid credentials"
        
        case LAError.invalidContext.rawValue:
            message = "The Context is Invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts"
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "Touch ID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "User did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user choose to use fallback"
        
        case LAError.touchIDNotEnrolled.rawValue:
            message = "Touch Id Not enrolled"
            
        default:
            message = "Did not find error code on LAError Object"
        }
        return message
    }
    func alert(alertMsg: String) {
        let alert = UIAlertController.init(title: "Alert!", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
