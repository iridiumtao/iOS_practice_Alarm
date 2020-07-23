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
    
    
    private var alarmsInTable: [AlarmsInTable]? = nil
    let realm = try! Realm()
    
    func writeData(time: Int,
                   label: String,
                   repeatDays: [Bool],
                   notificationSound: String,
                   snooze: Bool,
                   isAlarmActive: Bool) {
        
        let alarm = RLM_Alarm()
        alarm.time = time
        alarm.label = label
        alarm.repeatDays = repeatDays
        alarm.notificationSound = notificationSound
        alarm.snooze = snooze
        alarm.isAlarmActive = isAlarmActive

        try! realm.write {
            realm.add(alarm)
        }
        print(alarm)
        print("\(realm.configuration.fileURL!)")
    }
    
    mutating func loadDataForTable(indexPath userIndexInTableView: Int) -> (UUID: String,
                                                                            time: Int,
                                                                            label: String,
                                                                            repeatDays: [Bool],
                                                                            isAlarmActive: Bool){
        if alarmsInTable == nil {
            loadDataFromDatabase()

            print("Local data not found. Getting data from database")
            return loadDataForTable(indexPath: userIndexInTableView)
        } else {

            let data: (UUID: String,
                       time: Int,
                       label: String,
                       repeatDays: [Bool],
                       isAlarmActive: Bool) = (alarmsInTable![userIndexInTableView].UUID,
                                               alarmsInTable![userIndexInTableView].time,
                                               alarmsInTable![userIndexInTableView].label,
                                               alarmsInTable![userIndexInTableView].repeatDays,
                                               alarmsInTable![userIndexInTableView].isAlarmActive)
            return data
        }
    }
    
    mutating func loadDataFromDatabase() {
        alarmsInTable = []
        let alarms = realm.objects(RLM_Alarm.self).sorted(byKeyPath: "account", ascending: true)
        for alarm in alarms {
            alarmsInTable?.append(AlarmsInTable(UUID: alarm.uuid,
                                                time: alarm.time,
                                                label: alarm.label,
                                                repeatDays: alarm.repeatDays,
                                                isAlarmActive: alarm.isAlarmActive))
        }
    }

    mutating func clearLocalUserData() {
        alarmsInTable = nil
    }
    
    /// 取得單鬧鐘的全部資料
    ///
    /// 由於tuple無法轉成Array透過indexPath.row逐一取得資料、Dictionary沒有順序，故使用Array包成Tuple來傳值
    /// 再與圖像的NSData檔包為一 Tuple 回傳。
    /// - parameters:
    ///   - UUID: 所求資料的UUID
    ///   - password: 檢查用的密碼(可能會透過雜湊值來傳輸)
    /// - returns:
    ///   (使用者的所有資料, 圖片的NSData)
    func loadSingleUserFullData(UUID: String) -> () {
        let alarm = realm.objects(RLM_Alarm.self).filter("uuid  CONTAINS '\(UUID)'").first
        
        // todo: 嘗試把struct改為public，看看程式碼會不會比較簡單


        return ()
    }
    
    
    
}
