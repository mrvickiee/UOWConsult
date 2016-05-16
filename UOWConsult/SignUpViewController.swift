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
    let ref = Firebase(url: "https://uow-consult.firebaseio.com")
   
    override func viewDidLoad() {
        super.viewDidLoad()
     //   roleTxt.userInteractionEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func registerPressed(sender: AnyObject) {
        let fullname = userTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
        let confirmPass = confirmTF.text!
        
        if(password == confirmPass){
            let user = User(name: fullname, email: email, role: roleName)
            HUD.show(.Progress)
            
            ref.createUser(user.email, password: password,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                print(error)             // There was an error creating the account
                                HUD.flash(.Error, delay:1.0)
                            } else {
                                let uid = result["uid"] as? String
                                self.ref.childByAppendingPath("User").childByAppendingPath(uid).setValue(user.getDictionary())
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(user.email, forKey: "email")
                                defaults.setObject(user.name, forKey: "name")
                                defaults.setObject(user.role, forKey: "role")
                                
                                HUD.flash(.Success, delay:1)
           
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
            })
            
            //let triggerTime = (Int64(NSEC_PER_SEC) * (Int64)(0.5));
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), {
              //  self.logUserIn(user.email, password: password)
            
           // })

       
        }else{
            HUD.flash(.Label("Password do not match!"), delay: 1)
        }
    }
    
//    func logUserIn(login:String, password:String){
//        let triggerTime = (Int64(NSEC_PER_SEC) * (Int64)(3));
//       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), {
//            self.ref.authUser(login, password: password,
//                         withCompletionBlock: { error, authData in
//                            if error != nil {
//                                print(error)
//                            } else {
//                                let defaults = NSUserDefaults.standardUserDefaults()
//                                defaults.setObject(authData.auth["uid"], forKey: "userID")
//                                
//                            }
//            })
//        })
//    }
    
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
