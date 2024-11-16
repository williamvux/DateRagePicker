//
//  CalendarDate.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

internal struct CalendarDate {
    var date: Date
    var manager: CalendarManager
    var isDisabled: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    var isBetweenStartAndEnd: Bool = false
    var endDate: Date?
    var startDate: Date?
    
    init(date: Date, manager: CalendarManager, isDisabled: Bool, isToday: Bool, isSelected: Bool, isBetweenStartAndEnd: Bool, endDate: Date? = nil, startDate: Date? = nil) {
        self.date = date
        self.manager = manager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
        self.endDate = endDate
        self.startDate = startDate
    }
    
    var isEndDate: Bool {
        date == endDate
    }
    
    var isStartDate: Bool {
        date == startDate
    }
    
    func getText() -> String {
        Helpers.formatedDate(date: date)
    }
    
    func getTextColor() -> Color {
        var textColor = manager.colors.text
        if isDisabled {
            textColor = manager.colors.disable
        } else if isSelected {
            textColor = manager.colors.selected
        } else if isToday {
            textColor = manager.colors.today
        } else if isBetweenStartAndEnd {
            textColor = manager.colors.betweenStartAndEnd
        }
        
        return textColor
    }
    
    var font: Font {
        var fontWeight = manager.fonts.cellUnselected
        
        if isDisabled {
            fontWeight = manager.fonts.cellDisabled
        } else if isSelected {
            fontWeight = manager.fonts.cellSelected
        } else if isToday {
            fontWeight = manager.fonts.cellToday
        } else if isBetweenStartAndEnd {
            fontWeight = manager.fonts.cellBetweenStartAndEnd
        }
        
        return fontWeight
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = manager.colors.textBack
        if isDisabled {
            backgroundColor = manager.colors.disableBack
        } else if isSelected {
            backgroundColor = manager.colors.selectedBack
        } else if isToday {
            backgroundColor = manager.colors.todayBack
        } else if isBetweenStartAndEnd {
            backgroundColor = manager.colors.betweenStartAndEndBack
        }
        
        return backgroundColor
    }
}

