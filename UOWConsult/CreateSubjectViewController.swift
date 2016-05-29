//
//  CreateSubjectViewController.swift
//  UOWConsult
//
//  Created by Pyi Thein Maung on 28/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import ActionSheetPicker_3_0

class CreateSubjectViewController: UITableViewController {
    
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var subjectCode: UITextField!
    
    @IBOutlet weak var startingDate: UITextField!
    @IBOutlet weak var endingDate: UITextField!
    
    let user = NSUserDefaults.standardUserDefaults()
    
    var email : String = ""
    var subject = [String]()
    var selectedSubject : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = user.stringForKey("email")!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startDateSelect(sender: AnyObject) {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        let datePicker = ActionSheetDatePicker(title: "Start Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: { picker, value, index in
            
            
            self.startingDate.text = dateFormatter.stringFromDate(value as! NSDate)
            return
            }, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
        
        let endTime = endingDate.text
        if endTime != "" {
            datePicker.maximumDate = dateFormatter.dateFromString(endTime!)
        }
        
        datePicker.showActionSheetPicker()
        
        
        }
    
    
    @IBAction func endDateSelect(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        let datePicker = ActionSheetDatePicker(title: "End Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: { picker, value, index in
            
            
            self.endingDate.text = dateFormatter.stringFromDate(value as! NSDate)
            return
            }, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
        
        datePicker.showActionSheetPicker()

        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        print( " lectuerer = \(email) , \(subjectName.text) , \(subjectCode.text) , \(startingDate.text), \(endingDate.text)")
        
        if subjectName.text == "" || subjectCode.text == "" || startingDate.text == "" || endingDate.text == "" {
            popUp("Invalid input!", msg: "Fields must not be empty", buttonText: "Retry")
        }else{
            
            let ref = FIRDatabase.database().reference()
            ref.child("Subject").child(subjectCode.text!).setValue(getDictionary())
            popUp("Subject Added!", msg: "Subject has been created in the database", buttonText: "Okay")
            
        }
    }
    

    
    func popUp(okay: String, msg: String, buttonText: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: okay, message: msg , preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if okay == "Subject Added!"{
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
    
    
    func getDictionary()->Dictionary<String,String>{
        let userDictionary = [
            "lecturer" : email,
            "subject_name" : self.subjectName.text!,
            "subject_code" : self.subjectCode.text!,
            "start_date" : self.startingDate.text!,
            "end_date" : self.endingDate.text!,
            "passphrase" : " "
        ]
        
        return userDictionary
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
