//
//  TableViewCell.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/23.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var repeatDaysLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
