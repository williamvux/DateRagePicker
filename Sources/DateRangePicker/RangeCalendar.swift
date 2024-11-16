//
//  RangeCalendar.swift
//  date_range_picker
//
//  Created by William Vux on 16/11/24.
//

import SwiftUI

internal struct RangeCalendar: View {
    @State var manager: CalendarManager
    
    var onTapSelect: ((_ start: Date?, _ end: Date?) -> Void)?
    var onTapCancel: (() -> Void)?
    var numberOfMonth: Int {
        Helpers.numberOfMonths(manager.minimumDate, maxDate: manager.maximumDate)
    }
    var body: some View {
        VStack {
            WeekdayHeaderView(manager: manager)
                .padding(.horizontal)
                .padding(.top)
            Divider()
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        ForEach(0..<numberOfMonth, id: \.self) { index in
                            MonthView(manager: manager, monthOffset: index)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let date = manager.startDate {
                            reader.scrollTo(Helpers.getMonthHeader(date: date), anchor: .center)
                        }
                    }
                }
            }
            HStack(alignment: .center, spacing: 20) {
                Button("Cancel") {
                    onTapCancel?()
                }
                .padding()
                .background(Color.clear)
                
                Button(action: {
                    onTapSelect?(manager.startDate, manager.endDate)
                }) {
                    Text("Sellect")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.title3)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                }
                .background(Color.blue)
                .cornerRadius(.infinity, corners: .allCorners)
            }
        }
        .background(manager.colors.calendarBack.ignoresSafeArea())    }
}

#Preview {
    RangeCalendar(
        manager: CalendarManager(
            maximumDate: Date().addingTimeInterval(365 * 86400),
            minimumDate: Date()
        )
    )
}
