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
        
        self.preferenceTableView.delegate = self
        self.preferenceTableView.dataSource = self

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
                withIdentifier: "LabelCell", for: indexPath) as! LabelTableViewCell
        let switchCell =
          tableView.dequeueReusableCell(
              withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
        let deleteTextCell =
          tableView.dequeueReusableCell(
              withIdentifier: "DeleteTextCell", for: indexPath) as! DeleteTextTableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                labelCell.titleLabel.text = "重複"
                labelCell.detailLabel.text = "永不"
                
                return labelCell
            case 1:
                labelCell.titleLabel.text = "標籤"
                labelCell.detailLabel.text = "鬧鐘"
                return labelCell
            case 2:
                labelCell.titleLabel.text = "提示聲"
                labelCell.detailLabel.text = "電路"
                return labelCell
            case 3:

                switchCell.titleLabel.text = "稍後提醒"
                return switchCell
                
            default: break
                
            }
        } else {
            return deleteTextCell
        }

        return labelCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


