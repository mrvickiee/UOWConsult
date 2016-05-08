//
//  SignUpViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerPressed(sender: AnyObject) {
        let username = userTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
        let confirmPass = confirmTF.text!
        
        if(password == confirmPass){
            let user = User(name: username, email: email, password: password, role: "", username: username)
            let ref = Firebase(url: "https://uow-consult.firebaseio.com")
            
            ref.createUser(user.email, password: user.password,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                print("Error in creating account")
                                // There was an error creating the account
                            } else {
                                let uid = result["uid"] as? String
                                ref.childByAppendingPath("User").childByAppendingPath(uid).setValue(user.getDictionary())
                               // print("Successfully created user account with uid: \(uid)")
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
