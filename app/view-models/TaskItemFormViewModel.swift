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

  func weekdayName(forWeekdayNum weekday: Int) -> String {
    Calendar.current.veryShortWeekdaySymbols[weekday]
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

  private var trimmedTitle: String {
    title.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var canSave: Bool {
    guard !trimmedTitle.isEmpty
    else { return false }

    return frequency != .weekly || !selectedWeekdays.isEmpty
  }

  func makeTask() -> TaskItem {
    let taskFrequency: TaskItem.Frequency = switch frequency {
      case .none:   .none
      case .daily:  .daily
      case .weekly: .weekly(selectedWeekdays)
    }

    return TaskItem(
      title: trimmedTitle, frequency: taskFrequency, isCompleted: false
    )
  }
}
