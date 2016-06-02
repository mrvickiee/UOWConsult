//
//  SettingViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 9/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class SettingViewController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var currentUser : String?
    var currentEmail : String?
	var currentRole:String?
	@IBOutlet weak var actionButton: UIButton!
    
	@IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		obtainUserInfo()
		
		if currentRole == "Student" {
			self.actionButton.setTitle("Enroll" , forState: UIControlState.Normal)
		}else{
			self.actionButton.setTitle("Create Subject" , forState: UIControlState.Normal)
		}
		self.usernameLabel.text = self.currentUser
		self.emailLabel.text = self.currentEmail
		self.roleLabel.text = self.currentRole
		
	}
	
	@IBAction func logOutPressed(sender: AnyObject) {
		
		let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .ActionSheet)

		alert.addAction(UIAlertAction(title: "Log Out", style: .Destructive){ UIAlertAction in
			HUD.flash(.Label("Logging out.."), delay: 2) { (finished) in
				try! FIRAuth.auth()!.signOut()
				self.defaults.removeObjectForKey("email")
				self.defaults.removeObjectForKey("role")
				self.defaults.removeObjectForKey("name")
				
				let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
				self.presentViewController(vc, animated: true, completion:nil)
			}

		})

		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		self.presentViewController(alert, animated: true, completion: nil)
    }


    func obtainUserInfo(){
		currentUser = defaults.stringForKey("name")
		currentEmail = defaults.stringForKey("email")
		currentRole = defaults.stringForKey("role")
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func createPressed(sender: AnyObject) {
		let role = defaults.stringForKey("role")
		if role == "Student" {
			performSegueWithIdentifier("goToEnroll", sender: sender)
		}else if role == "Lecturer" {
			performSegueWithIdentifier("goToSubject", sender: sender)
		}

	}
}
