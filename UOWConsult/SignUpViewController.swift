//
//  SignUpViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import ActionSheetPicker_3_0
import PKHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
  
    @IBOutlet weak var roleTxt: UITextField!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var roleName = String()
	//let ref = Firebase(url: "https://uow-consult.firebaseio.com")
   
    override func viewDidLoad() {
        super.viewDidLoad()
		roleTxt.delegate = self
		userTF.delegate = self
		emailTF.delegate = self
		confirmTF.delegate = self
		passwordTF.delegate = self
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		if (textField.tag == 1){
			return false
		}else{
			return true
		}
    }
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	

    
    @IBAction func registerPressed(sender: AnyObject) {
        let fullname = userTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
        let confirmPass = confirmTF.text!
        
        if(password == confirmPass){
            let userObj = User(name: fullname, email: email, role: roleName)
            HUD.show(.Progress)
            
           FIRAuth.auth()?.createUserWithEmail(userObj.email, password: password, completion: { (user, error) in
                            if error != nil {
                                print(error)             // There was an error creating the account
                                HUD.flash(.Error, delay:1.0)
                            } else {
                                let ref = FIRDatabase.database().reference()
                                ref.child("User").child(user!.uid).setValue(userObj.getDictionary())
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(userObj.email, forKey: "email")
                                defaults.setObject(userObj.name, forKey: "name")
                                defaults.setObject(userObj.role, forKey: "role")
                                
                                HUD.flash(.Success, delay:1)
           
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
            
            })

       
        }else{
            HUD.flash(.Label("Password do not match!"), delay: 1)
        }
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func rolePressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Roles", rows: ["Student", "Lecturer"], initialSelection: 0, doneBlock: {
            picker, value, index in
            self.roleName = index as! String
            self.roleTxt.text = self.roleName
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        
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
