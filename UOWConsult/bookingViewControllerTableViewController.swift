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
	var bookingArr = [Booking]()
	let bookingRef = FIRDatabase.database().referenceWithPath("Booking")
	var role : String = ""
	var email: String = ""
	var test = [Int]()
	let dateFormatter = NSDateFormatter()
	

	
	func populateBooking(){
		self.bookingArr.removeAll()
		
		if(role == "Student"){
			bookingRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
				let bookingDict = snapshot.value as! [String:AnyObject]
				
				for data in bookingDict{
					let bookSlot = data.1
					print(data.0)
					if (bookSlot["student"] as! String == self.email){
						let dateStr = bookSlot["date"] as! String
						let date = self.dateFormatter.dateFromString(dateStr)
						let sub = bookSlot["subject"] as! String
						let time = bookSlot["time"] as! String
						let booked = Booking(date: date!,student: self.email,subject: sub,time: time, key: data.0)
						self.bookingArr.append(booked)
						self.bookingArr.sortInPlace({$0.date.compare($1.date) == NSComparisonResult.OrderedAscending})
						self.tableView.reloadData()
					}
				}
			})
		}else{					//if lecturer
			
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
		
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewWillDisappear(animated: Bool) {
		//bookingRef.removeAllObservers()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookingArr.count
    }
	
	
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookingCell", forIndexPath: indexPath) as! BookingTableViewCell
		
		cell.accessibilityIdentifier = bookingArr[indexPath.row].key
		cell.subjectLabel?.text = bookingArr[indexPath.row].subject
		cell.dateLabel?.text = dateFormatter.stringFromDate(bookingArr[indexPath.row].date)
		cell.timeLabel?.text  = bookingArr[indexPath.row].time

        return cell
    }
	
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
		let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
			
			let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! BookingTableViewCell
			let key = currentCell.accessibilityIdentifier!
			let ref = self.bookingRef.child(key)
			ref.removeValue()
			
			var i = 0
			for arr in self.bookingArr {
				if arr.key == key{
					self.bookingArr.removeAtIndex(i)
				}
				i += 1
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
