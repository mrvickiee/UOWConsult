//
//  LocationViewController.swift
//  UOWConsult
//
//  Created by CY Lim on 22/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class LocationViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	
	let LocationRef = FIRDatabase.database().referenceWithPath("Location")
	
	var location:String?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		observeLocationFromDatabase()
		
		if mapView.annotations.count != 0 {
			mapView.removeAnnotations(mapView.annotations)
		}
	}
	
	func observeLocationFromDatabase(){
		LocationRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
			let enrolledDict = snapshot.value as! NSArray
			
		})
	}
}
