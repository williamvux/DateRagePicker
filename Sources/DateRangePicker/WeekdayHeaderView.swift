//
//  WeekdayHeaderView.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

internal struct WeekdayHeaderView: View {
    var manager: CalendarManager
    
    var weekdays: [String] {
        Helpers.getWeekdayHeader(calendar: manager.calendar)
    }
    var body: some View {
        HStack(alignment: .center) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(manager.fonts.weekdayHeader)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(manager.colors.weekdayHeader)
            .background(manager.colors.weekdayHeaderBack)
        }
    }
}

#Preview {
    WeekdayHeaderView(
        manager: CalendarManager()
    )
}
