//
//  CustomClockTableViewCell.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 7/11/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class CustomClockTableViewCell: UITableViewCell {

    @IBOutlet var lapLbl: UILabel!
    @IBOutlet var diffTimeLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
