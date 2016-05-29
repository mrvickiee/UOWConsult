//
//  EditViewController.swift
//  UOWConsult
//
//  Created by Pyi Thein Maung on 15/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
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
        
        
//        let ref = Firebase(url: "https://uow-consult.firebaseio.com")
//        ref.authUser("pyitheinmaung@gmail.com", password: "batman27",
//                     withCompletionBlock: { error, authData in
//                        if error != nil {
//                            // There was an error logging in to this account
//                            
//                        } else {
//                            // We are now logged in
//
//                            
//                            print("Authenticated  \(authData.providerData["email"])")
//                            
//                        }
//        })

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
//    
//    
//    @IBAction func saveButtonPressed(sender: AnyObject) {
//        
//        if let user = FIRAuth.auth()?.currentUser {
//            
//            let tempPassword = user
//        }
//        
//        let newPassword = self.newPassword.text!
//        
//        
//        
//        user?.updatePassword(newPassword) { error in
//            if let error = error {
//                // An error happened.
//                
//            } else {
//                // Password updated.
//                self.popUp("Error!", msg: "Incorrect Password", buttonText: "Retry")
//            }
//        }
//        
//    }

    func changeUsername()  {
        
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = self.newUsername.text!
            print(" changing to \(changeRequest.displayName)")
            
            changeRequest.commitChangesWithCompletion { error in
                if let error = error {
                    // An error happened.
                    print(error)
                    
                    
                } else {
                    // Profile updated.
                    
                }
            }
        }
        
        
        
    }
    
    func changePassword() -> Bool {
        var success = true
        
        let user = FIRAuth.auth()?.currentUser
        let updatePassword = newPassword.text!
        
        user?.updatePassword(updatePassword) { error in
            if let error = error {
                // An error happened.
                success = false
            } else {
                // Password updated.
                success = true
            }
        }
        return success
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
    
    
     func saveChanges() {
        
        var updated : Bool?
        
        if newUsername.text != "" {
      //      changeUsername()
        }else{
            print("user name field empty")
        }
        
//        let checkInput = matchInput()
//        if checkInput == true {
//            updated = changePassword()
//        }
		
        if updated == true {
            popUp("Saved!", msg: "updated details successfully", buttonText: "Okay")
        }else{
            popUp("Invalid input!", msg: "Password fields does not match", buttonText: "Retry")
        }
        
		
    }
    
    
    func saveChanges() {
        self.email = "pyitheinmaung@gmail.com"
        //self.oldPassword = currentPassword.text!
		
		self.updatePassword = self.newPassword.text!
        
        
        print("fetched password field : \(updatePassword)")
        print("fetched old password : \(oldPassword)")

    }
    
    func popUp(okay: String, msg: String, buttonText: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: okay, message: msg , preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if okay == "Saved!"{
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        saveChanges()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

