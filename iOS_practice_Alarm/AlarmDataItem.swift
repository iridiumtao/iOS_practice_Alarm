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
}
