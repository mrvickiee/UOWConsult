//
//  ViewController.swift
//  UOWConsult
//
//  Created by CY Lim on 26/04/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import JTCalendar

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