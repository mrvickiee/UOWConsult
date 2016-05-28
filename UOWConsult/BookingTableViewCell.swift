//
//  BookingTableViewCell.swift
//  UOWConsult
//
//  Created by Victor Ang on 29/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

	@IBOutlet weak var subjectLabel: UILabel!
	
	@IBOutlet weak var dateLabel: UILabel!
	
	@IBOutlet weak var timeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
