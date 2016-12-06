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
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    //Container view
    // add all subviews to this view
    @IBOutlet weak var containerView: UIView!
    
    // Facebook login button
    var fbLoginButton = FBSDKLoginButton()
    var rootRef : AnyObject!
    var x: CGFloat = 0, y: CGFloat = 0
//    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!

    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Get reference firebase root
        rootRef =  FIRDatabase.database().reference()
        
        // Add facebook login button
        let titleText = NSAttributedString(string: "    Log in")
        fbLoginButton.setAttributedTitle(titleText, for: UIControlState.normal)
        x = (self.view.frame.width / 2) - 55
        y = googleSigninButton.frame.minY - 60
        fbLoginButton.frame = CGRect(x: x, y: y, width: 110, height: 40)
        self.fbLoginButton.readPermissions = ["public_profile", "email"]
        
        self.fbLoginButton.delegate = self
        containerView.addSubview(fbLoginButton)
        
        
        //Custom facebook button
        // Add a custom login button to your app
//        fbLoginButton.backgroundColor = UIColor.darkGray
//        fbLoginButton.frame = CGRect(0, 0, 180, 40);
//        fbLoginButton.center = view.center;
//        fbLoginTitle.setTitle("My Login Button")
        
        // Handle clicks on the button
//        fbLoginButton.addTarget(self, action: @selector(self.loginButtonClicked) forControlEvents: .TouchUpInside)
        
        
        // if user signed in using email and password
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
        
        // if user already signed in using fb
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            // use 'accessToken' here.
            print("\n\n-----\nUser already logged in using fb\n-----\n\n");
        }
        
        // set GIDSingnIn object
        GIDSignIn.sharedInstance().uiDelegate = self
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
    }
    
    /*
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.fbLoginButton.removeFromSuperview()
        x = (self.view.frame.width / 2) - (fbLoginButton.frame.size.width / 2)
        print("-----\n\(x)\n-----")
        fbLoginButton.frame = CGRect(x: x, y: y, width: fbLoginButton.frame.size.width, height: fbLoginButton.frame.size.height)
        self.view.addSubview(fbLoginButton)
        print("-----\nOrientation Changed\n-----")
    }
    */
    
    /*
     override func viewWillAppear(_ animated: Bool) {
        self.loginButton.removeFromSuperview()
        x = (self.view.frame.width / 2) - (loginButton.frame.size.width / 2)
        print("-----\n\(x)\n-----")
        loginButton.frame = CGRect(x: x, y: y, width: loginButton.frame.size.width, height: loginButton.frame.size.height)
        self.view.addSubview(loginButton)
        print("-----\nOrientation Changed\n-----")
    }
    */
    
    // ----- Login Function -----
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        // Sign In with credentials.
        guard let email = userEmail.text, let password = userPassword.text else { return }
        print("\n\n-----\n1. ", email, " ", password, "\n-----\n\n")
        FIRAuth.auth()!.signIn(withEmail: email, password: password) { (user, error) in
            print("\n\n-----\n2. ", email, " ", password, "\n-----\n\n")
            if let error = error {
                print(error.localizedDescription)
                return
            }
            else {
                self.performSegue(withIdentifier: "loginSuccessful", sender: self)
            }
            self.signedIn(user!)
        }
    }
    
    
    // ----- Create Account -----
    @IBAction func createAccount() {
        
        performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
        
    }
    
    
    // Facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else {
            print("\n\n-----\nFB login success\n------\n\n ")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                print("\n\n-----\nFB Firebase auth success\n------\n\n ")
                AppState.sharedInstance.signedIn = true;
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
            }
 
        }
    }
    
    // Facebook logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("\n\n-----\nFB User Logged Out\n------\n\n ")
    }
    
    
    // Google sign out
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }

    
    /* Sign-up
     @IBAction func didTapSignUp(_ sender: AnyObject) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        }
    }*/
    
    /* Sign-out
     @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }*/
    
    
    /*
        @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }*/
    
    
    func signedIn(_ user: FIRUser?) {
        
        MeasurementHelper.sendLoginEvent()
        AppState.sharedInstance.signedIn = true
    }
    
    /*@IBAction func login() {
        
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
        
    }*/

    func displayAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func retrieveData() {
        
        rootRef.child("users").observe(.value, with: { snapshot in
            print(snapshot.value!)
        })
    }
}
