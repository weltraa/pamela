//
//  models/TaskItem.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

struct TaskItem {
  struct Weekdays: OptionSet {
    let rawValue: UInt8

    static let sunday    = Weekdays(rawValue: 1 << 0)
    static let monday    = Weekdays(rawValue: 1 << 1)
    static let tuesday   = Weekdays(rawValue: 1 << 2)
    static let wednesday = Weekdays(rawValue: 1 << 3)
    static let thursday  = Weekdays(rawValue: 1 << 4)
    static let friday    = Weekdays(rawValue: 1 << 5)
    static let saturday  = Weekdays(rawValue: 1 << 6)
  }

  enum Frequency: Equatable {
    case none
    case daily
    case weekly(Weekdays)
  }

  var title: String
  var frequency: Frequency
  var isCompleted: Bool
}
