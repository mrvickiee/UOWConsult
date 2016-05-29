//
//  ConsultationTimeViewController-TableView.swift
//  UOWConsult
//
//  Created by CY Lim on 29/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import PKHUD

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
		
		switch selectedTimeslot.type  {
			case "Consultation":
				showActionView(subject[section], timeslot: selectedTimeslot)
			default:
				ViewMaps(selectedTimeslot.location)
			}
		
	}
	
	func showActionView(subject:String, timeslot: Class){
		let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .ActionSheet)
		
		let role = user.stringForKey("role")
		if role == "Student" {
			alert.addAction(UIAlertAction(title: "Make Reservation", style: .Default){ UIAlertAction in
				self.bookingConsultation(subject, timeslot:timeslot)
			})
		} else {
			alert.addAction(UIAlertAction(title: "Remove Timeslot", style: .Default){ UIAlertAction in
				self.deleteConsultationTime(subject, timeslot:timeslot)
			})
		}
		
		alert.addAction(UIAlertAction(title: "View Maps", style: .Default){ UIAlertAction in
			self.ViewMaps(timeslot.location)
		})
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func ViewMaps(location: String){
		self.performSegueWithIdentifier("goToLocationView", sender: location)
	}
	
	func bookingConsultation(subject:String, timeslot: Class){
		guard let email = user.stringForKey("email") else {
			showDialog("User not logged in, please login.")
			performLogin()
			return
		}
		
		getBookingInfo(subject, date: dateSelected)
		
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		let calendar = NSCalendar.currentCalendar()
		let dateComponent = NSDateComponents()
		dateComponent.minute = -15
		
		let startTime = dateFormatter.dateFromString(timeslot.startTime)
		var endTime = dateFormatter.dateFromString(timeslot.endTime)
		endTime = calendar.dateByAddingComponents(dateComponent, toDate: endTime!, options: [])
		
		let datePicker = ActionSheetDatePicker(title: "Reservation Time", datePickerMode: UIDatePickerMode.Time, selectedDate: startTime, doneBlock: { picker, value, index in
			let time = dateFormatter.stringFromDate(value as! NSDate)
			
			if self.booked.contains(time) {
				HUD.flash(.Label("Choose another time, slot is booked."), delay: 1, completion: nil)
			} else {
				dateFormatter.dateFormat = "YYYY-MM-dd"
				let parameter = [
					"student" : email,
					"date" : dateFormatter.stringFromDate(self.dateSelected),
					"subject" : subject,
					"time" : time
				]
				self.ConsultRef.childByAutoId().setValue(parameter)
				
				return
			}
		}, cancelBlock: { ActionDateCancelBlock in return }, origin: self.tableView)
		
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
}