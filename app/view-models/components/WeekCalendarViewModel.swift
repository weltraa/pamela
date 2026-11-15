//
//  WeekCalendarViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class WeekCalendarViewModel {
  let calendar: Calendar
  var todayDate: Date

  init(calendar: Calendar = .current, todayDate: Date = .now) {
    self.calendar = calendar
    self.todayDate = todayDate
  }

  var days: [Date] {
    guard
      let interval: DateInterval = calendar.dateInterval(
        of: .weekOfYear, for: todayDate
      )
    else { return [] }

    return (0..<7).compactMap { dayIndex in
      calendar.date(
        byAdding: .day, value: dayIndex, to: interval.start
      )
    }
  }

  func weekdayNumStr(for date: Date) -> String {
    String(calendar.component(.day, from: date))
  }

  func weekdayName(for date: Date) -> String {
    let weekdayNum = calendar.component(.weekday, from: date)
    return calendar.shortWeekdaySymbols[weekdayNum - 1]
  }

  func isToday(_ date: Date) -> Bool {
    calendar.isDate(date, inSameDayAs: todayDate)
  }

  func isDay(_ date: Date, sameAs other: Date) -> Bool {
    calendar.isDate(date, inSameDayAs: other)
  }
}
