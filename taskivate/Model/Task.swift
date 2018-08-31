//
//  Task.swift
//  taskivate
//
//  Created by Neil Baron on 7/22/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Foundation

class Task : Equatable {
    
    var title: String?
    var dueDate: Date
    var subCategory: String?
    var endDate: Date?
    
    fileprivate var reminderDate: Date?
    fileprivate var priority_raw: String
    fileprivate var category_raw: String?
    
    fileprivate var repeats_raw: String
    fileprivate var status_raw: String
   
    
    var image: Data?
    
    init(title: String? = nil,
         dueDate: Date = Date(),
         priority: String = Priority.low.rawValue,
         reminderDate: Date? = nil,
         category: String? = nil,
         repeats: String = RepeatFrequency.never.rawValue,
         endDate: Date? = nil,
         image: Data? = nil,
         status: String = Status.inProgress.rawValue,
         subCategory: String? = nil) {
        
        self.title = title
        
        self.dueDate = dueDate
        self.repeats_raw = repeats
        self.endDate = endDate
        self.priority_raw = priority
        self.reminderDate = reminderDate
        
        self.image = image
        
        self.category_raw = category
        self.subCategory = subCategory
        self.status_raw = status
    }
    
    static func ==(_ lhs: Task, _ rhs: Task) -> Bool {
        return (lhs.title == rhs.title)
            && (lhs.dueDate == rhs.dueDate)
            && (lhs.endDate == rhs.endDate)
            && (lhs.repeats_raw == rhs.repeats_raw)
            && (lhs.priority_raw == rhs.priority_raw)
            && (lhs.reminderDate == rhs.reminderDate)
            && (lhs.image == rhs.image)
            && (lhs.category_raw == rhs.category_raw)
    }
    
    
    
}

extension Task {
    
    
    
    enum Priority: String {
        case low = "!"
        case medium = "!!"
        case high = "!!!"
    }
    
    enum Status: String {
        case completed = "Completed"
        case inProgress = "In Progress"
    }
    
    enum Category: String {
        case personal = "Personal 😄"
        case home = "Home 🏠"
        case work = "Work 💼"
        case play = "Play 🎮"
        case health = "Health 🏋🏻‍♀️"
        case travel = "Travel"
    }
    
    
    
    enum RepeatFrequency: String {
        case never = "Never"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case annually = "Annually"
    }
    
    enum Reminder: String {
        case none = "None"
        case halfHour = "30 minutes before"
        case oneHour = "1 hour before"
        case oneDay = "1 day before"
        case oneWeek = "1 week before"
        
        var timeInterval: Double {
            switch self {
            case .none:
                return 0
            case .halfHour:
                return -1800
            case .oneHour:
                return -3600
            case .oneDay:
                return -86400
            case .oneWeek:
                return -604800
            }
        }
        
        static func fromInterval(_ interval: TimeInterval) -> Reminder {
            switch interval {
            case 1800:
                return .halfHour
            case 3600:
                return .oneHour
            case 86400:
                return .oneDay
            case 604800:
                return .oneWeek
            default:
                return .none
            }
        }
    }
}

// MARK: Computed variables
extension Task {
    
    var priority: Priority {
        get {
            return Priority(rawValue: self.priority_raw)!
        }
        set {
            self.priority_raw = newValue.rawValue
        }
    }
    var category: Category? {
        get {
            if let value = self.category_raw {
                return Category(rawValue: value)!
            }
            return nil
        }
        set {
            self.category_raw = newValue?.rawValue
        }
    }
    
   
    var repeats: RepeatFrequency {
        get {
            return RepeatFrequency(rawValue: self.repeats_raw)!
        }
        set {
            self.repeats_raw = newValue.rawValue
        }
    }
    
    var status: Status {
        get {
            return Status(rawValue: self.status_raw)!
        }
        set {
            self.status_raw = newValue.rawValue
        }
    }
    
    var reminder: Reminder {
        get {
            if let date = self.reminderDate {
                let duration = date.seconds(from: self.dueDate)
                return Reminder.fromInterval(duration)
            }
            return .none
        }
        set {
            reminderDate = dueDate.addingTimeInterval(newValue.timeInterval)
        }
    }
    
    func mapTask(dictionary: [String: Any]) -> Task {
        
        let mappedTask = Task()
        
        if let taskName = (dictionary["title"]) {
            mappedTask.title = (taskName as! String)
        }
        
        if let dueDate = (dictionary["dueDate"]) {
            mappedTask.dueDate = dueDate as! Date
        }

        return mappedTask
    }
}

extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> TimeInterval {
        let duration =  Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        return Double(abs(duration))
    }
}
