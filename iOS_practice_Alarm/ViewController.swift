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
    }
    
    @objc func addAlarm(){
        print("addAlarm")

    }
}

// MARK: - tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let alarmData = alarmDatabase.loadDataForTable(indexPath: indexPath.row)
        let timeText = "\(alarmData.time / 100):\(alarmData.time % 100)"
        cell.alarmTimeLabel.text = timeText
        cell.labelLabel.text = alarmData.label
        cell.alarmSwitch.setOn(alarmData.isAlarmActive, animated: true)
        // todo 把 repeatDays 改成用數字來存 然後用Date之類的東西來轉，這樣就可以用一個for迴圈搞定
        //cell.repeatDaysLabel.text = alarmData.repeatDays
        
        return cell
    }
    
    
}