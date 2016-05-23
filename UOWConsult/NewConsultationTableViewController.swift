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
	
	let TimetableRef = FIRDatabase.database().referenceWithPath("Timetable")
	let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")

    override func viewDidLoad() {
        super.viewDidLoad()
		
		subjectCodeTextField.delegate = self
		dayTextField.delegate = self
		startTimeTextField.delegate = self
		endTimeTextField.delegate = self
		
		TimetableRef.keepSynced(true)
		SubjectRef.keepSynced(true)
    }
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillAppear(animated)
		
		TimetableRef.removeAllObservers()
		SubjectRef.removeAllObservers()
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return false
	}
	
	@IBAction func performSave(sender: AnyObject) {
		guard subjectCodeTextField.text != "" else { showDialog("Subject can't be empty"); return }
		guard dayTextField.text != "" else { showDialog("Day of the week can't be empty"); return }
		guard startTimeTextField.text != "" else { showDialog("Start Time can't be empty"); return }
		guard endTimeTextField.text != "" else { showDialog("End Time can't be empty"); return }
		
		let subject = subjectCodeTextField.text
		let day = dayTextField.text
		let startTime = startTimeTextField.text
		let endTime = endTimeTextField.text
		
		navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func selectSubjectCode(sender: AnyObject) {
		
	}
	
	@IBAction func selectDayOfWeek(sender: AnyObject) {
		
	}
	
	@IBAction func selectStartTime(sender: AnyObject) {
		
	}
	
	@IBAction func selectEndTime(sender: AnyObject) {
		
	}
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
}
