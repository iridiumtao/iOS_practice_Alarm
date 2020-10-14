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
    
    /// 創建本地通知
    /// - Parameters:
    ///   - title: 通知標題
    ///   - subtitle: 通知子標題
    ///   - body: 通知內文
    ///   - dateComponents: 通知時間
    ///   - uuid: alarm 的 uuid，用於刪除註冊好的通知
    ///   - time: 格式為HHmm，eg. 1425，在 func 中進行字串分析。
    ///   - repeatWeekDays: 格式為數字的星期，星期日為1以此類推
    mutating func addNotification(uuid: String, title: String, subtitle: String, body: String, time: String, repeatWeekDays: String) {
        
            
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
        
        print("測試\(time)f \(repeatWeekDays)")
        
        var uuidLocal = uuid
        
        for weekday in repeatWeekDays {
            // 設定通知的時間
            let isRepeat = weekday != "0"

            if isRepeat {
                dateComponents.weekday = Int(String(weekday))
                uuidLocal = uuid + String(weekday)
            }
            dateComponents.hour = Int(time[hourRange])
            dateComponents.minute = Int(time[minuteRange])
            dateComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeat)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

            let request = UNNotificationRequest(identifier: uuidLocal, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print(error ?? "成功建立通知...\nUUID:\(uuidLocal)\n星期:\(weekday)")
            })
        }
    }
    
    
    /// 刪除通知
    /// - Parameter uuid: 透過uuid來刪除特定通知
    mutating func deleteNotification(uuid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    

}
