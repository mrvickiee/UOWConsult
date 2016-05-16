//
//  LoginViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var role = String()
    var fullName = String()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
                            //obtain logged in user id
       let email = defaults.stringForKey("email")
        if email != nil{
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainController") as! TmpViewController
            self.presentViewController(vc, animated: true, completion:nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        HUD.show(.Progress)
        let ref = Firebase(url: "https://uow-consult.firebaseio.com")
        ref.authUser(loginTF.text, password: passwordTF.text,
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            HUD.flash(.Label("Incorrect password or email"), delay:1)
                        } else {
                            HUD.flash(.Success, delay:1)
                            self.obtainUserDetails(self.loginTF.text!)
                            
                            self.defaults.setObject(self.loginTF.text, forKey: "email")
                            self.defaults.setObject(self.role, forKey: "role")
                            self.defaults.setObject(self.fullName, forKey: "name")
                            
                            
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainController") as! TmpViewController
                            self.presentViewController(vc, animated: true, completion:nil)
                        }
        })
    }
    
    
    func obtainUserDetails(email:String){
        let ref = Firebase(url:"https://uow-consult.firebaseio.com/User")
        
        ref.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dbEmail = snapshot.value["email"] as? String {
                if(dbEmail == email){
                    self.role = (snapshot.value["role"] as? String)!
                    self.fullName = (snapshot.value["name"] as? String)!
                    return
                }
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
