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
    var editMode = false
    var editOrAdd = ""
    
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
        performSegue(withIdentifier: "EditAddAlarmPageSegue", sender: nil)
    }
    
    @objc func addAlarm(){
        print("addAlarm")
        editOrAdd = "加入"
        performSegue(withIdentifier: "EditAddAlarmPageSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditAddAlarmPageSegue" {

            let editAddAlarmPageNavigationController = segue.destination as! UINavigationController
            let editAddAlarmPageVC = editAddAlarmPageNavigationController.topViewController as! EditAddAlarmPageViewController
            editAddAlarmPageVC.receivedActionMode = editOrAdd
            
            editAddAlarmPageVC.completionHandler = {
                self.reloadDataForTableViewAndLocalData()
            }

        }
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
        
        let alarmData = alarmDatabase.loadDataForTable(indexPath: indexPath.row)
        let timeText = "\((Int(alarmData.time) ?? 0) / 100):\((Int(alarmData.time) ?? 0) % 100)"
        cell.alarmTimeLabel.text = timeText
        cell.labelLabel.text = alarmData.label
        cell.alarmSwitch.setOn(alarmData.isAlarmActive, animated: true)
        
        if alarmData.repeatDays.count != 0{
            cell.repeatDaysLabel.text = getDayOfWeekText(alarmData.repeatDays)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode {
            
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
