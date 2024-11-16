//
//  DayCell.swift
//  date_range_picker
//
//  Created by William Vux on 15/11/24.
//

import SwiftUI

internal struct DayCellView: View {
    var calendarDate: CalendarDate
    var cellWidth: CGFloat
    
    var corners: UIRectCorner {
        if calendarDate.isStartDate {
            return [.topLeft, .bottomLeft]
        } else if calendarDate.isEndDate {
            return [.topRight, .bottomRight]
        } else {
            return .allCorners
        }
    }
    
    var radius: CGFloat {
        calendarDate.isEndDate || calendarDate.isStartDate ? cellWidth / 2 : 0
    }
    
    var body: some View {
        Text(calendarDate.getText())
            .font(calendarDate.font)
            .foregroundStyle(calendarDate.getTextColor())
            .frame(height: cellWidth)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 20))
            .background(calendarDate.getBackgroundColor())
            .cornerRadius(radius, corners: corners)
    }
}

#Preview {
    Group {
        DayCellView(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        DayCellView(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: true,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        DayCellView(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: true,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        DayCellView(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: false,
                isSelected: true,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        DayCellView(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: true
            ),
            cellWidth: 32
        )
        
    }.frame(width: 32, height: 32)
}
