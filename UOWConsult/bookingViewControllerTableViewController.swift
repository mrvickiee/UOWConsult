//
//  bookingViewControllerTableViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 28/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class bookingViewControllerTableViewController: UITableViewController {
	let bookingRef = FIRDatabase.database().referenceWithPath("Booking")
	let subjectRef = FIRDatabase.database().referenceWithPath("Subject")
	
	var reservations = Dictionary<String,Array<Booking>>()
	var timeSection = [String]()
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		bookingRef.keepSynced(true)
		subjectRef.keepSynced(true)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		populateBooking()
	}
	
	override func viewWillDisappear(animated: Bool) {
		bookingRef.removeAllObservers()
		subjectRef.removeAllObservers()
	}
	
	func populateBooking(){
		guard let email = user.stringForKey("email"), role = user.stringForKey("role") else {
			showDialog("User not logged in, please login.")
			performLogin()
			return
		}
		
		if role == "Student" {
			getStudentBooking(email)
		} else if role == "Lecturer" {
			getLecturerBooking(email)
		}
	}
	
	func getStringFromDate(date:NSDate) -> String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		return dateFormatter.stringFromDate(date)
	}
	
	func performLogin(){
		let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func showDialog(message:String){
		HUD.flash(.Label(message), delay: 1)
	}
}

//MARK:- TableView Related
extension bookingViewControllerTableViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return timeSection.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return reservations[timeSection[section]]!.count
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return timeSection[section]
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("bookingCell", forIndexPath: indexPath) as! BookingTableViewCell

		let section = indexPath.section
		let row = indexPath.row

		let booking = reservations[timeSection[section]]!
		let slot = booking[row]
		
		cell.accessibilityIdentifier = slot.key
		cell.subjectLabel?.text = slot.subject
		cell.dateLabel?.text = slot.date
		cell.timeLabel?.text  = slot.time
		
		return cell
	}
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
		let action = UITableViewRowAction(style: .Destructive, title: "Delete", handler: { (action , indexPath) -> Void in
			
			let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! BookingTableViewCell
			let key = currentCell.accessibilityIdentifier!
			let ref = self.bookingRef.child(key)
			ref.removeValue()
		})
		
		return [action]
	}
}

//MARK:- Database Observer
extension bookingViewControllerTableViewController {
	func getStudentBooking(email:String) {
		bookingRef.observeEventType(.Value, withBlock: { (snapshot) in
			self.reservations.removeAll()
			
			if let bookingDict = snapshot.value as? [String:AnyObject] {
				let emailFilteredBooking = bookingDict.filter{ ($0.1["student"] as! String) == email }
				
				for booking in emailFilteredBooking {
					let slot = booking.1
					let date = slot["date"] as! String
					let booked = Booking(date: date,
										student: slot["student"] as! String,
										subject: slot["subject"] as! String,
										time: slot["time"] as! String,
										key: booking.0)
					
					if date >= self.getStringFromDate(NSDate()){
						if self.reservations.indexForKey(date) == nil {
							self.reservations[date] = [booked]
						} else {
							self.reservations[date]!.append(booked)
						}
						self.reservations[date]?.sortInPlace({ $0.time.compare($1.time) == NSComparisonResult.OrderedAscending})
					}
					
				}
				self.timeSection = Array(self.reservations.keys).sort(<)
				
				self.tableView.reloadData()
				
			}
		})
	}
	
	func getLecturerSubjects(email:String, completion:(subjects:[String]) -> ()){
		var array = [String]()
		subjectRef.observeEventType(.Value, withBlock: { (snapshot) in

			if let subjectDict = snapshot.value as? [String:AnyObject]{
				let subjectFiltered = subjectDict.filter{ ($0.1["lecturer"] as! String) == email }
				print(subjectFiltered)
				
				for booking in subjectFiltered{
					array.append(booking.0)
				}
				completion(subjects: array)
			}
		})
		
	}
	
	func getLecturerBooking(email:String){
		getLecturerSubjects(email){ subjects in
			self.bookingRef.observeEventType(.Value, withBlock: { (snapshot) in
				self.reservations.removeAll()
				
				if let bookingDict = snapshot.value as? [String:AnyObject] {
					for booking in bookingDict{
						let slot = booking.1
						
						for subject in subjects{
							if (slot["subject"] as! String) == subject {
								let date = slot["date"] as! String
								let booked = Booking(date: date,
													student: slot["student"] as! String,
													subject: subject,
													time: slot["time"] as! String,
													key: booking.0)
								
								
								if date >= self.getStringFromDate(NSDate()){
									if self.reservations.indexForKey(date) == nil {
										self.reservations[date] = [booked]
									} else {
										self.reservations[date]!.append(booked)
									}
									self.reservations[date]?.sortInPlace({ $0.time.compare($1.time) == NSComparisonResult.OrderedAscending})
								}
							}
						}
						self.timeSection = Array(self.reservations.keys).sort(<)
					}
					self.tableView.reloadData()
				}
			})
		}
		
		
	}
}