//
//  CellLabelTextFieldTableViewCell.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellLabelTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
