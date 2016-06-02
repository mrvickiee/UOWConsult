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

class CreateSubjectViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var subjectCode: UITextField!
    
    @IBOutlet weak var startingDate: UITextField!
    @IBOutlet weak var endingDate: UITextField!
    
    let user = NSUserDefaults.standardUserDefaults()
    
    var email : String = ""
    var subject = [String]()
    var selectedSubject : String = ""
	let dateFormatter = NSDateFormatter()
	let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")
	

    override func viewDidLoad() {
        super.viewDidLoad()
		SubjectRef.keepSynced(true)
		dateFormatter.dateFormat = "yyyy-MM-dd"
        email = user.stringForKey("email")!
		subjectCode.delegate = self
		subjectName.delegate = self
		startingDate.delegate = self
		endingDate.delegate = self
		
    }
	
	override func viewWillDisappear(animated: Bool) {
		SubjectRef.removeAllObservers()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startDateSelect(sender: AnyObject) {
		
		let datePicker = ActionSheetDatePicker(title: "Start Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: { picker, value, index in
            self.startingDate.text = self.dateFormatter.stringFromDate(value as! NSDate)
            return
            }, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
        
        let endTime = endingDate.text
        if endTime != "" {
            datePicker.maximumDate = dateFormatter.dateFromString(endTime!)
        }
        
        datePicker.showActionSheetPicker()
        
        
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
	

	
    @IBAction func endDateSelect(sender: AnyObject) {
        let datePicker = ActionSheetDatePicker(title: "End Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: { picker, value, index in
            self.endingDate.text = self.dateFormatter.stringFromDate(value as! NSDate)
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
}
