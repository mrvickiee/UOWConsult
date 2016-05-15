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

    @IBOutlet weak var newEmail: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    var authenticated : Bool = false
    var oldEmail : String = ""
    var oldPassword : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let ref = Firebase(url: "https://uow-consult.firebaseio.com")
        ref.authUser("pyitheinmaung@gmail.com", password: "batman27",
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            // There was an error logging in to this account
                        } else {
                            // We are now logged in
                            print("Authenticated  \(authData.providerData["email"])")
                            
                            self.authenticated = true
                            self.oldEmail = authData.providerData["email"] as! String
                            self.oldPassword = "batman27"
                        }
        })

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func saveChanges(sender: AnyObject) {
        
        let tempPass = newPassword.text!
        print("fetched password field : \(tempPass)")
        
        let ref = Firebase(url: "https://uow-consult.firebaseio.com")
        ref.changePasswordForUser(oldEmail, fromOld: oldPassword,
                                  toNew: tempPass, withCompletionBlock: { error in
                                    if error != nil {
                                        
                                        // There was an error processing the request
                                    } else {
                                        
                                        // Password changed successfully
                                        print("password changed")
                                        
                                    }
        })
        
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
