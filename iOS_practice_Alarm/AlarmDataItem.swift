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
    
    @objc dynamic var time: Int = 0
    @objc dynamic var label: String = ""
    @objc dynamic var repeatDays: [Bool] = []
    @objc dynamic var notificationSound: String = ""
    @objc dynamic var snooze: Bool = true
    @objc dynamic var isAlarmActive: Bool = true
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

public struct AlarmsInTable {
    var UUID: String
    var time: Int
    var label: String
    var repeatDays: [Bool]
    var isAlarmActive: Bool
}

public struct AlarmData {
    var UUID: String?
    var time: Int
    var label: String
    var repeatDays: [Bool]
    var isAlarmActive: Bool
    var notificationSound: String
    var snooze: Bool
}
