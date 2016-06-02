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


}
