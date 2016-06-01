//
//  LoginViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var role = String()
    var fullName = String()
    let defaults = NSUserDefaults.standardUserDefaults()
    let userRef = FIRDatabase.database().referenceWithPath("User")

    override func viewDidLoad() {
        super.viewDidLoad()
		loginTF.delegate = self
		passwordTF.delegate = self
		
		UIGraphicsBeginImageContext(self.view.frame.size)
		UIImage(named: "wallpaper_consult.png")?.drawInRect(self.view.bounds)
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		self.view.backgroundColor = UIColor(patternImage: image)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidAppear(animated: Bool) {
                            //obtain logged in user id
       let email = defaults.stringForKey("email")
		
        if email != nil{
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! UITabBarController
//            self.presentViewController(vc, animated: true, completion:nil)
			self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
    
    @IBAction func loginPressed(sender: AnyObject) {
        HUD.show(.Progress)

        FIRAuth.auth()?.signInWithEmail(loginTF.text!, password: passwordTF.text!, completion: { (user, error) in
                        if error != nil {
                            HUD.flash(.Label("Incorrect password or email"), delay:1)
                        } else {
                            HUD.flash(.Success, delay:1)
                            self.obtainUserDetails((user?.uid)!)
							self.defaults.setObject(self.loginTF.text!, forKey: "email")
							let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! UITabBarController
							self.presentViewController(vc, animated: true, completion:nil)
//							self.dismissViewControllerAnimated(true, completion: nil)

                        }
        })
    }
	
    func obtainUserDetails(id:String){

           userRef.child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let user = snapshot.value{
                self.defaults.setObject(user["name"], forKey: "name")
                self.defaults.setObject(user["role"], forKey: "role")
				
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
