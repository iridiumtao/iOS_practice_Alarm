//
//  alarmDatabase.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/23.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

struct AlarmDatabase {
    
    /// 所有的alarm
    private var alarmsInTable: [AlarmsInTable]? = nil
    
    let realm = try! Realm()
    
    var alarmNotification = AlarmNotificationCenter()
    
    /// 新增／編輯 Alarm
    mutating func writeData(alarmData: AlarmData) {
        
        // AlarmDataItem.swift裡的class
        let alarm = RLM_Alarm()
        alarm.time = alarmData.time
        alarm.label = alarmData.label
        alarm.repeatDays = alarmData.repeatDays
        alarm.sound = alarmData.sound
        alarm.isSnooze = alarmData.isSnooze
        alarm.isAlarmActive = alarmData.isAlarmActive

        // 若無UUID -> 新增Alarm（會自動產生新的UUID）
        // 若有UUID -> 寫入UUID，更新Alarm
        if alarmData.UUID == nil {
            // 自動產生UUID
            alarm.uuid = UUID().uuidString
            try! realm.write {
                realm.add(alarm)
            }
        } else {
            alarm.uuid = alarmData.UUID!
            try! realm.write {
                realm.add(alarm, update: .modified)
            }
        }
        
        
        // 通知
        addNotification(alarm: alarm)
        
        print(alarm.uuid)
        print(alarm)
    }
    
    /// 只更改 alarm 啟用狀態
    mutating func writeData(UUID: String, isAlarmActive: Bool) {
        
        let alarm = realm.objects(RLM_Alarm.self).filter("uuid = %@", UUID).first

        try! realm.write {
            // 有了 if let 後面的alarm就不用加"!"
            if let alarm = alarm {
                // 更新 alarm 的啟動狀態
                alarm.isAlarmActive = isAlarmActive
                
                // 新增或刪除通知
                if alarm.isAlarmActive {
                    addNotification(alarm: alarm)
                } else {
                    deleteNotification(uuid: alarm.uuid)
                }
            }
            
        }

        
    }
    
    /// 新增通知
    mutating func addNotification(alarm: RLM_Alarm) {
        alarmNotification.addNotification(uuid: alarm.uuid, title: "鬧鐘響起", subtitle: "鬧鐘時間\(alarm.time)", body: "\(alarm.uuid)\n重複週期\(alarm.repeatDays)", time: alarm.time, repeatWeekDays: alarm.repeatDays)
    }
    
    mutating func deleteNotification(uuid: String) {
        alarmNotification.deleteNotification(uuid: uuid)
    }
    
    /// 刪除資料
    func deleteData(UUID: String) {
        let alarm = realm.objects(RLM_Alarm.self).filter("uuid = %@", UUID)
        try! realm.write {
            realm.delete(alarm)
        }
    }
    
    mutating func getDataCount() -> Int {
        return loadDataFromDatabase()
    }
    
    /// 透過與 tableView cellForRowAt 連動，逐一載入「所有鬧鐘」的「部分資料」（供顯示於table中）
    ///
    /// 呼叫 tableView.reloadData() 前，必須先呼叫 clearLocalUserData()
    mutating func loadDataForTable(indexPath userIndexInTableView: Int) -> AlarmsInTable {
        if alarmsInTable == nil {
            print("Local data not found. Getting data from database")

            let count = loadDataFromDatabase()
            print("data count: \(count)")
            return loadDataForTable(indexPath: userIndexInTableView)
        } else {
            let alarmData: AlarmsInTable = AlarmsInTable(
                 UUID: alarmsInTable![userIndexInTableView].UUID,
                 isAlarmActive: alarmsInTable![userIndexInTableView].isAlarmActive,
                 time: alarmsInTable![userIndexInTableView].time,
                 label: alarmsInTable![userIndexInTableView].label,
                 repeatDays: alarmsInTable![userIndexInTableView].repeatDays)
            return alarmData
        }
    }
    
    /// 清除 alarmsInTable 的資料，來向資料庫重新所求資料
    mutating func clearLocalUserData() {
        alarmsInTable = nil
    }
    
    /// 將資料庫的資料暫存至 alarmsInTable
    ///
    /// 不應該讓他回傳，這只是暫時的方法（雖然我不會回來改）
    private mutating func loadDataFromDatabase() -> Int{
        alarmsInTable = []
        let alarms = realm.objects(RLM_Alarm.self).sorted(byKeyPath: "time", ascending: true)
        for alarm in alarms {
            if checkDataValid(alarm: alarm) {
                alarmsInTable?.append(AlarmsInTable(
                    UUID: alarm.uuid,
                    isAlarmActive: alarm.isAlarmActive,
                    time: alarm.time,
                    label: alarm.label,
                    repeatDays: alarm.repeatDays))
            }
        }
        print("\(realm.configuration.fileURL!)")
        print("data count: \(alarmsInTable!.count)")
        return alarmsInTable!.count
    }

    
    private mutating func checkDataValid(alarm: RLM_Alarm) -> Bool {
        var validNumber = 0
        

        if try! !NSRegularExpression(pattern: "[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}").matches(alarm.uuid) {
            validNumber += 1
        }
        if try! !NSRegularExpression(pattern: "[0-9]{4}").matches(alarm.time) {
            validNumber += 1
        }
        // 非空
        if try! !NSRegularExpression(pattern: ".+").matches(alarm.label) {
            validNumber += 1
        }
        
        // 非空
        if try! !NSRegularExpression(pattern: ".+").matches(alarm.sound) {
            validNumber += 1
        }
        
        // 匹配任意非數字字元時 不合法
        if try! NSRegularExpression(pattern: "\\D").matches(alarm.repeatDays) {
            validNumber += 1
        }
        
        
        return (validNumber == 0 ? true : false)
    }
    
    /// 取得單鬧鐘的全部資料
    /// 用於顯示在點入鬧鐘後的編輯畫面
    ///
    /// 嘗試透過Struct傳輸，以改善Tuple冗長的程式碼（iOS_practice_integrated中的LoginPage）
    func loadSingleUserFullData(UUID: String) -> AlarmData {
        let alarm = realm.objects(RLM_Alarm.self).filter("uuid  CONTAINS '\(UUID)'").first!
        
        let alarmFullData: AlarmData = AlarmData(
             UUID: alarm.uuid,
             isAlarmActive: alarm.isAlarmActive,
             time: alarm.time,
             label: alarm.label,
             repeatDays: alarm.repeatDays,
             sound: alarm.sound,
             isSnooze: alarm.isSnooze)
        return alarmFullData
    }
}


extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

