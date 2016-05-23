//
//  NewConsultationTableViewController.swift
//  UOWConsult
//
//  Created by CY Lim on 23/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import Firebase

class NewConsultationTableViewController: UITableViewController {
	
	@IBOutlet weak var subjectCodeTextField: UITextField!
	@IBOutlet weak var dayTextField: UITextField!
	@IBOutlet weak var startTimeTextField: UITextField!
	@IBOutlet weak var endTimeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	@IBAction func performSave(sender: AnyObject) {
		
	}
}
