//
//  CellLabelViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var labelText = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "Cell", for: indexPath) as! CellLabelTextFieldTableViewCell
        labelText = cell.textField.text!
        return cell
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let editAddAlarmPageVC = presentingViewController as? EditAddAlarmPageViewController {
            editAddAlarmPageVC.labelText = labelText
        }
    }
}
