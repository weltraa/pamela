//
//  models/TaskItem.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
  struct Weekdays: OptionSet, Codable {
    let rawValue: UInt8

    static let sunday    = Weekdays(rawValue: 1 << 0)
    static let monday    = Weekdays(rawValue: 1 << 1)
    static let tuesday   = Weekdays(rawValue: 1 << 2)
    static let wednesday = Weekdays(rawValue: 1 << 3)
    static let thursday  = Weekdays(rawValue: 1 << 4)
    static let friday    = Weekdays(rawValue: 1 << 5)
    static let saturday  = Weekdays(rawValue: 1 << 6)
  }

  enum Frequency: Codable, Equatable {
    case none
    case daily
    case weekly(Weekdays)
  }

  var title: String
  var frequency: Frequency
  var isCompleted: Bool
  var completedDays: [Date] = []
  
  init(title: String, frequency: Frequency, isCompleted: Bool) {
    self.title = title
    self.frequency = frequency
    self.isCompleted = isCompleted
  }
  
  func isDone(on day: Date, calendar: Calendar = .current) -> Bool {
    switch frequency {
      case .none: isCompleted
      case .daily, .weekly:
        completedDays.contains { calendar.isDate($0, inSameDayAs: day) }
    }
  }

  func toggleDone(on day: Date, calendar: Calendar = .current) {
    switch frequency {
      case .none: isCompleted.toggle()
      case .daily, .weekly:
        if let index = completedDays.firstIndex(where: {
          calendar.isDate($0, inSameDayAs: day)
        }) {
          completedDays.remove(at: index)
        }
        else {
          completedDays.append(calendar.startOfDay(for: day))
        }
    }
  }
}
