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
	
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var editSegue = segue.destinationViewController as! UINavigationController
        var editView =  editSegue.topViewController as! EditViewController
        

    }*/
	
	
    
	
    
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

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    


}
