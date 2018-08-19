//
//  DateUtils.swift
//  taskivate
//
//  Created by Neil Baron on 3/20/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class DateUtils: NSObject {
    // get current date 
    static func getCurrentTimestamp() -> NSDate {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        return time
    }
    // get formatted date
    static func getFormattedDate(date: Date) -> String {
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        
        let dateStr = dateformatter.string(from: date)
        
        return dateStr
    }
    
    static func getStartOfDay() -> Date{
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
        let dateAtMidnight = calendar.startOfDay(for: Date())
        
        return dateAtMidnight
    }
    
    static func getDateFromString(dateString: String) -> Date {
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        
        let formattedDate = dateformatter.date(from: dateString)
        
        guard formattedDate != nil else {
            fatalError("Date Format does not match ⚠️")
        }
        
        return formattedDate!
    }
    
    static func getEndOfDay(startOfDay: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
       
        let dateAtEnd = calendar.date(byAdding: components, to: startOfDay)
       
        return dateAtEnd!
        
    }
    
    static func getNextDay(startOfDay: Date) -> Date {
        var components = DateComponents()
        components.day = 2
        components.second = -1
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
        
        let dateAtEnd = calendar.date(byAdding: components, to: startOfDay)
        
        return dateAtEnd!
        
    }
    
    static func getEndOfWeek(startOfDay: Date) -> Date {
        var components = DateComponents()
        components.day = 7
        components.second = -1
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
        
        let dateAtEnd = calendar.date(byAdding: components, to: startOfDay)
        
        return dateAtEnd!
        
    }
}
