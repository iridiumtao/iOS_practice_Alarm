//
//  AlarmDataClass.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/23.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_Alarm : Object {

    /// 自動產生UUID
    @objc dynamic var uuid = UUID().uuidString
    
    @objc dynamic var time: String = ""
    @objc dynamic var label: String = ""
    @objc dynamic var repeatDays: String = ""
    @objc dynamic var sound: String = ""
    @objc dynamic var isSnooze: Bool = true
    @objc dynamic var isAlarmActive: Bool = true
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

public struct AlarmsInTable {
    var UUID: String
    var isAlarmActive: Bool
    var time: String
    var label: String
    var repeatDays: String
}

public struct AlarmData {
    var UUID: String?
    var isAlarmActive: Bool
    var time: String
    var label: String
    var repeatDays: String
    var sound: String
    var isSnooze: Bool
}

class AlarmDataItem {
    static let daysOfWeek: Dictionary<Int, String> =
        [1 : "星期日",
        2 : "星期一",
        3 : "星期二",
        4 : "星期三",
        5 : "星期四",
        6 : "星期五",
        7 : "星期六"]
    
    static func getDaysOfWeekString(from daysOfWeek: [Int : String]) -> String {
        var days = ""
        if daysOfWeek.count == 0 {
            return "永不"
        } else if daysOfWeek.count == 7 {
            return "每天"
        } else if !daysOfWeek.keys.contains(2) &&
           !daysOfWeek.keys.contains(3) &&
           !daysOfWeek.keys.contains(4) &&
           !daysOfWeek.keys.contains(5) &&
           !daysOfWeek.keys.contains(6) &&
           daysOfWeek.keys.contains(1) &&
           daysOfWeek.keys.contains(7) {
            return "假日"
        } else if daysOfWeek.keys.contains(2) &&
                  daysOfWeek.keys.contains(3) &&
                  daysOfWeek.keys.contains(4) &&
                  daysOfWeek.keys.contains(5) &&
                  daysOfWeek.keys.contains(6) &&
                 !daysOfWeek.keys.contains(1) &&
                 !daysOfWeek.keys.contains(7) {
            return "平日"
        } else {
            
            // 透過 keys 做排序
            let sortedDaysOfWeek = daysOfWeek.sorted { firstDictionary, secondDictionary in
                return firstDictionary.key < secondDictionary.key // 由小到大排序
            }
            for day in sortedDaysOfWeek {
                days += "\(day.value) "
            }
            return days
        }
    }
    
    static func getDaysOfWeekString(from string: String) -> String {
        return getDaysOfWeekString(from: repeatDaysStringToDictionary(string))
    }
    
    static func repeatDaysDictionaryKeyToString(dictionary: [Int : String]) -> String {
        var intArray = ""
        for key in dictionary.keys {
            intArray += "\(key)"
        }
        
        return intArray
    }
    
    /// 逐字轉換為Int，塞入 AlarmDataItem.daysOfWeek 再 update 入 Dictionary
    static func repeatDaysStringToDictionary(_ days: String) -> [Int : String] {
        var repeatDaysDictionary = Dictionary<Int, String>()
        
        for day in days {
            repeatDaysDictionary.updateValue(AlarmDataItem.daysOfWeek[Int(String(day))!]!, forKey: Int(String(day))!)
        }
        return repeatDaysDictionary
    }
}
