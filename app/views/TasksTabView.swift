//
//  TasksTabView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct TasksTabView: View {
  @Query private var tasks: [TaskItem]

  @State private var selectedDate = Date.now
  @State private var viewModel = TaskItemsTabViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      Text("My Tasks").font(.title).bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)

      WeekCalendarView(selectedDate: $selectedDate)

      if tasks.isEmpty {
        NoEntriesNotice(
          icon: "checklist",
          title: "No tasks yet",
          description: "Tap + to add your first task."
        )
      }
      else {
        List {
          TaskSection(
            title: "Orphan Tasks",
            tasks: viewModel.orphanTasks(from: tasks),
            day: selectedDate,
            viewModel: viewModel
          )
          
          TaskSection(
            title: "Daily",
            tasks: viewModel.dailyTasks(from: tasks),
            day: selectedDate,
            viewModel: viewModel
          )
          
          TaskSection(
            title: "Weekly",
            tasks: viewModel.weeklyTasks(from: tasks, on: selectedDate),
            day: selectedDate,
            viewModel: viewModel
          )
        }
        .listStyle(.sidebar)
        .contentMargins(.top, 16, for: .scrollContent)
      }
    }
  }
}

// MARK: - Subviews

private struct TaskSection: View {
  let title: String
  let tasks: [TaskItem]
  let day: Date
  let viewModel: TaskItemsTabViewModel

  @State private var isExpanded = true

  var body: some View {
    if !tasks.isEmpty {
      Section(isExpanded: $isExpanded) {
        ForEach(tasks) { task in
          TaskRow(task: task, day: day)
        }
      } header: {
        HStack {
          Text(title)
          Spacer()
          Text("\(viewModel.completedCount(of: tasks, on: day))/\(tasks.count)")
            .monospacedDigit()
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

private struct TaskRow: View {
  @Environment(\.modelContext) private var modelContext

  let task: TaskItem
  let day: Date

  var body: some View {
    let isDone = task.isDone(on: day)
    
    Text(task.title)
      .strikethrough(isDone)
      .foregroundStyle(isDone ? Color.secondary : Color.primary)
      .swipeActions(edge: .leading) {
        Button {
          withAnimation { task.toggleDone(on: day) }
        } label: {
          Label(
            isDone ? "Undo" : "Done",
            systemImage: isDone ? "arrow.uturn.backward" : "checkmark"
          )
        }
        .tint(.green)
      }
      .swipeActions(edge: .trailing) {
        Button(role: .destructive) {
          withAnimation {
            modelContext.delete(task)
          }
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
  }
}

#Preview {
  TasksTabView()
    .modelContainer(for: TaskItem.self, inMemory: false)
}
