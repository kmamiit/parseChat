//
//  LoginViewController.swift
//  parseChat
//
//  Created by Kyle Mamiit (New) on 11/1/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        let alertEmailController = UIAlertController(title: "Username Required", message: "Please enter a valid username.", preferredStyle: .alert)
        let alertPasswordController = UIAlertController(title: "Username Required", message: "Please enter a valid password.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) in
            print("Alert Initiated")
        }
        alertEmailController.addAction(OKAction)
        alertPasswordController.addAction(OKAction)
        
        // set user properties
        newUser.username = usernameLabel.text
        newUser.password = passwordLabel.text
        
        if (usernameLabel.text?.isEmpty)! {
            present(alertEmailController, animated: true, completion: {
            })
        } else if (passwordLabel.text?.isEmpty)! {
            present(alertEmailController, animated: true, completion: {
            })
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success, error: Error?) in
            if let error = error {
                print(error.localizedDescription);
            } else {
                print("User Registered Successfully");
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        let alertEmailController = UIAlertController(title: "Username Required", message: "Please enter a valid username.", preferredStyle: .alert)
        let alertPasswordController = UIAlertController(title: "Username Required", message: "Please enter a valid password.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) in
            print("Alert Initiated")
        }
        alertEmailController.addAction(OKAction)
        alertPasswordController.addAction(OKAction)
        
        if (usernameLabel.text?.isEmpty)! {
            present(alertEmailController, animated: true, completion: {
            })
        } else if (passwordLabel.text?.isEmpty)! {
            present(alertEmailController, animated: true, completion: {
            })
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
