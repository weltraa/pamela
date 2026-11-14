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

  /// Task whose frequency is being edited; drives the edit sheet.
  var taskToEdit: TaskItem?

  /// Kept here (not in each section) so a collapsed section stays collapsed
  /// when the list is rebuilt, e.g. after visiting a day with no tasks.
  private var collapsedSections: Set<String> = []

  init(calendar: Calendar = .current) {
    self.calendar = calendar
  }

  func isExpanded(_ section: String) -> Bool {
    !collapsedSections.contains(section)
  }

  func setExpanded(_ isExpanded: Bool, for section: String) {
    if isExpanded {
      collapsedSections.remove(section)
    } else {
      collapsedSections.insert(section)
    }
  }

  /// Tasks can't be completed ahead of time.
  func canComplete(on day: Date) -> Bool {
    calendar.startOfDay(for: day) <= calendar.startOfDay(for: .now)
  }

  func completedCount(of tasks: [TaskItem], on day: Date) -> Int {
    tasks.filter { $0.isDone(on: day, calendar: calendar) }.count
  }

  func orphanTasks(from tasks: [TaskItem], on day: Date) -> [TaskItem] {
    tasks.filter { $0.frequency == .none && exists($0, on: day) }
  }

  func dailyTasks(from tasks: [TaskItem], on day: Date) -> [TaskItem] {
    tasks.filter { $0.frequency == .daily && exists($0, on: day) }
  }

  func weeklyTasks(from tasks: [TaskItem], on day: Date) -> [TaskItem] {
    let weekday = calendar.component(.weekday, from: day)
    let dayFlag = TaskItem.Weekdays(rawValue: 1 << (weekday - 1))

    return tasks.filter { task in
      guard
        case .weekly(let days) = task.frequency,
        exists(task, on: day)
      else { return false }

      return days.contains(dayFlag)
    }
  }

  /// A task only shows up from the day it was created onwards.
  private func exists(_ task: TaskItem, on day: Date) -> Bool {
    calendar.startOfDay(for: task.createdAt) <= calendar.startOfDay(for: day)
  }
}
