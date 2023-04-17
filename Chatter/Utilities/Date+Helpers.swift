//
//  Date+Helpers.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import Foundation

extension Date {
    
    // Returns date as String formatted to match other chat apps
    // Returns 'Today' if last chat message one day old
    // Returns 'Yesterday' if last chat message two days old
    // Returns 'M/T/W/Th/F/Sat/Sun' if last chat message less than five days old
    // Returns 'MM/DD/YYYY' if last chat message more than five days old
    func descriptiveString(dateStyle: DateFormatter.Style = .short) -> String {
        // Date formatter for set style
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        
        let daysInBetween = self.daysInBetween(date: Date())
        // Returns days since last message in chat
        if daysInBetween == 0 {
            return "Today"
        } else if daysInBetween == 1 {
            return "Yesterday"
        } else if daysInBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        } else {
            return formatter.string(from: self)
        }
    }
    
    // Returns number of days bettwen current date and date parameter
    func daysInBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        if let daysInBetween = calendar.dateComponents([.day], from: date1, to: date2).day {
            return daysInBetween
        } else {
            return 0
        }
    }
}
