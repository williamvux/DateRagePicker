//
//  MonthView.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

internal struct MonthView: View {
    @State var isStartDate = true
    
    var manager: CalendarManager
    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    var monthsArray: [[Date]] {
        monthArray()
    }
    
    @State var showTime = false
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 10) {
                Text(getMonthHeader())
                    .font(.title2)
                    .padding(.leading)
                VStack(alignment: .leading, spacing: 5) {
                        ForEach(monthsArray, id: \.self) { month in
                            HStack(spacing: 0) {
                                ForEach(month, id: \.self) { date in
                                    cellView(date)
                                }
                            }
                    }
                }
            }
            .background(manager.colors.monthBack)
        }
    }
}

#Preview {
    MonthView(
        manager: CalendarManager(), monthOffset: 0
    )
}


extension MonthView {
    func cellView(_ date: Date) -> some View {
        HStack(spacing: 0) {
            if self.isThisMonth(date) {
                DayCellView(
                    calendarDate: CalendarDate(
                        date: date,
                        manager: manager,
                        isDisabled: !isEnabled(date: date),
                        isToday: isToday(date: date),
                        isSelected: isSpecialDate(date: date),
                        isBetweenStartAndEnd: isBetweenStartAndEnd(date: date),
                        endDate: manager.endDate,
                        startDate: manager.startDate
                    ), cellWidth: cellWidth)
                .onTapGesture {
                    self.dateTapped(date: date)
                }
            } else {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
