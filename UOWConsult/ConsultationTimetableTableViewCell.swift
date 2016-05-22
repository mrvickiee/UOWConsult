//
//  ConsultationTimetableTableViewCell.swift
//  UOWConsult
//
//  Created by CY Lim on 21/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit

class ConsultationTimetableTableViewCell: UITableViewCell {

	@IBOutlet weak var labelSubjectCode: UILabel!
	@IBOutlet weak var labelSubjectType: UILabel!
	@IBOutlet weak var labelSubjectTime: UILabel!
	@IBOutlet weak var labelSubjectLocation: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
