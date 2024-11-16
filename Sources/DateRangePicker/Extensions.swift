//
//  Extensions.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

internal final class ColorSettings {
    var text = Color.primary
    var today = Color.green
    var selected = Color.white
    var betweenStartAndEnd = Color.white
    var disable = Color.gray
    var todayBack = Color.clear
    var textBack = Color.clear
    var disableBack = Color.clear
    var selectedBack = Color.red
    var betweenStartAndEndBack = Color.init(.systemGray)
    var calendarBack = Color.init(.systemGray6)
    var weekdayHeader = Color.primary
    var weekdayHeaderBack = Color.clear
    var monthHeader = Color.primary
    var monthHeaderBack = Color.primary
    var monthBack = Color.clear
}

internal final class FontSettings {
    var monthHeader: Font = .body.bold()
    var weekdayHeader: Font = .title3
    var cellUnselected: Font = .body
    var cellDisabled: Font = .body.weight(.light)
    var cellSelected: Font = .body.weight(.bold)
    var cellToday: Font = .body.weight(.bold)
    var cellBetweenStartAndEnd: Font = .body.weight(.bold)
}

internal final class Helpers {
    static func getWeekdayHeader(calendar: Calendar) -> [String] {
        let weekdays = calendar.shortStandaloneWeekdaySymbols
        
        let firstWeekdayIndex = calendar.firstWeekday - 1
        
        let adjustedWeekdays = Array(weekdays[firstWeekdayIndex...] + weekdays[..<firstWeekdayIndex])
        
        return adjustedWeekdays
    }
    
    static func formatedDate(date: Date) -> String {
        return date.formatted(.dateTime.day())
    }
    
    static func strFromDate(date: Date) -> String {
        return date.formatted()
    }
    
    static func getMonthDayFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.month], from: date)
        
        return components.month! - 1
    }
    
    static func getMonthHeader(date: Date) -> String {
        let dateStyle = Date.FormatStyle().year(.defaultDigits).month(.wide)
        return date.formatted(dateStyle)
    }
    
    static func numberOfMonths(_ minDate: Date, maxDate:Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: minDate, to: maxDate)
        return components.month! + 1
    }
    
    static func lastDayOfMonth(date: Date, calendar: Calendar = .current) -> Date {
        var components = calendar.dateComponents([.year, .month], from: date)
        components.setValue(1, for: .day)
        guard let startOfMonth = calendar.date(from: components) else { return date }
        return calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-86400) ?? startOfMonth
    }
 }

internal struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


let daysPerWeek: Int = 7
let cellWidth: CGFloat = 32


extension MonthView {
    func isThisMonth(_ date: Date) -> Bool {
        return self.manager.calendar.isDate(date, equalTo: firstOfMonthOffset(), toGranularity: .month)
    }
    
    func firstDateMonth() -> Date {
        var components = manager.calendar.dateComponents(calendarUnitYMD, from: manager.minimumDate)
        components.day = 1
        return manager.calendar.date(from: components)!
    }
    
    func firstOfMonthOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        return manager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    func formattedDate(_ date: Date) -> Date {
        let components = manager.calendar.dateComponents(calendarUnitYMD, from: date)
        return manager.calendar.date(from: components)!
    }
    
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formattedDate(referenceDate)
        let clampedDate = formattedDate(date)
        return refDate == clampedDate
    }
    
    func numberOfDays(offset: Int) -> Int {
        let firstDay = firstOfMonthOffset()
        let rangeOfWeeks = manager.calendar.range(of: .weekOfMonth, in: .month, for: firstDay)
        
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func isStartDate(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.startDate ?? Date())
    }
    
    func isEndDate(date: Date) -> Bool {
        if manager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.endDate ?? Date())
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        } else if manager.endDate == nil {
            return false
        } else if manager.calendar.compare(date, to: manager.startDate ?? Date(), toGranularity: .day) == .orderedAscending {
            return false
        } else if manager.calendar.compare(date, to: manager.endDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formattedDate(date)
        if manager.calendar.compare(clampedDate, to: manager.minimumDate, toGranularity: .day) == .orderedAscending
            || manager.calendar.compare(clampedDate, to: manager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        manager.disableDatesContains(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if manager.startDate == nil {
            return false
        } else if manager.endDate == nil {
            return false
        } else if manager.calendar.compare(manager.endDate ?? Date(), to: manager.startDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isToday(date: Date) -> Bool {
        return formatAndCompareDate(date: date, referenceDate: Date())
    }
    
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) || isStartDate(date: date) || isEndDate(date: date)
    }
    
    func isSelectedDate(date: Date) -> Bool {
        if manager.selectedDate == nil {
            return false
        }
        
        return formatAndCompareDate(date: date, referenceDate: manager.selectedDate ?? Date())
    }
    
    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            if isStartDate {
                self.manager.startDate = date
                self.manager.endDate = nil
                isStartDate = false
            } else {
                self.manager.endDate = date
                if self.isStartDateAfterEndDate() {
                    self.manager.endDate = nil
                    self.manager.startDate = nil
                }
                isStartDate = true
            }
        }
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthOffset()
        let weekday = manager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - manager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0: daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return manager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0..<(numberOfDays(offset: monthOffset) / 7) {
            var columnArray: [Date] = []
            for column in 0..<7 {
                let temp = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(temp)
            }
            rowArray.append(columnArray)
        }
        
        return rowArray
    }
    
    func getMonthHeader() -> String {
        Helpers.getMonthHeader(date: firstOfMonthOffset())
    }
}
