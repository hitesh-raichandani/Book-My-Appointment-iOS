//
//  SignupViewController.swift
//  Book My Appointment
//
//  Created by Hitesh Raichandani on 11/30/16.
//  Copyright © 2016 Book My Appointment. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "app-background")!)
        self.view.backgroundColor?.withAlphaComponent(0.4)
        
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""{
            
            if passwordTextField.text == confirmPasswordTextField.text {
        
                guard let email = emailTextField.text, let password = passwordTextField.text else { return }
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.displayAlert(message: "Incorrect Email address")
                            return
                        }
                        // Account creation successful, perform action here
            
                        // Store data in Firebase
            
                        // Open main application view controller
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                }
            }else {
                self.displayAlert(message: "Password and confirm password do not match")
                return
            }
        }
        else {
            self.displayAlert(message: "Required Field Missing")
            return
        }
    }
    
    // ----- Create Account -----
    @IBAction func haveAccount() {
        
        performSegue(withIdentifier: "LoginSegue", sender: nil)
        
    }
    
    func displayAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
