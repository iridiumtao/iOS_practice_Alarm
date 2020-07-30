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
    
    var labelText = "鬧鐘"
    var selectedDaysOfWeek = Dictionary<Int, String>()
    var selectedDaysOfWeekText = ""
    
    var alarmDatabase = AlarmDatabase()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferenceTableView.delegate = self
        self.preferenceTableView.dataSource = self

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelOnClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(saveOnClicked))
        self.navigationItem.title = "\(receivedActionMode)鬧鐘"
        
        print("EditAddAlarmPage: ViewDidLoad")
        
    }
    
    @objc func cancelOnClicked(){
        print("EditAddAlarmPage: cancelOnClicked")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveOnClicked(){
        print("EditAddAlarmPage: saveOnClicked")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("EditAddAlarmPage: viewDidAppear")
    }
    
    func getDaysOfWeekString(daysOfWeek: [Int : String]) -> String {
        var days = ""
        if daysOfWeek.keys.contains(1) && daysOfWeek.keys.contains(7) {
            return "假日"
        } else if daysOfWeek.keys.contains(2) &&
                  daysOfWeek.keys.contains(3) &&
                  daysOfWeek.keys.contains(4) &&
                  daysOfWeek.keys.contains(5) &&
                  daysOfWeek.keys.contains(6) {
            return "平日"
        } else if daysOfWeek.count == 0 {
            return "永不"
        } else {
            for day in daysOfWeek.values.sorted(by: <) {
                days += "\(day) "
            }
            return days
        }
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
                labelCell.detailLabel.text = selectedDaysOfWeekText
                
                return labelCell
            case 1:
                labelCell.titleLabel.text = "標籤"
                labelCell.detailLabel.text = labelText
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
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                // 重複
                performSegue(withIdentifier: "CellRepeatSegue", sender: nil)
            case 1:
                // 標籤
                performSegue(withIdentifier: "CellLabelSegue", sender: nil)
            case 2:
                // 提示聲
               performSegue(withIdentifier: "CellNotifySegue", sender: nil)
            case 3:
                // 稍後提醒
                break
            default: break
                
            }
        } else {
            // 刪除
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "EditAddAlarmPageSegue":
//                let editAddAlarmPageNavigationController = segue.destination as! UINavigationController
//                let editAddAlarmPageVC = editAddAlarmPageNavigationController.topViewController as! EditAddAlarmPageViewController
            break
        
        case "CellRepeatSegue":
            print("CellRepeatSegue")
            let cellPepeatVC = segue.destination as! CellRepeatViewController
            cellPepeatVC.completionHandler = { data in
                self.selectedDaysOfWeekText = self.getDaysOfWeekString(daysOfWeek: data)
                self.preferenceTableView.reloadData()
            }
            
        case "CellLabelSegue":
            print("CellLabelSegue")
            let cellLabelVC = segue.destination as! CellLabelViewController
            
            // 把預設或設好的 labelText 傳入 cell 中
            cellLabelVC.labelText = labelText
            
            cellLabelVC.completionHandler = { text in
                print("text = \(text)")
                // 取得使用者輸入的 text，存入 labelText中
                self.labelText = text
                self.preferenceTableView.reloadData()
            }
        
        default:
            break
        }
    }
    
}


