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

class ConsulationTimeViewController: UIViewController {

	@IBOutlet weak var calendarMenuView: JTCalendarMenuView!
	@IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
	@IBOutlet weak var calendarContentViewHeight: NSLayoutConstraint!
	@IBOutlet weak var yearButton: UIButton!
	
	var calendar = JTCalendarManager()
	
	let ConsultRef = FIRDatabase.database().referenceWithPath("Consult")
	let TimetableRef = FIRDatabase.database().referenceWithPath("Timetable")
	let SubjectRef = FIRDatabase.database().referenceWithPath("Subject")
	let EnrolledRef = FIRDatabase.database().referenceWithPath("Enrolled")
	
	let user = NSUserDefaults.standardUserDefaults()
	var subjects = Dictionary<String, Array<Subject>>()
	var subject = [String]()
	var dateSelected = NSDate()
	
	struct Subject {
		var code:String
		var name:String
		var startTime:String
		var endTime:String
		var location:String
		var type:String
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ConsultRef.keepSynced(true)
		TimetableRef.keepSynced(true)
		SubjectRef.keepSynced(true)
		EnrolledRef.keepSynced(true)
		
		setCalendar()
	}
	

	@IBAction func buttonToday(sender: AnyObject) {
		//TODO: API Call
	
		calendar.setDate(NSDate())
		calendar.reload()
	}
	
	@IBAction func buttonCalendarMode(sender: AnyObject) {
		calendar.settings.weekModeEnabled = !calendar.settings.weekModeEnabled
		transition()
	}
	
}

extension ConsulationTimeViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return subjects.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subjects[subject[section]]!.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("timetableCell", forIndexPath: indexPath) as! ConsultationTimetableTableViewCell
		
		let section = indexPath.section
		let row = indexPath.row
		
		let sectionSubjects = subjects[subject[section]]!
		let subjectItem: Subject = sectionSubjects[row]
		
		cell.labelSubjectCode.text = subjectItem.code
		cell.labelSubjectTime.text = subjectItem.startTime + " - " + subjectItem.endTime
		cell.labelSubjectType.text = subjectItem.type
		cell.labelSubjectLocation.text = subjectItem.location
		
		return cell
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return subject[section]
	}
}

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
			let dateFormatter = NSDateFormatter()
			dateFormatter.locale = NSLocale(localeIdentifier: "en_AU")
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let _ = dateFormatter.stringFromDate(dateSelected)
			
			//TODO: API CALL
			
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

