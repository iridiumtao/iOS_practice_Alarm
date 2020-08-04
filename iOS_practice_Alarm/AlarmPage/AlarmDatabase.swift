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
    
    /// 新增／編輯 Alarm
    func writeData(alarmData: AlarmData) {
        
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
            try! realm.write {
                realm.add(alarm)
            }
        } else {
            alarm.uuid = alarmData.UUID!
            try! realm.write {
                realm.add(alarm, update: .modified)
            }
        }
        
        print(alarm)
        print("\(realm.configuration.fileURL!)")
    }
    
    func getDataCount() -> Int {
        let alarms = realm.objects(RLM_Alarm.self)
        return alarms.count
    }
    
    /// 透過與 tableView cellForRowAt 連動，逐一載入「所有鬧鐘」的「部分資料」（供顯示於table中）
    ///
    /// 呼叫 tableView.reloadData() 前，必須先呼叫 clearLocalUserData()
    mutating func loadDataForTable(indexPath userIndexInTableView: Int) -> AlarmsInTable {
        if alarmsInTable == nil {
            loadDataFromDatabase()

            print("Local data not found. Getting data from database")
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
    private mutating func loadDataFromDatabase() {
        alarmsInTable = []
        let alarms = realm.objects(RLM_Alarm.self).sorted(byKeyPath: "time", ascending: true)
        for alarm in alarms {
            alarmsInTable?.append(AlarmsInTable(
                UUID: alarm.uuid,
                isAlarmActive: alarm.isAlarmActive,
                time: alarm.time,
                label: alarm.label,
                repeatDays: alarm.repeatDays))
        }
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
