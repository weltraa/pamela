//
//  TaskItemsTabViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class TaskItemsTabViewModel {
  let calendar: Calendar
  
  init(calendar: Calendar = .current) {
    self.calendar = calendar
  }
  
  func completedCount(of tasks: [TaskItem], on day: Date) -> Int {
    tasks.filter { $0.isDone(on: day, calendar: calendar) }.count
  }
  
  func orphanTasks(from tasks: [TaskItem]) -> [TaskItem] {
    tasks.filter { $0.frequency == .none }
  }
  
  func dailyTasks(from tasks: [TaskItem]) -> [TaskItem] {
    tasks.filter { $0.frequency == .daily }
  }
  
  func weeklyTasks(from tasks: [TaskItem], on day: Date) -> [TaskItem] {
  let weekday = calendar.component(.weekday, from: day)
  let dayFlag = TaskItem.Weekdays(rawValue: 1 << (weekday - 1))

  return tasks.filter { task in
    guard
      case .weekly(let days) = task.frequency
    else { return false }

    return days.contains(dayFlag)
  }
}
}
