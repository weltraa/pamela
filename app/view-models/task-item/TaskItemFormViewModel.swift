//
//  TaskItemFormViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class TaskItemFormViewModel {
  enum Frequency: CaseIterable, Identifiable {
    case none
    case daily
    case weekly

    var id: Self { self }

    var str: String {
      switch self {
        case .none:   "None"
        case .daily:  "Daily"
        case .weekly: "Weekly"
      }
    }
  }

  private let allWeekdays: [TaskItem.Weekdays] = [
    .sunday, .monday, .tuesday, .wednesday,
    .thursday, .friday, .saturday
  ]

  var title: String = ""
  var frequency: Frequency = .none
  var selectedWeekdays: TaskItem.Weekdays = []

  // The chosen frequency as `TaskItem` stores it, or `nil` while it is
  // incomplete (weekly with no days picked yet).
  var taskFrequency: TaskItem.Frequency? {
    switch frequency {
      case .none:   TaskItem.Frequency.none
      case .daily:  TaskItem.Frequency.daily
      case .weekly:
        selectedWeekdays.isEmpty
          ? nil
          : TaskItem.Frequency.weekly(selectedWeekdays)
    }
  }

  // Weekday indices (0 = Sunday) in the order the user's calendar starts
  // the week, so they line up with the week calendar.
  var orderedWeekdays: [Int] {
    let firstIndex = Calendar.current.firstWeekday - 1
    return (0..<7).map { (firstIndex + $0) % 7 }
  }

  var canSave: Bool {
    guard !StringUtils.trimmedTitle(for: title).isEmpty
    else { return false }

    return frequency != .weekly || !selectedWeekdays.isEmpty
  }

  init() {}

  /// Starts from an existing task's frequency, to edit it.
  init(frequency taskFrequency: TaskItem.Frequency) {
    switch taskFrequency {
      case .none: frequency = .none
      case .daily: frequency = .daily
      case .weekly(let days):
        frequency = .weekly
        selectedWeekdays = days
    }
  }

  func weekdayName(forWeekdayNum weekday: Int) -> String {
    Calendar.current.veryShortWeekdaySymbols[weekday]
  }

  func weekdayFullName(forWeekdayNum weekday: Int) -> String {
    Calendar.current.weekdaySymbols[weekday]
  }

  func isSelected(weekday: Int) -> Bool {
    guard allWeekdays.indices.contains(weekday)
    else { return false }

    return selectedWeekdays.contains(allWeekdays[weekday])
  }

  func toggle(weekday: Int) -> Void {
    guard allWeekdays.indices.contains(weekday)
    else { return }

    selectedWeekdays.formSymmetricDifference(allWeekdays[weekday])

    if selectedWeekdays == TaskItem.Weekdays(allWeekdays) {
      frequency = .daily
      selectedWeekdays = []
    }
  }

  func makeTask() -> TaskItem {
    let taskFrequency: TaskItem.Frequency = switch frequency {
      case .none:   .none
      case .daily:  .daily
      case .weekly: .weekly(selectedWeekdays)
    }

    return TaskItem(
      title: StringUtils.trimmedTitle(for: title),
      frequency: taskFrequency,
      isCompleted: false
    )
  }
}
