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
    
    var uuid: String? = nil
    var isAlarmActive = true

    var selectedDaysOfWeek = Dictionary<Int, String>()
    var labelText = "鬧鐘"
    var sound = "Radar"
    var isSnooze = false
    
    var alarmDatabase = AlarmDatabase()
    
    var completionHandler:(() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferenceTableView.delegate = self
        self.preferenceTableView.dataSource = self

        // 設定navigaiton標題及按鈕
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelOnClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(saveOnClicked))
        self.navigationItem.title = "\(receivedActionMode)鬧鐘"
        
        // unpack alarmData 如果存在
        if (receivedAlarmData != nil) {
            uuid = receivedAlarmData!.UUID
            isAlarmActive = receivedAlarmData!.isAlarmActive
            
            selectedDaysOfWeek = AlarmDataItem.repeatDaysStringToDictionary(receivedAlarmData!.repeatDays)
            labelText = receivedAlarmData!.label
            sound = receivedAlarmData!.sound
            isSnooze = receivedAlarmData!.isSnooze
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HHmm"
            datePicker.date = formatter.date(from: receivedAlarmData!.time)!
        }
        
        print("EditAddAlarmPage: ViewDidLoad")
        
    }
    
    @objc func cancelOnClicked(){
        print("EditAddAlarmPage: cancelOnClicked")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveOnClicked(){
        print("EditAddAlarmPage: saveOnClicked")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let dateString = formatter.string(from: datePicker.date)
        
        
        let alarm = AlarmData(
              UUID: uuid,
              isAlarmActive: isAlarmActive,
              time: dateString,
              label: labelText,
              repeatDays: AlarmDataItem.repeatDaysDictionaryKeyToString(dictionary: selectedDaysOfWeek),
              sound: sound,
              isSnooze: isSnooze)
        alarmDatabase.writeData(alarmData: alarm)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("EditAddAlarmPage: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        completionHandler?()
    }
}



// MAKR: - TableView
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
                labelCell.detailLabel.text = AlarmDataItem.getDaysOfWeekString(from: selectedDaysOfWeek)
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
            
            cellPepeatVC.selectedDaysOfWeek = selectedDaysOfWeek
            
            cellPepeatVC.completionHandler = { data in
                self.selectedDaysOfWeek = data
                self.preferenceTableView.reloadData()

            }
            
        case "CellLabelSegue":
            print("CellLabelSegue")
            let cellLabelVC = segue.destination as! CellLabelViewController
            
            // 把預設或設好的 labelText 傳入 cell 中
            cellLabelVC.labelText = labelText
            
            // 利用閉包的方式，將資料從 cellLabelVC 傳回此
            // source: https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/#back-closure
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

