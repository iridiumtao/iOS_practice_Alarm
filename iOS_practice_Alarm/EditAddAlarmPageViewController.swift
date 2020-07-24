//
//  EditAddAlarmPageViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/24.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class EditAddAlarmPageViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var preferenceTableView: UITableView!
    
    var receivedActionMode = ""
    var receivedAlarmData: AlarmData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelOnClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(saveOnClicked))
        self.navigationItem.title = "\(receivedActionMode)鬧鐘"
    }
    
    @objc func cancelOnClicked(){
        print("cancelOnClicked")
    }
    
    @objc func saveOnClicked(){
        print("saveOnClicked")

    }
}

extension EditAddAlarmPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if receivedActionMode == "加入" {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labelCell =
            tableView.dequeueReusableCell(
                withIdentifier: "LabelCell", for: indexPath) as UITableViewCell
        let switchCell =
          tableView.dequeueReusableCell(
              withIdentifier: "SwitchCell", for: indexPath) as UITableViewCell
        let deleteTextCell =
          tableView.dequeueReusableCell(
              withIdentifier: "DeleteTextCell", for: indexPath) as UITableViewCell
        if receivedActionMode == "加入" {
            <#code#>
        } else {
        }
        // todo 創建3個cell的controller
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
}


