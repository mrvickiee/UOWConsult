//
//  Subject.swift
//  UOWConsult
//
//  Created by CY Lim on 22/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation


struct Subject {
	var code:String
	var name:String
	var startDate:NSDate
	var endDate:NSDate
	var timetable:[Class]
}