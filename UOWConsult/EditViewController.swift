//
//  EditViewController.swift
//  UOWConsult
//
//  Created by Pyi Thein Maung on 15/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class EditViewController: UITableViewController {

    
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var updatePassword : String = ""
    var oldPassword : String = ""
    var email : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
	}

	
    func changePassword(){
		

		if matchInput(){
			let user = FIRAuth.auth()?.currentUser
			let updatePassword = newPassword.text!
			HUD.show(.Progress)
			user?.updatePassword(updatePassword) { error in
				if let error = error {
					// An error happened.
					HUD.flash(.Label("\(error)"),delay: 1)
				} else {
					// Password updated.
					HUD.flash(.Label("Password changed successfully!"),delay: 1)
					self.navigationController?.popViewControllerAnimated(true)
				}
			}
		}else{
			HUD.flash(.Label("Password do not match!"),delay:1)
		}
    }
    
    func matchInput() -> Bool {
        var matched = true
        
        if newPassword.text == "" || confirmPassword.text == "" {
            matched = false
        }else if newPassword.text == confirmPassword.text {
            matched = true
        }else{
            matched = false
        }
        
        return matched
    }

    @IBAction func saveButtonPressed(sender: AnyObject) {
	
		changePassword()
		
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

