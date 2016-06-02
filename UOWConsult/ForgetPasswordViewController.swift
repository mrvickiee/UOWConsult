//
//  ForgetPasswordViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 2/06/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var emailTF: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		emailTF.delegate = self
		
		UIGraphicsBeginImageContext(self.view.frame.size)
		UIImage(named: "wallpaper_consult.png")?.drawInRect(self.view.bounds)
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		self.view.backgroundColor = UIColor(patternImage: image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func sendPressed(sender: AnyObject) {
		
		if(emailTF.text! != ""){
			HUD.flash(.Label("Password sent! Please check your email"),delay:1)
			sendResetPassword()
		}else{
			HUD.flash(.Label("Please type your email!"),delay:1)
		}
		
	}
	
	@IBAction func backPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func sendResetPassword(){
		
		FIRAuth.auth()?.sendPasswordResetWithEmail(emailTF.text!, completion:  { error in
			if let error = error {
				print(error)
			} else {
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
