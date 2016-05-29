//
//  MainTabViewController.swift
//  UOWConsult
//
//  Created by Victor Ang on 30/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

	let defaults = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let email = defaults.stringForKey("email") else{
			self.dismissViewControllerAnimated(true, completion: nil)
			return
		}
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(animated: Bool) {
		//obtain logged in user id
		
		
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
