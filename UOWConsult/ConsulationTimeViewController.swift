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
import ActionSheetPicker_3_0

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
	
	let user = NSUserDefaults.standardUserDefaults()
	var classes = Dictionary<String, Array<Class>>()
	var subject = [String]()
	var dateSelected = NSDate()
	
	var enrolledSubject = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		TimetableRef.keepSynced(true)
		EnrolledRef.keepSynced(true)
		
		setCalendar()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		user.setObject("Student", forKey: "role")
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
	
	func getEnrolledSubjects(){
		user.setObject("fake@cy.my", forKey: "email")
		guard let email = user.stringForKey("email") else {
			showDialog("User not logged in, please login.")
			performLogin()
			return
		}
		
		EnrolledRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
			let enrolledDict = snapshot.value as! [String:AnyObject]
			self.enrolledSubject.removeAll()
			for enrolled in enrolledDict {
				let enrol = enrolled.1
				if enrol["student"] as? String == email {
					self.enrolledSubject.append((enrol["subject"] as? String)!)
				}
			}
		})
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
	
	func performLogin(){
		let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LocationViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
}

//MARK:- TABLEVIEW Related
extension ConsulationTimeViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return classes.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return classes[subject[section]]!.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return subject[section]
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("timetableCell", forIndexPath: indexPath) as! ConsultationTimetableTableViewCell
		
		let section = indexPath.section
		let row = indexPath.row
		
		let sectionSubjects = classes[subject[section]]!
		let subjectItem: Class = sectionSubjects[row]
		
		if subjectItem.type == "Consultation" {
			cell.backgroundColor = UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.2)
		} else {
			cell.backgroundColor = UIColor.clearColor()
		}
		
		cell.labelSubjectCode.text = subject[section]
		cell.labelSubjectTime.text = subjectItem.startTime + " - " + subjectItem.endTime
		cell.labelSubjectType.text = subjectItem.type
		cell.labelSubjectLocation.text = subjectItem.location
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let row = indexPath.row
		let section = indexPath.section
		let selectedTimeslot = classes[subject[section]]![row]
		
		let role = user.stringForKey("role")
		if role == "Student"{
			switch selectedTimeslot.type {
			case "Consultation":
				bookingConsultation(subject[section], timeslot:selectedTimeslot)
			default:
				performSegueWithIdentifier("goToLocationView", sender: selectedTimeslot.location)
			}
		} else {
			switch selectedTimeslot.type  {
			case "Consultation":
				deleteConsultationTime(subject[section], timeslot:selectedTimeslot)
			default:
				performSegueWithIdentifier("goToLocationView", sender: selectedTimeslot.location)
			}
		}
	}
	
	func bookingConsultation(subject:String, timeslot: Class){
		guard let email = user.stringForKey("email") else {
			showDialog("User not logged in, please login.")
			performLogin()
			return
		}
		
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		let calendar = NSCalendar.currentCalendar()
		let dateComponent = NSDateComponents()
		dateComponent.minute = -15
		
		let startTime = dateFormatter.dateFromString(timeslot.startTime)
		var endTime = dateFormatter.dateFromString(timeslot.endTime)
		endTime = calendar.dateByAddingComponents(dateComponent, toDate: endTime!, options: [])
		
		let datePicker = ActionSheetDatePicker(title: "Reservation Time", datePickerMode: UIDatePickerMode.Time, selectedDate: startTime, doneBlock: {
			picker, value, index in
			
			let time = dateFormatter.stringFromDate(value as! NSDate)
			
			dateFormatter.dateFormat = "YYYY-MM-dd"
			let parameter = [
				"student" : email,
				"date" : dateFormatter.stringFromDate(self.dateSelected),
				"subject" : subject,
				"time" : time
			]
		
			self.ConsultRef.childByAutoId().setValue(parameter)
			
			return
			}, cancelBlock: { ActionStringCancelBlock in return }, origin: self.tableView)
		
		datePicker.minimumDate = startTime
		datePicker.maximumDate = endTime
		datePicker.locale = NSLocale(localeIdentifier: "en_AU")
		datePicker.minuteInterval = 15
		datePicker.showActionSheetPicker()
	}
	
	func deleteConsultationTime(subject:String, timeslot: Class){
		let alert = UIAlertController(title: "Remove Consultation Slot",
		                              message: "Do you want to remove selected consultation slot?",
		                              preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
		alert.addAction(UIAlertAction(title: "Confirm", style: .Destructive) { UIAlertAction in
			let ref = self.TimetableRef.child(subject).child(timeslot.id)
			ref.removeValue()
			
			alert.dismissViewControllerAnimated(true, completion: nil)
		})
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToLocationView" {
			let vc = segue.destinationViewController as! LocationViewController
			let location = sender!.componentsSeparatedByString("-").first
			vc.buildingNo = location
		}
	}
}

//MARK:- JTCalendar Related
extension ConsulationTimeViewController: JTCalendarDelegate {
	func setCalendar(){
		calendar.delegate = self
		
		calendar.settings.weekModeEnabled = true

		calendarMenuView.contentRatio = 0.75
		
		calendar.menuView = calendarMenuView
		calendar.contentView = calendarContentView
		calendar.setDate(NSDate())
	}
	
	override func viewDidLayoutSubviews() {
		calendar.reload()
	}
	
	func transition() -> Void{
		calendar.reload()
		
		var newHeight: CGFloat = 300
		if(calendar.settings.weekModeEnabled){
			newHeight = 85.0;
		}
		
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.calendarContentViewHeight.constant = newHeight
			self.view.layoutIfNeeded()
		})
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			self.calendarContentView.layer.opacity = 0
		}) { (finished) -> Void in
			self.calendar.reload()
			UIView.animateWithDuration(0.25, animations: { () -> Void in
				self.calendarContentView.layer.opacity = 1;
			})
			self.calendarContentViewHeight.constant = newHeight;
			self.view.layoutIfNeeded()
		}
	}
	
	func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		if let calendarDayView = dayView as? JTCalendarDayView {
			// Today
			if(calendar.dateHelper .date(NSDate(), isTheSameDayThan: calendarDayView.date)){
				calendarDayView.circleView.hidden = false;
				calendarDayView.circleView.backgroundColor = UIColor.blueColor();
				calendarDayView.dotView.backgroundColor = UIColor.whiteColor();
				calendarDayView.textLabel.textColor = UIColor.whiteColor();
			}
				// Selected date
			else if(calendar.dateHelper .date(dateSelected, isTheSameDayThan: calendarDayView.date)){
				calendarDayView.circleView.hidden = false;
				calendarDayView.circleView.backgroundColor = UIColor.redColor();
				calendarDayView.dotView.backgroundColor = UIColor.whiteColor();
				calendarDayView.textLabel.textColor = UIColor.whiteColor();
			}
				// Other month
			else if(!calendar.dateHelper .date(calendarContentView.date, isTheSameMonthThan: calendarDayView.date)){
				calendarDayView.circleView.hidden = true;
				calendarDayView.dotView.backgroundColor = UIColor.redColor();
				calendarDayView.textLabel.textColor = UIColor.lightGrayColor();
			}
				// Another day of the current month
			else{
				calendarDayView.circleView.hidden = true;
				calendarDayView.dotView.backgroundColor = UIColor.redColor();
				calendarDayView.textLabel.textColor = UIColor.blackColor();
			}
			let date = calendarDayView.date
			let dateFormatter = NSDateFormatter()
			dateFormatter.locale = NSLocale(localeIdentifier: "en_AU")
			dateFormatter.dateFormat = "yyyy"
			//yearButton.titleLabel?.text = dateFormatter.stringFromDate(date)
			yearButton.setTitle(dateFormatter.stringFromDate(date), forState: .Normal)
			calendarDayView.dotView.hidden = true
		}
	}
	
	func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
		if let calendarDayView = dayView as? JTCalendarDayView {
			
			dateSelected = calendarDayView.date
			
			updateViewWithDate(dateSelected)
			
			// Animation for the circleView
			calendarDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
			
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				calendarDayView.circleView.transform = CGAffineTransformIdentity;
				calendar.reload()
			})
			
			// Load the previous or next page if touch a day from another month
			if(!calendar.dateHelper .date(calendarContentView.date, isTheSameMonthThan: calendarDayView.date)){
				if(calendarContentView.date .compare(calendarDayView.date) == NSComparisonResult.OrderedAscending){
					calendarContentView.loadNextPageWithAnimation()
				}
				else{
					calendarContentView.loadPreviousPageWithAnimation()
				}
			}
			
			calendar.setDate(dateSelected)
		}
	}
}

