//
//  NewConsultationTableViewController.swift
//  UOWConsult
//
//  Created by CY Lim on 23/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import ActionSheetPicker_3_0

class NewConsultationTableViewController: UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var subjectCodeTextField: UITextField!
	@IBOutlet weak var dayTextField: UITextField!
	@IBOutlet weak var startTimeTextField: UITextField!
	@IBOutlet weak var endTimeTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	
	let TimetableRef = FIRDatabase.database().referenceWithPath("Timetable")
	let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")
	
	let user = NSUserDefaults.standardUserDefaults()
	var subject = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		subjectCodeTextField.delegate = self
		dayTextField.delegate = self
		startTimeTextField.delegate = self
		endTimeTextField.delegate = self
		
		TimetableRef.keepSynced(true)
		SubjectRef.keepSynced(true)
		
		getLectureSubject()
    }
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillAppear(animated)
		
		TimetableRef.removeAllObservers()
		SubjectRef.removeAllObservers()
	}
	
	func getLectureSubject(){
		guard let email = user.stringForKey("email") else { performLogin(); return }
		
		SubjectRef.observeEventType(.Value, withBlock: { (snaphot) in
			self.subject.removeAll()
			
			let subjectDict = snaphot.value as! [String: AnyObject]
			
			for subject in subjectDict {
				if subject.1["lecturer"] as! String == email {
					self.subject.append(subject.0)
				}
			}
		})
	}
	
	func performLogin(){
		let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LocationViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	@IBAction func performSave(sender: AnyObject) {
		guard subjectCodeTextField.text != "" else { showDialog("Subject can't be empty"); return }
		guard dayTextField.text != "" else { showDialog("Day of the week can't be empty"); return }
		guard startTimeTextField.text != "" else { showDialog("Start Time can't be empty"); return }
		guard endTimeTextField.text != "" else { showDialog("End Time can't be empty"); return }
		guard locationTextField.text != "" else { showDialog("Location can't be empty"); return }
		
		let subject = subjectCodeTextField.text
		let day = dayTextField.text
		let startTime = startTimeTextField.text
		let endTime = endTimeTextField.text
		let location = locationTextField.text
		
		let parameter = [
			"day" : day!,
			"start_time" : startTime!,
			"end_time" : endTime!,
			"activity" : "Consultation",
			"location" : location!
		]
		
		TimetableRef.child(subject!).childByAutoId().setValue(parameter)
		
		navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func selectSubjectCode(sender: AnyObject) {
		ActionSheetStringPicker.showPickerWithTitle("Select Subject", rows: subject, initialSelection: 0, doneBlock: {
			picker, value, index in
			self.subjectCodeTextField.text = index as? String
			return
		}, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
	}
	
	@IBAction func selectDayOfWeek(sender: AnyObject) {
		let day = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
		
		ActionSheetStringPicker.showPickerWithTitle("Select Day", rows: day, initialSelection: 0, doneBlock: {
			picker, value, index in
			self.dayTextField.text = index as? String
			return
		}, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
	}

	@IBAction func selectStartTime(sender: AnyObject) {
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		let datePicker = ActionSheetDatePicker(title: "Start Time", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), doneBlock: { picker, value, index in
		
			
			self.startTimeTextField.text = dateFormatter.stringFromDate(value as! NSDate)
			return
			}, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
		
		let endTime = endTimeTextField.text
		if endTime != "" {
			datePicker.maximumDate = dateFormatter.dateFromString(endTime!)
		}
		datePicker.minuteInterval = 30
		datePicker.showActionSheetPicker()
	}
	
	@IBAction func selectEndTime(sender: AnyObject) {
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		let datePicker = ActionSheetDatePicker(title: "End Time", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), doneBlock: { picker, value, index in
			self.endTimeTextField.text = dateFormatter.stringFromDate(value as! NSDate)
			return
			}, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
		
		let startTime = startTimeTextField.text
		if startTime != "" {
			datePicker.minimumDate = dateFormatter.dateFromString(startTime!)
		}
		datePicker.minuteInterval = 30
		datePicker.showActionSheetPicker()
	}
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
