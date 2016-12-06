//
//  TempLogoutViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/21/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class TempLogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signout() {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        
        print("\n\n-----\nLogout Clicked\n-----\n\n")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController

    }
    
}
