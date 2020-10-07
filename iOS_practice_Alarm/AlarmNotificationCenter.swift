//
//  NotificationCenter.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/9/24.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import UserNotifications

struct AlarmNotificationCenter {
    let content = UNMutableNotificationContent()
    var uuid = ""
    
    /// 創建本地、前景通知
    /// - Parameters:
    ///   - title: 通知標題
    ///   - subtitle: 通知子標題
    ///   - body: 通知內文
    ///   - dateComponents: 通知時間
    mutating func addNotification(uuid: String, title: String, subtitle: String, body: String, time: String, repeatDays: String) {
        
            
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        
        let str = time
        let hourStart = str.index(str.startIndex, offsetBy: 0)
        let hourEnd = str.index(str.endIndex, offsetBy: -2)
        let hourRange = hourStart ..< hourEnd
        
        let minuteStart = str.index(str.startIndex, offsetBy: 2)
        let minuteEnd = str.endIndex
        let minuteRange = minuteStart ..< minuteEnd
        
        dateComponents.hour = Int(time[hourRange])
        dateComponents.minute = Int(time[minuteRange])
        
        self.uuid = uuid
        
        print("addNotification()")
        
        // 暫時不寫repeat
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print(error ?? "成功建立通知...")
        })
        
    }
    
    
    mutating func deleteNotification(uuid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    

}
