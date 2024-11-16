//
//  CalendarManager.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import Foundation

@Observable
internal final class CalendarManager {
    var selectedDate: Date? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil
    var calendar: Calendar = Calendar.current
    var minimumDate: Date = Date()
    var maximumDate: Date = Date()
    var disabledDates: [Date] = []
    var disabelAfterDate: Date? = nil
    var colors = ColorSettings()
    var fonts = FontSettings()
    
    init(
        selectedDate: Date? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        calendar: Calendar = Calendar.current,
        maximumDate: Date = Date(),
        minimumDate: Date = Date(),
        disabledDates: [Date] = [],
        disabelAfterDate: Date? = nil,
        colors: ColorSettings = ColorSettings(),
        fonts: FontSettings = FontSettings()
    ) {
        self.selectedDate = selectedDate
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.maximumDate = maximumDate
        self.minimumDate = minimumDate
        self.disabledDates = disabledDates
        self.disabelAfterDate = disabelAfterDate
        self.colors = colors
        self.fonts = fonts
    }
    
    func disableDatesContains(date: Date) -> Bool {
        if  let disabelAfterDate = disabelAfterDate, date > disabelAfterDate {
            return true
        } else {
            return disabledDates.contains {
                calendar.isDate($0, inSameDayAs: date)
            }
        }
    }
    
    func monthHeader(monthOffset: Int) -> String {
        if let date = firstOfMonthOffset(monthOffset) {
            return Helpers.getMonthHeader(date: date)
        } else {
            return ""
        }
    }
    
    func firstOfMonthOffset(_ offset: Int) -> Date? {
        var offsetComponent = DateComponents()
        offsetComponent.month = offset
        return calendar.date(byAdding: offsetComponent, to: firstDateOfMonth())
    }
    
    func firstDateOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: minimumDate)
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
}
