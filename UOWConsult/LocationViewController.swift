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
	
	var buildingNo:String?
	

    override func viewDidLoad() {
        super.viewDidLoad()
		LocationRef.keepSynced(true)
		
		mapView.showsBuildings = true
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		observeLocationFromDatabase()
		
		if mapView.annotations.count != 0 {
			mapView.removeAnnotations(mapView.annotations)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		LocationRef.removeAllObservers()
	}
	
	func observeLocationFromDatabase(){
		LocationRef.child(buildingNo!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
			if let location = snapshot.value {
				let building = Location(name: location["name"] as! String,
										 building: location["id"] as! Int,
										 coordinate: Coordinate(latitude: location["center"]!![0] as! Double,
																longitude: location["center"]!![1] as! Double))
				
				self.populateMapView(building)

			}
		})
	}
	
	func populateMapView(building: Location){
		if mapView.annotations.count != 0 {
			mapView.removeAnnotations(mapView.annotations)
		}
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = CLLocationCoordinate2D(latitude: building.coordinate.latitude, longitude: building.coordinate.longitude)
		annotation.title = building.name
		
		mapView.setCenterCoordinate(annotation.coordinate, animated: true)
		
		let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500))
		mapView.setRegion(region, animated: true)
		
		mapView.addAnnotation(annotation)
	}
}
