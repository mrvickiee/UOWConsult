//
//  EnrollViewController.swift
//  UOWConsult
//
//  Created by Pyi Thein Maung on 28/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import ActionSheetPicker_3_0

class EnrollViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var subjectCode: UITextField!
    
    
    let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")
	let enrolledRef = FIRDatabase.database().referenceWithPath("Enrolled")

    let user = NSUserDefaults.standardUserDefaults()
    var subject = [String]()
    var email : String = ""
    var selectedSubject : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		subjectCode.delegate = self
		email = user.stringForKey("email")!
        SubjectRef.keepSynced(true)
		enrolledRef.keepSynced(true)
        getSubjects()
    }
    
    override func viewWillDisappear(animated: Bool) {
        enrolledRef.removeAllObservers()
        SubjectRef.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSubjects() {
		getEnrolledSubject(){ enrolledSub in
			
			self.SubjectRef.observeEventType(FIRDataEventType.Value, withBlock: {(snaphot) in
				let subjectDict = snaphot.value as! [String:AnyObject]

				for subject in subjectDict {
					if !enrolledSub.contains(subject.0) {
						self.subject.append(subject.0)
					}
				}
				
				print(self.subject)
			})
		}
    }
	
	
	func getEnrolledSubject(completion:(enrolledSub:[String])->()){
		var array = [String]()
		
		enrolledRef.observeEventType(.Value, withBlock:{(snapshot) in
			
			if let enrollDict = snapshot.value as? [String:AnyObject]{
				let enrollFiltered = enrollDict.filter{ ($0.1["student"] as! String) == self.email }
				for filtered in enrollFiltered{
					array.append(filtered.1["subject"] as! String)
				}
			}
			completion(enrolledSub:array)
		})
		
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return false
	}


    
    @IBAction func saveButtonPressed(sender: AnyObject) {
		if subjectCode.text! != ""{
		    let ref = FIRDatabase.database().reference()
            ref.child("Enrolled").childByAutoId().setValue(getDictionary())
			HUD.flash(.Label("Enrolled successfully!"),delay:1)
		}else{
			HUD.flash(.Label("Subject code must not be left empty!"),delay:1)
			
		}
    }

    @IBAction func selectSubjectCode(sender: AnyObject) {
        
        ActionSheetStringPicker.showPickerWithTitle("Select Subject", rows: subject, initialSelection: 0, doneBlock: {
            picker, value, index in
            self.subjectCode.text = index as? String
            self.selectedSubject = self.subjectCode.text!
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)

    }
    
    func getDictionary()->Dictionary<String,String>{
        let userDictionary = [
            "student" : email,
            "subject" : selectedSubject
        ]
        
        return userDictionary
    }

    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    
    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
