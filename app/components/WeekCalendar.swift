//
//  components/WeekCalendar.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct WeekCalendar: View {
  @State private var viewModel = WeekCalendarViewModel()
  @Binding var selectedDate: Date

  var body: some View {
    HStack {
      ForEach(viewModel.days, id: \.self) { day in
        DayCell(
          weekday:       viewModel.weekdayName(for: day),
          weekdayNumStr: viewModel.weekdayNumStr(for: day),
          isToday:       viewModel.isToday(day),
          isSelected:    viewModel.isDay(day, sameAs: selectedDate)
        ) {
          selectedDate = day
        }
      }
    }
    .padding(.horizontal)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    .sensoryFeedback(.selection, trigger: selectedDate)
    .onReceive(
      NotificationCenter.default.publisher(
        for: UIApplication.significantTimeChangeNotification
      )
    ) { _ in
      viewModel.todayDate = .now
    }
  }
}

private struct DayCell: View {
  private var dayNumColor: Color {
    if isSelected { return .white }

    return isToday ? .accentColor : .primary
  }

  let weekday: String
  let weekdayNumStr: String
  let isToday: Bool
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      VStack(spacing: 6) {
        Text(weekday)
          .font(.caption)
          .fontWeight(.medium)
          .textCase(.uppercase)
          .foregroundStyle(isToday ? Color.accentColor : Color.secondary)

        Text(weekdayNumStr)
          .font(.title3)
          .fontWeight(.semibold)
          .monospacedDigit()
          .foregroundStyle(dayNumColor)
          .frame(width: 40, height: 40)
          .background {
            if isSelected {
              Circle().fill(.tint)
            }
          }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .contentShape(.rect)
    }
    .buttonStyle(.plain)
    // ToDo: review this block below.
    // .accessibilityElement(children: .combine)
    // .accessibilityAddTraits(isSelected ? .isSelected : [])
  }
}

#Preview {
  @Previewable @State var selectedDate = Date.now
  WeekCalendar(selectedDate: $selectedDate)
}
