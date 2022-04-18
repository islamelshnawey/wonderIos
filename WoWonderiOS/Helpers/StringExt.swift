

import UIKit
import CommonCrypto

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}


extension FixedWidthInteger {
    var byteWidth:Int {
        return self.bitWidth/UInt8.bitWidth
    }
    static var byteWidth:Int {
        return Self.bitWidth/UInt8.bitWidth
    }
}

extension Double {
    func getDateStringFromUnixTime(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}




extension Bundle {
    class func mainInfoDictionary(key: CFString) -> String? {
        return self.main.infoDictionary?[key as String] as? String
    }
}

extension String {
    
    func arrangeMentionedContacts()->String{
        var temp = ""
        
        for (index, element) in self.replacingOccurrences(of: "@@", with: "@").components(separatedBy: "@").enumerated() {
            print("Item \(index): \(element)")
            
            if index == 0 {
                temp += element
            }else {
                temp += " @\(element)"
            }
        }
        
        return temp
    }
    
    func processDateWithDayAndMinuteAndSecondDifference()-> String{
        // Sample Data :  "createdAt":"2018-02-01 09:53:38.0"
        //        print(self)
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        print(String(dateString))
        let convertedDate = dateFormatter.date(from: String(dateString))
        
        if Date().years(from: convertedDate!) > 0 {
            if Date().years(from: convertedDate!) == 1 {
                return "\(Date().years(from: convertedDate!)) year ago"
            }
            return "\(Date().years(from: convertedDate!)) year ago"
        }else if Date().months(from: convertedDate!) > 0 {
            if Date().months(from: convertedDate!) == 1 {
                return "\(Date().months(from: convertedDate!)) months ago"
            }
            return "\(Date().months(from: convertedDate!)) months ago"
        }else if Date().weeks(from:convertedDate!) > 0 {
            if Date().weeks(from: convertedDate!) == 1 {
                return "\(Date().weeks(from:convertedDate!)) week ago"
            }
            return "\(Date().weeks(from:convertedDate!)) weeks ago"
        }else if Date().days(from:convertedDate!) > 0 {
            if Date().days(from:convertedDate!) == 1 {
                return "\(Date().days(from:convertedDate!)) day ago"
            }
            return "\(Date().days(from:convertedDate!)) days ago"
        }else if Date().hours(from: convertedDate!) > 0 {
            if Date().hours(from: convertedDate!) == 1 {
                return "\(Date().hours(from: convertedDate!)) hour ago"
            }
            return "\(Date().hours(from: convertedDate!)) hours ago"
        }else if Date().minutes(from: convertedDate!) > 0 {
            if Date().minutes(from: convertedDate!) == 1 {
                return "\(Date().minutes(from: convertedDate!)) minute ago"
            }
            
            return "\(Date().minutes(from: convertedDate!)) minutes ago"
        }
        
        
        if Date().seconds(from: convertedDate!) > 1 {
            return  "\(Date().seconds(from: convertedDate!)) second ago"
        }
        
        return  "Just now"
    }
}
