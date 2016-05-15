//
//  LoginViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let userDefault = NSUserDefaults()                  //obtain logged in user id
        let userID = userDefault.stringForKey("userID")
        
        if userID != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        let ref = Firebase(url: "https://uow-consult.firebaseio.com")
        ref.authUser(loginTF.text, password: passwordTF.text,
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Incorrect password or id")
                        } else {
                            print(authData.auth["uid"])
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(authData.auth["uid"], forKey: "userID")
                           self.dismissViewControllerAnimated(true, completion: nil)
                        }
        })
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
