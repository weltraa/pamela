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
  @Query(sort: \TaskItem.createdAt) private var tasks: [TaskItem]

  @State private var selectedDate = Date.now
  @State private var viewModel = TaskItemsTabViewModel()

  var body: some View {
    let orphanTasks = viewModel.orphanTasks(from: tasks, on: selectedDate)
    let dailyTasks = viewModel.dailyTasks(from: tasks, on: selectedDate)
    let weeklyTasks = viewModel.weeklyTasks(from: tasks, on: selectedDate)

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
      else if orphanTasks.isEmpty && dailyTasks.isEmpty && weeklyTasks.isEmpty {
        NoEntriesNotice(
          icon: "calendar",
          title: "Nothing for this day",
          description: "No tasks are scheduled for this day."
        )
      }
      else {
        List {
          TaskSection(
            title: "Orphan Tasks",
            tasks: orphanTasks,
            day: selectedDate,
            viewModel: viewModel
          )

          TaskSection(
            title: "Daily",
            tasks: dailyTasks,
            day: selectedDate,
            viewModel: viewModel
          )

          TaskSection(
            title: "Weekly",
            tasks: weeklyTasks,
            day: selectedDate,
            viewModel: viewModel
          )
        }
        .listStyle(.sidebar)
        .contentMargins(.top, 16, for: .scrollContent)
      }
    }
    .sheet(item: $viewModel.taskToEdit) { task in
      TaskFrequencyForm(task: task)
    }
    .onReceive(
      NotificationCenter.default.publisher(
        for: UIApplication.significantTimeChangeNotification
      )
    ) { _ in
      // The day changed (e.g. midnight): jump back to today.
      selectedDate = .now
    }
  }
}

// MARK: - Subviews

private struct TaskSection: View {
  let title: String
  let tasks: [TaskItem]
  let day: Date
  let viewModel: TaskItemsTabViewModel

  private var isExpanded: Binding<Bool> {
    Binding(
      get: { viewModel.isExpanded(title) },
      set: { viewModel.setExpanded($0, for: title) }
    )
  }

  var body: some View {
    if !tasks.isEmpty {
      Section(isExpanded: isExpanded) {
        ForEach(tasks) { task in
          TaskRow(task: task, day: day, viewModel: viewModel)
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
  let viewModel: TaskItemsTabViewModel

  @State private var isEditingTitle = false
  @State private var draftTitle = ""
  @FocusState private var isTitleFocused: Bool

  var body: some View {
    let isDone = task.isDone(on: day)

    Group {
      if isEditingTitle {
        TextField("Title", text: $draftTitle)
          .focused($isTitleFocused)
          .submitLabel(.done)
          .onSubmit(commitTitle)
          .onAppear { isTitleFocused = true }
          .onChange(of: isTitleFocused) { _, isFocused in
            if !isFocused { commitTitle() }
          }
          // The row can vanish mid-edit (e.g. picking another day).
          .onDisappear(perform: commitTitle)
      }
      else {
        Text(task.title)
          .strikethrough(isDone)
          .foregroundStyle(isDone ? Color.secondary : Color.primary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .contentShape(.rect)
          .onTapGesture(perform: startEditingTitle)
          .accessibilityAddTraits(.isButton)
          .accessibilityHint("Edits the title")
          .accessibilityValue(isDone ? "Completed" : "")
      }
    }
    .swipeActions(edge: .leading) {
      if viewModel.canComplete(on: day) {
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
    }
    .swipeActions(edge: .trailing) {
      Button(role: .destructive) {
        isEditingTitle = false
        withAnimation {
          modelContext.delete(task)
        }
      } label: {
        Label("Delete", systemImage: "trash")
      }

      Button {
        viewModel.taskToEdit = task
      } label: {
        Label("Repeat", systemImage: "repeat")
      }
      .tint(.indigo)
    }
  }

  private func startEditingTitle() {
    draftTitle = task.title
    isEditingTitle = true
  }

  /// Saves the new title; an empty title keeps the previous one.
  private func commitTitle() {
    guard isEditingTitle, !task.isDeleted
    else { return }

    isEditingTitle = false

    let trimmed = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    if !trimmed.isEmpty {
      task.title = trimmed
    }
  }
}

#Preview {
  TasksTabView()
    .modelContainer(for: TaskItem.self, inMemory: false)
}
