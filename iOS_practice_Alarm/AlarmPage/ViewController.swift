//
//  ViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/23.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var alarmDatabase = AlarmDatabase()
    var editOrAdd = ""
    var selectedIndexRow: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .done, target: self, action: #selector(editAlarm))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addAlarm))
        self.navigationItem.title = "鬧鐘"
    }
    
    
    @objc func editAlarm(){
        print("editAlarm")
        editOrAdd = "編輯"
        tableView.isEditing = !tableView.isEditing
        navigationItem.leftBarButtonItem?.title = (self.tableView.isEditing) ? "完成" : "編輯"
        tableView.reloadData()
        
    }
    
    @objc func addAlarm(){
        print("addAlarm")
        editOrAdd = "加入"
        performSegue(withIdentifier: "EditAddAlarmPageSegue", sender: nil)
    }
    
    
    
    func reloadDataForTableViewAndLocalData() {
        print("Called: reloadDataForTableViewAndLocalData()")
        alarmDatabase.clearLocalUserData()
        tableView.reloadData()
    }
}

// MARK: - tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("alarmDatabase.getDataCount() \(alarmDatabase.getDataCount())")
        return alarmDatabase.getDataCount()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        // alarmDataInTable
        let alarmData = alarmDatabase.loadDataForTable(indexPath: indexPath.row)
        
        let timeText = "\((Int(alarmData.time) ?? 0) / 100):\((Int(alarmData.time) ?? 0) % 100)"
        cell.alarmTimeLabel.text = timeText
        cell.labelLabel.text = alarmData.label
        cell.alarmSwitch.setOn(alarmData.isAlarmActive, animated: true)
        
        if alarmData.repeatDays.count != 0{
            cell.repeatDaysLabel.text = getDayOfWeekText(alarmData.repeatDays)
        }

        // 如果編輯模式，switch隱藏(editAlarm()中有reloadData())
        cell.alarmSwitch.isHidden = tableView.isEditing
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleted")
            // todo 刪除
        }
    }
    
    // 選擇了 cell 後，進入編輯頁面(由於property設定cell不可選、editing mode 下可單選)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        print(indexPath.row)
        selectedIndexRow = indexPath.row
        performSegue(withIdentifier: "EditAddAlarmPageSegue", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditAddAlarmPageSegue" {

            let editAddAlarmPageNavigationController = segue.destination as! UINavigationController
            let editAddAlarmPageVC = editAddAlarmPageNavigationController.topViewController as! EditAddAlarmPageViewController
            editAddAlarmPageVC.receivedActionMode = editOrAdd
            let uuidForCell = alarmDatabase.loadDataForTable(indexPath: selectedIndexRow!).UUID
            editAddAlarmPageVC.receivedAlarmData = alarmDatabase.loadSingleUserFullData(UUID: uuidForCell)
            editAddAlarmPageVC.completionHandler = {
                self.reloadDataForTableViewAndLocalData()
            }

        }
    }
    
    
}

// MARK: - functions
extension ViewController {
    func getDayOfWeekText(_ days: String) -> String {
        let daysOfWeek: Dictionary<Int, String> = [1 : "星期日",
                                                   2 : "星期一",
                                                   3 : "星期二",
                                                   4 : "星期三",
                                                   5 : "星期四",
                                                   6 : "星期五",
                                                   7 : "星期六"]
        var daysString = "，"
        for day in days {
            daysString += "\(daysOfWeek[Int(String(day))!]!) "
        }
        return daysString
    }
}
