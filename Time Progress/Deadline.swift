//
//  CustomDeadline.swift
//  Time Progress
//
//  Created by Brian Valente on 11/27/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Foundation

class Deadline {
    
    static var percentage: Int {
        get {
            switch getDeadlineMode() {
            case "dates":
                return Hours.percentage
            case "hours":
                return Dates.percentage
            default:
                return -1
            }
        }
    }
    
    static var name: String {
        get {
            if let name = UserDefaults.standard.string(forKey: "customdeadline.name"), !name.isEmpty {
                return name
            } else {
                return "Work 💻"
            }
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customdeadline.name")
        }
    }
    
    static var stringValue: String {
        switch getDeadlineMode() {
        case "hours":
            return Hours.stringValue
        case "dates":
            return Dates.stringValue
        default:
            return "Unknown state"
        }
    }
    
    static func getDeadlineMode() -> String {
        return UserDefaults.standard.string(forKey: "customdeadline.mode") ?? "hours"
    }
    
    class Dates {
        
        static var from: Date? {
            get {
                let dateFrom = UserDefaults.standard.object(forKey: "customdeadline.date.from") as! Date? ?? Date()
                return dateFrom
            }
            set {
                guard let date = newValue else { return }
                UserDefaults.standard.setValue(date, forKey: "customdeadline.date.from")
            }
        }
        
        static var to: Date? {
            get {
                let dateTo = UserDefaults.standard.object(forKey: "customdeadline.date.to") as! Date? ?? Date()
                return dateTo
            } set {
                guard let date = newValue else { return }
                UserDefaults.standard.setValue(date, forKey: "customdeadline.date.to")
            }
        }
        
        static var stringValue: String {
            let rawPercentage = self.rawPercentage
            let percentage = self.percentage
            
            if (rawPercentage == 100) {
                return "Finished!"
            } else if (rawPercentage == -1) {
                return "Not yet!"
            }
            
            return String(percentage) + "%"
        }
        
        static var rawPercentage: Int {
            guard
                let dateFrom = Dates.from,
                let dateTo = Dates.to
                else {
                    return -1
            }
            
            let from = dateFrom.timeIntervalSince1970
            let to = dateTo.timeIntervalSince1970
            let now = Date().timeIntervalSince1970
            
            var percentage = ((now - from) * 100) / (to - from)
            
//            let invert = UserDefaults.standard.bool(forKey: "settings.inversepercentage");
//            if (invert) {
//                percentage = 100 - percentage
//            }
            
            if (percentage > 100) {
                percentage = 100
            } else if (percentage < 0) {
                percentage = -1
            }
            
            return Int(percentage)
        }
        
        static var percentage: Int {
            var percentage = self.rawPercentage
            
            let invert = UserDefaults.standard.bool(forKey: "settings.inversepercentage");
            if (invert) {
                percentage = 100 - percentage
            }
            
            return percentage
        }
    }
    
    class Hours {
        static var from: Date? {
            get {
                let timeFrom = UserDefaults.standard.string(forKey: "customdeadline.time.from") ?? "08:00:00"
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let nowObj = Date()
                let calendar = Calendar.current
                let day = calendar.component(Calendar.Component.day, from: nowObj)
                let month = calendar.component(Calendar.Component.month, from: nowObj)
                let year = calendar.component(Calendar.Component.year, from: nowObj)
                
                guard
                    let fromObj = formatter.date(from: "\(year)-\(month)-\(day) \(timeFrom)")
                    else {
                        return nil
                }
                
                return fromObj
            }
            set {
                guard let time = newValue else {
                    return
                }
                
                let calendar = Calendar.current
                let hour = calendar.component(Calendar.Component.hour, from: time)
                let minute = calendar.component(Calendar.Component.minute, from: time)
                let second = calendar.component(Calendar.Component.second, from: time)
                
                let string = "\(hour):\(minute):\(second)"
                UserDefaults.standard.setValue(string, forKey: "customdeadline.time.from")
            }
        }
        
        static var to: Date? {
            get {
                let timeTo = UserDefaults.standard.string(forKey: "customdeadline.time.to") ?? "17:00:00"
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let nowObj = Date()
                let calendar = Calendar.current
                let day = calendar.component(Calendar.Component.day, from: nowObj)
                let month = calendar.component(Calendar.Component.month, from: nowObj)
                let year = calendar.component(Calendar.Component.year, from: nowObj)
                
                guard
                    let toObj = formatter.date(from: "\(year)-\(month)-\(day) \(timeTo)")
                    //let fromObj = Deadline.Hours.from
                    else {
                        return nil
                }
                
//                if (fromObj.timeIntervalSince1970 > toObj.timeIntervalSince1970) {
//                    return toObj.dayAfter
//                }
                
                return toObj
            } set {
                guard let time = newValue else {
                    return
                }
                
                let calendar = Calendar.current
                let hour = calendar.component(Calendar.Component.hour, from: time)
                let minute = calendar.component(Calendar.Component.minute, from: time)
                let second = calendar.component(Calendar.Component.second, from: time)
                
                let string = "\(hour):\(minute):\(second)"
                UserDefaults.standard.setValue(string, forKey: "customdeadline.time.to")
            }
        }
        
        static var stringValue: String {
            let rawPercentage = self.rawPercentage
            let percentage = self.percentage
            
            if (rawPercentage == 100) {
                return "Finished!"
            } else if (rawPercentage == -1) {
                return "Not yet!"
            }
            
            return String(percentage) + "%"
        }
        
        static var rawPercentage: Int {
            guard
                let timeFrom = Hours.from,
                let timeTo = Hours.to
                else {
                    return -1
            }
            
            var from = timeFrom.timeIntervalSince1970
            let to = timeTo.timeIntervalSince1970
            let now = Date().timeIntervalSince1970
            
            if (from > to) {
                from -= 86400
            }
            
            var percentage = ((now - from) * 100) / (to - from)
            
            if (percentage > 100) {
                percentage = 100
            } else if (percentage < 0) {
                percentage = -1
            }
            
            return Int(percentage)
        }
        
        static var percentage: Int {
            let rawPercentage = self.rawPercentage
            var percentage = rawPercentage;
            
            let invert = UserDefaults.standard.bool(forKey: "settings.inversepercentage");
            if (invert) {
                percentage = 100 - rawPercentage
            }
            
            return percentage
        }
    }
    
    
}
