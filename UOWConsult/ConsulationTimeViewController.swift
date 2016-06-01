//
//  ViewController.swift
//  UOWConsult
//
//  Created by CY Lim on 26/04/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import JTCalendar
import Firebase
import PKHUD



class ConsulationTimeViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addConsultationButton: UIBarButtonItem!
	
	@IBOutlet weak var calendarMenuView: JTCalendarMenuView!
	@IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
	@IBOutlet weak var calendarContentViewHeight: NSLayoutConstraint!
	@IBOutlet weak var yearButton: UIButton!
	
	var calendar = JTCalendarManager()
	
	let TimetableRef = FIRDatabase.database().referenceWithPath("Timetable")
	let EnrolledRef = FIRDatabase.database().referenceWithPath("Enrolled")
	let ConsultRef = FIRDatabase.database().referenceWithPath("Booking")
	let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")
	
	let user = NSUserDefaults.standardUserDefaults()
	var classes = Dictionary<String, Array<Class>>()
	var subject = [String]()
	var booked = [String]()
	var dateSelected = NSDate()
	
	var enrolledSubject = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		TimetableRef.keepSynced(true)
		EnrolledRef.keepSynced(true)
		SubjectRef.keepSynced(true)
		
		setCalendar()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if let role = user.stringForKey("role"){
			if role == "Student" {
				navigationItem.rightBarButtonItem = nil
			} else if role == "Lecturer" {
				navigationItem.rightBarButtonItem = addConsultationButton
			}
		}
		getEnrolledSubjects()
		updateViewWithDate(dateSelected)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		EnrolledRef.removeAllObservers()
		TimetableRef.removeAllObservers()
		SubjectRef.removeAllObservers()
	}
	

	@IBAction func buttonToday(sender: AnyObject) {
		dateSelected = NSDate()
		updateViewWithDate(dateSelected)
	
		calendar.setDate(dateSelected)
		calendar.reload()
	}
	
	@IBAction func buttonCalendarMode(sender: AnyObject) {
		calendar.settings.weekModeEnabled = !calendar.settings.weekModeEnabled
		transition()
	}
	
	@IBAction func buttonAddNewConsultation(sender: AnyObject) {
		performSegueWithIdentifier("goToAddNewConsultationView", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToLocationView" {
			let vc = segue.destinationViewController as! LocationViewController
			let location = sender!.componentsSeparatedByString("-").first
			vc.buildingNo = location
		}
	}
	
	func performLogin(){
		let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
}

//MARK:- Database Observer
extension ConsulationTimeViewController {
	func getEnrolledSubjects(){
		guard let email = user.stringForKey("email"), role = user.stringForKey("role") else {
			showDialog("User not logged in, please login.")
			performLogin()
			return
		}
		self.enrolledSubject.removeAll()
		
		if role == "Lecturer" {
			SubjectRef.observeEventType(.Value, withBlock: { (snapshot) in
				let subjectDict = snapshot.value as! [String:AnyObject]
				
				for enrolled in subjectDict {
					let enrol = enrolled.1
					if enrol["lecturer"] as? String == email {
						self.enrolledSubject.append(enrolled.0)
					}
				}
			})
		} else {
			EnrolledRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
				let enrolledDict = snapshot.value as! [String:AnyObject]
				
				for enrolled in enrolledDict {
					let enrol = enrolled.1
					if enrol["student"] as? String == email {
						self.enrolledSubject.append((enrol["subject"] as? String)!)
					}
				}
			})
		}
	}
	
	func updateViewWithDate(date: NSDate){
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "en_AU")
		dateFormatter.dateFormat = "EEEE"
		let day = dateFormatter.stringFromDate(dateSelected)
		
		switch(day){
		case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
			getSubjectsInfo(day)
		default:
			self.classes.removeAll()
			self.subject.removeAll()
			self.tableView.reloadData()
			showDialog("Life is short, go out and play!")
		}
	}
	
	func getSubjectsInfo(day:String){
		TimetableRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
			self.classes.removeAll()
			self.subject.removeAll()
			
			let timetableDict = snapshot.value as! [String : AnyObject]
			for time in timetableDict {
				if self.enrolledSubject.contains(time.0) {
					let timetable = time.1 as! [String:AnyObject]
					print(timetable)
					for timeslot in timetable {
						let slot = timeslot.1
						if slot["day"] as? String == day {
							let object = Class(id: timeslot.0,
								startTime: (slot["start_time"] as? String)!,
								endTime: (slot["end_time"] as? String)!,
								type: (slot["activity"] as? String)!,
								location: (slot["location"] as? String)!)
							
							if !self.subject.contains(time.0) {
								self.subject.append(time.0)
								self.classes[time.0] = [object]
							} else {
								self.classes[time.0]?.append(object)
							}
							
						}
					}
					self.classes[time.0]?.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
				}
			}
			print(self.classes)
			self.tableView.reloadData()
		})
	}
	
	func getBookingInfo(subject:String, date:NSDate){
		ConsultRef.observeEventType(.Value, withBlock: { (snapshot) in
			self.booked.removeAll()
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "YYYY-MM-dd"
			
			if let bookingDict = snapshot.value as? [String:AnyObject]{
			let subjectFiltered = bookingDict.filter{ ($0.1["subject"] as! String) == subject }
			let dateFiltered = subjectFiltered.filter{ ($0.1["date"] as! String) == dateFormatter.stringFromDate(date) }
			
			for booking in dateFiltered{
				self.booked.append(booking.1["time"] as! String)
			}
			print(self.booked)
			}
		})
	}
}