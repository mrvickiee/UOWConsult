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
		guard let subject = subjectCodeTextField.text else {
			showDialog("Subject can't be empty")
			return
		}
		guard let day = dayTextField.text else {
			showDialog("Day of the week can't be empty")
			return
		}
		guard let startTime = startTimeTextField.text else {
			showDialog("Start Time can't be empty")
			return
		}
		guard let endTime = endTimeTextField.text else {
			showDialog("End Time can't be empty")
			return
		}
		
		
	}
	
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
}
