//
//  bookingViewControllerTableViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 28/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase

class bookingViewControllerTableViewController: UITableViewController {
	let user = NSUserDefaults.standardUserDefaults()
	var bookingArr = Dictionary<NSDate,Array<Booking>>()
	var lecBookingArr = Dictionary<String,Array<Booking>>()
	var dateArr = [NSDate]()
	var subjectArr = [String]()
	let bookingRef = FIRDatabase.database().referenceWithPath("Booking")
	let subjectRef = FIRDatabase.database().referenceWithPath("Subject")
	var role : String = ""
	var email: String = ""
	var test = [Int]()
	let dateFormatter = NSDateFormatter()
	

	
	func populateBooking(){
		self.bookingArr.removeAll()
		self.dateArr.removeAll()
		
		if(role == "Student"){
			bookingRef.observeEventType(.Value, withBlock: { (snapshot) in
				let bookingDict = snapshot.value as! [String:AnyObject]
				
				for data in bookingDict{
					let bookSlot = data.1
					if (bookSlot["student"] as! String == self.email){
						let dateStr = bookSlot["date"] as! String
						let date = self.dateFormatter.dateFromString(dateStr)
						let sub = bookSlot["subject"] as! String
						let time = bookSlot["time"] as! String
						let booked = Booking(date: date!,student: self.email,subject: sub,time: time, key: data.0)
						
						if !self.dateArr.contains(date!){
							self.dateArr.append(date!)
							self.bookingArr[date!] = [booked]
						}else{
							self.bookingArr[date!]?.append(booked)
						}
						self.dateArr.sortInPlace({$0.compare($1) == NSComparisonResult.OrderedAscending})
						self.tableView.reloadData()
					}
				}
			})
		}else{					//if lecturer
			
			
			subjectRef.observeEventType(.Value, withBlock: { (snapshot) in	//obtain lecturer subject
				let subjectDict = snapshot.value as! [String:AnyObject]
				
				for data in subjectDict{
					let sub = data.1
					if(sub["lecturer"] as! String == self.email){
						self.subjectArr.append(data.0)
					}
				}
			})
			
			bookingRef.observeEventType(.Value, withBlock: { (snapshot) in
				let bookingDict = snapshot.value as! [String:AnyObject]
				
				for data in bookingDict{
					let bookSlot = data.1
					
					let dateStr = bookSlot["date"] as! String
					let date = self.dateFormatter.dateFromString(dateStr)
					let sub = bookSlot["subject"] as! String
					let time = bookSlot["time"] as! String
					let booked = Booking(date: date!,student: self.email,subject: sub,time: time, key: data.0)
					
					for(var i = 0; i < self.subjectArr.count ; i++){
						if (booked.subject == self.subjectArr[i]){
							if(self.lecBookingArr[self.subjectArr[i]] != nil){
								self.lecBookingArr[self.subjectArr[i]]?.append(booked)
							}else{
								self.lecBookingArr[self.subjectArr[i]]? = [booked]
								
							}
						}
					}
					
				}
				print(self.lecBookingArr)
				self.tableView.reloadData()
			
			})
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		role = user.stringForKey("role")!
		email = user.stringForKey("email")!
		populateBooking()
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		bookingRef.keepSynced(true)
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewWillDisappear(animated: Bool) {
		bookingRef.removeAllObservers()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		if(role == "Student"){
			return dateArr.count
		}else{
			return subjectArr.count
		}
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if(role == "Student"){
			return bookingArr[dateArr[section]]!.count
		}else{
			return lecBookingArr[subjectArr[section]]!.count
		}
			
	
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if(role == "Student"){
			return dateFormatter.stringFromDate(dateArr[section])
		}else{
			return subjectArr[section]
		}
	
	
	}
	
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("bookingCell", forIndexPath: indexPath) as! BookingTableViewCell
		let section = indexPath.section
		let row = indexPath.row
		let bookings : [Booking]
		let booking : Booking

		if(role == "Student"){
			 bookings = bookingArr[dateArr[section]]!
			 booking  = bookings[row]
		}else{
			bookings = lecBookingArr[subjectArr[section]]!
			 booking = bookings[row]
		}
		
		cell.accessibilityIdentifier = booking.key
		cell.subjectLabel?.text = booking.subject
		cell.dateLabel?.text = dateFormatter.stringFromDate(booking.date)
		cell.timeLabel?.text  = booking.time
        return cell
    }
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
		let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
			
			let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! BookingTableViewCell
			let key = currentCell.accessibilityIdentifier!
			let ref = self.bookingRef.child(key)
			ref.removeValue()
			
			let row = indexPath.row
			let section = indexPath.section
			
			var booking = self.bookingArr[self.dateArr[section]]!
			
//			for (var i = 0; i < booking.count ; i++){
//				
//				if(booking[i].key == key){
//					booking.removeAtIndex(i)
//				}
//			}

			booking.removeAtIndex(row)
			
			self.bookingArr[self.dateArr[section]]! = booking
			
			
			if(self.bookingArr[self.dateArr[section]]!.count == 0){
				self.dateArr.removeAtIndex(section)
			}
			
			self.tableView.reloadData()
			
			
		})
		deleteAction.backgroundColor = UIColor.redColor()
		return [deleteAction]
	}
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
