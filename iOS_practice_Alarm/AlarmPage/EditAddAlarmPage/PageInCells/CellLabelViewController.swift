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
        cell.textField.text = labelText
        print(labelText+" vs "+cell.textField.text!)
        return cell
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("CellLabel: viewWillDisappear")
        let editAddAlarmPageVC =  EditAddAlarmPageViewController()
            
        print("hi")
        
        let cellLabelTextFieldTableViewCell = CellLabelTextFieldTableViewCell()
        
        editAddAlarmPageVC.labelText = "yrse"
        //todo: https://www.hackingwithswift.com/example-code/system/how-to-pass-data-between-two-view-controllers
        
        print(editAddAlarmPageVC.labelText)
        
    }
    
    
}
