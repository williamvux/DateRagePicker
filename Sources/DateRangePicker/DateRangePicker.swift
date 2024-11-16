//
//  ContentView.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

public struct DateRangePicker: View {
    var minDate: Date?
    var maxDate: Date?
    
    var onTapCancel: (() -> Void)?
    var onTapSelect: ((_ start: Date?, _ end: Date?) -> Void)?
    
    public init(minDate: Date? = nil, maxDate: Date? = nil, onTapCancel: ( () -> Void)? = nil, onTapSelect: ( (_: Date?, _: Date?) -> Void)? = nil) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.onTapCancel = onTapCancel
        self.onTapSelect = onTapSelect
    }
    
    var manager: CalendarManager {
        CalendarManager(
            maximumDate: maxDate ?? Date().addingTimeInterval(365 * 86400),
            minimumDate: minDate ?? Date()
        )
    }
    
    public var body: some View {
        RangeCalendar(manager: manager, onTapSelect: onTapSelect, onTapCancel: onTapCancel)
    }
}
