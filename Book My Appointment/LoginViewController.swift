//
//  LoginViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/13/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class LoginViewController: UIViewController {

    var rootRef : AnyObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        FIRApp.configure()
        rootRef =  FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------Login Function-----
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func login() {
        
        let email = userEmail.text;
        let password = userPassword.text;
        
        // Check for empty fislds
        if(email!.isEmpty || password!.isEmpty) {
            
            // Display alest message
            displayAlert(message: "Password and Email field Required")
            
            return
        }
        
        // Store data
        print(email!, " ", password!)
        let userRef = FIRDatabase.database().reference(withPath: "users")
        
        userRef.child("email").setValue(email)
        userRef.child("password").setValue(password)
        
        // Display alest message with configuration
        
    }
    
    func displayAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        
//        let okAction = UIAlertAction(title: "OK", style: <#T##UIAlertActionStyle#>., handler: nil)
//        
//        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func retrieveData() {
        
        rootRef.child("users").observe(.value, with: { snapshot in
            print(snapshot.value!)
        })
        
    }
    
}
